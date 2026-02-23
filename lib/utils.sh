#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $1"; }
error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }

require() {
  command -v "$1" > /dev/null || error "Dependência '$1' não encontrada."
}

ensure_dirs() {
  mkdir -p "$HOME/.jtools/bin"
  mkdir -p "$HOME/.jtools/apps"
}
