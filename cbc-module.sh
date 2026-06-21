#!/usr/bin/env bash

function pretty() {
  local command="${1:-help}"

  case "$command" in
    help|-h|--help)
      cat <<'USAGE'
Usage: pretty <command>

Commands:
  html  Format HTML files recursively from the current directory
  help  Show this help message
USAGE
      ;;
    html)
      npx --yes prettier --write "**/*.html"
      ;;
    *)
      printf 'pretty: unknown command: %s\n' "$command" >&2
      printf 'Run `pretty help` for usage.\n' >&2
      return 1
      ;;
  esac
}
