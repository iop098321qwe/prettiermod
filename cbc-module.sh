#!/usr/bin/env bash

function pretty() {
  local command="${1:-help}"

  case "$command" in
    help|-h|--help)
      cat <<'USAGE'
Usage: pretty <command>

Commands:
  html  Format HTML files recursively from the current directory
  js    Format JavaScript files recursively from the current directory
  jsx   Format JSX files recursively from the current directory
  ts    Format TypeScript files recursively from the current directory
  tsx   Format TSX files recursively from the current directory
  help  Show this help message
USAGE
      ;;
    html)
      npx --yes prettier --write "**/*.html"
      ;;
    js)
      npx --yes prettier --write "**/*.{js,cjs,mjs}"
      ;;
    jsx)
      npx --yes prettier --write "**/*.jsx"
      ;;
    ts)
      npx --yes prettier --write "**/*.{ts,cts,mts}"
      ;;
    tsx)
      npx --yes prettier --write "**/*.tsx"
      ;;
    *)
      printf 'pretty: unknown command: %s\n' "$command" >&2
      printf 'Run `pretty help` for usage.\n' >&2
      return 1
      ;;
  esac
}
