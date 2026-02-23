#!/usr/bin/env bash

doctor() {
  require curl
  require tar
  require jq
  require sha256sum
  require flock

  if [[ ":$PATH:" != *":$HOME/.jtools/bin:"* ]]; then
    warn "~/.jtools/bin não está no PATH."
  else
    success "PATH OK"
  fi

  success "Doctor finalizado."
}
