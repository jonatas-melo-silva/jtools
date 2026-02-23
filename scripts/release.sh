#!/usr/bin/env bash

set -euo pipefail

BUMP_TYPE="${1:-patch}"

if [[ ! -f VERSION ]]; then
  echo "❌ VERSION file not found"
  exit 1
fi

CURRENT_VERSION="$(tr -d '[:space:]' < VERSION)"

if ! [[ "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "❌ VERSION file must follow format X.Y.Z"
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case "$BUMP_TYPE" in
  major)
    ((MAJOR++))
    MINOR=0
    PATCH=0
    ;;
  minor)
    ((MINOR++))
    PATCH=0
    ;;
  patch)
    ((PATCH++))
    ;;
  *)
    echo "❌ Usage: ./scripts/release.sh [major|minor|patch]"
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
TAG="v${NEW_VERSION}"

BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [[ "$BRANCH" != "main" ]]; then
  echo "❌ Releases must be created from main branch"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ Working tree not clean"
  exit 1
fi

echo "🔎 Checking commits since last tag..."

LAST_TAG=$(git describe --tags --abbrev=0 2> /dev/null || true)

if [[ -n "${LAST_TAG:-}" ]]; then
  COMMITS_SINCE=$(git rev-list "${LAST_TAG}"..HEAD --count)

  if [[ "$COMMITS_SINCE" -eq 0 ]]; then
    echo "❌ No commits since last tag ($LAST_TAG)"
    exit 1
  fi

  RANGE="${LAST_TAG}..HEAD"
else
  RANGE="HEAD"
fi

echo "🔎 Validating commit messages (Conventional Commits)..."

INVALID_COMMITS=$(
  git log "$RANGE" --pretty=format:"%s" --no-merges |
    grep -Ev '^(feat|fix|chore|docs|refactor|test|perf)(\(.+\))?: .+' || true
)

if [[ -n "$INVALID_COMMITS" ]]; then
  echo "❌ Invalid commit messages detected:"
  echo "$INVALID_COMMITS"
  exit 1
fi

if git rev-parse "$TAG" > /dev/null 2>&1; then
  echo "❌ Tag $TAG already exists"
  exit 1
fi

echo "$NEW_VERSION" > VERSION

git add VERSION
git commit -m "chore: bump version to ${NEW_VERSION}"

echo "🚀 Creating tag $TAG"

git tag -a "$TAG" -m "release: $TAG"
git push origin main
git push origin "$TAG"

echo "📦 Creating GitHub release"

gh release create "$TAG" \
  --title "$TAG" \
  --generate-notes

echo "✅ Release $TAG created successfully"
