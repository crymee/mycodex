#!/usr/bin/env bash
set -euo pipefail

# Public bootstrap installer for mycodex.
# Host this file at a stable HTTPS URL such as:
#   https://your-domain.example/install.sh
# and host the main executable next to it:
#   https://your-domain.example/mycodex
#
# End-user usage:
#   curl -fsSL https://your-domain.example/install.sh | bash
#
# Optional overrides:
#   MYCODEX_DOWNLOAD_URL=https://your-domain.example/mycodex
#   MYCODEX_INSTALL_ROOT=$HOME/.local/share/mycodex
#   MYCODEX_INSTALL_CODEX=auto|skip

DEFAULT_DOWNLOAD_URL="https://raw.githubusercontent.com/crymee/mycodex/main/mycodex"
MYCODEX_DOWNLOAD_URL="${MYCODEX_DOWNLOAD_URL:-$DEFAULT_DOWNLOAD_URL}"
MYCODEX_INSTALL_ROOT="${MYCODEX_INSTALL_ROOT:-$HOME/.local/share/mycodex}"
MYCODEX_INSTALL_CODEX="${MYCODEX_INSTALL_CODEX:-auto}"
MYCODEX_TARGET="$MYCODEX_INSTALL_ROOT/mycodex"

info() {
  printf 'mycodex-install: %s\n' "$1"
}

warn() {
  printf 'mycodex-install: %s\n' "$1" >&2
}

fail() {
  printf 'mycodex-install: %s\n' "$1" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

download_mycodex() {
  local tmp
  tmp="$(mktemp)"

  info "downloading mycodex from $MYCODEX_DOWNLOAD_URL"
  if ! curl -fsSL "$MYCODEX_DOWNLOAD_URL" -o "$tmp"; then
    rm -f "$tmp"
    fail "failed to download mycodex from $MYCODEX_DOWNLOAD_URL"
  fi
  mkdir -p "$MYCODEX_INSTALL_ROOT"
  install -m 0755 "$tmp" "$MYCODEX_TARGET"
  rm -f "$tmp"
}

install_codex_if_needed() {
  if command -v codex >/dev/null 2>&1; then
    info "codex already installed"
    return
  fi

  case "$MYCODEX_INSTALL_CODEX" in
    skip)
      warn "codex is not installed; skipping because MYCODEX_INSTALL_CODEX=skip"
      return
      ;;
    auto)
      if command -v npm >/dev/null 2>&1; then
        info "installing codex via npm"
        npm install -g @openai/codex
        return
      fi
      if command -v brew >/dev/null 2>&1; then
        info "installing codex via Homebrew"
        brew install --cask codex
        return
      fi
      fail "codex is missing and no supported installer was found. Install Node+npm or Homebrew first, or rerun with MYCODEX_INSTALL_CODEX=skip."
      ;;
    *)
      fail "unsupported MYCODEX_INSTALL_CODEX value: $MYCODEX_INSTALL_CODEX"
      ;;
  esac
}

main() {
  need_cmd curl
  need_cmd install

  download_mycodex
  install_codex_if_needed

  info "running mycodex install"
  "$MYCODEX_TARGET" install
  info "done"
}

main "$@"
