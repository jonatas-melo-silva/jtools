#!/usr/bin/env bash
set -euo pipefail

install_package() {
  local tool="$1"
  shift

  FORCE=false
  DRY_RUN=false
  USE_LOCAL=false

  for arg in "$@"; do
    case "$arg" in
      --force) FORCE=true ;;
      --dry-run) DRY_RUN=true ;;
      --local) USE_LOCAL=true ;;
      *) error "Argumento desconhecido: $arg" ;;
    esac
  done

  source "$(dirname "$0")/../packages/${tool}.sh" ||
    error "Pacote '$tool' não encontrado."

  ensure_dirs
  init_state

  require curl
  require tar
  require jq
  require sha256sum
  require flock

  LOCK_FILE="$HOME/.jtools/install.lock"
  exec 9> "$LOCK_FILE"
  flock -n 9 || error "Outro processo já está rodando."

  log "Buscando versão mais recente..."
  REMOTE_VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
    jq -r .tag_name | sed 's/^v//') ||
    error "Falha ao obter versão"

  CURRENT_VERSION=$(state_get "$tool")

  log "Remota: $REMOTE_VERSION"
  log "Instalada: ${CURRENT_VERSION:-none}"

  if [[ "$CURRENT_VERSION" == "$REMOTE_VERSION" && "$FORCE" == false ]]; then
    log "Já está atualizado."
    exit 0
  fi

  if [[ "$DRY_RUN" == true ]]; then
    log "Dry-run ativado. Instalação prevista da versão $REMOTE_VERSION"
    exit 0
  fi

  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT
  cd "$TMP_DIR"

  TARBALL=$(echo "$TARBALL_TEMPLATE" | sed "s/{VERSION}/$REMOTE_VERSION/")
  URL="https://github.com/$REPO/releases/download/v${REMOTE_VERSION}/${TARBALL}"

  log "Baixando..."
  curl -fL -o "$TARBALL" "$URL" || error "Download falhou"

  if [[ -n "${CHECKSUM_FILE:-}" ]]; then
    log "Baixando checksum..."
    curl -fL -o "$CHECKSUM_FILE" \
      "https://github.com/$REPO/releases/download/v${REMOTE_VERSION}/${CHECKSUM_FILE}" ||
      warn "Checksum não disponível"

    if [[ -f "$CHECKSUM_FILE" ]]; then
      grep "$TARBALL" "$CHECKSUM_FILE" | sha256sum -c - ||
        error "Checksum inválido"
    fi
  fi

  tar -xf "$TARBALL" "$BINARY_NAME"

  DEST="$HOME/.jtools/bin"
  [[ "$USE_LOCAL" == true ]] && DEST="$HOME/.local/bin"

  mkdir -p "$DEST"
  install -m 0755 "$BINARY_NAME" "$DEST/$BINARY_NAME"

  state_set "$tool" "$REMOTE_VERSION"

  success "$tool $REMOTE_VERSION instalado em $DEST"
}
