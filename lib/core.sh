#!/usr/bin/env bash

core_install() { install_package "$@"; }

core_remove() {
  tool="$1"
  rm -f "$HOME/.jtools/bin/$tool"
  rm -f "$HOME/.local/bin/$tool"
  rm -rf "$HOME/.jtools/apps/$tool"
  state_remove "$tool"
  success "$tool removido."
}

core_list() { state_list; }

core_update() { install_package "$@"; }

core_upgrade_all() {
  for tool in $(state_list); do
    install_package "$tool"
  done
}
