#!/usr/bin/env bash

function pretty() {
  local command="${1:-help}"

  case "$command" in
    help|-h|--help)
      cat <<'USAGE'
Usage: pretty <command>

Commands:
  css   Format CSS files recursively from the current directory
  html  Format HTML files recursively from the current directory
  js    Format JavaScript files recursively from the current directory
  json  Format JSON files recursively from the current directory
  jsonc Format JSONC files recursively from the current directory
  jsx   Format JSX files recursively from the current directory
  less  Format Less files recursively from the current directory
  scss  Format SCSS files recursively from the current directory
  ts    Format TypeScript files recursively from the current directory
  tsx   Format TSX files recursively from the current directory
  help  Show this help message
USAGE
      ;;
    css)
      npx --yes prettier --write "**/*.css"
      ;;
    html)
      npx --yes prettier --write "**/*.html"
      ;;
    js)
      npx --yes prettier --write "**/*.{js,cjs,mjs}"
      ;;
    json)
      npx --yes prettier --write "**/*.json"
      ;;
    jsonc)
      npx --yes prettier --write "**/*.jsonc"
      ;;
    jsx)
      npx --yes prettier --write "**/*.jsx"
      ;;
    less)
      npx --yes prettier --write "**/*.less"
      ;;
    scss)
      npx --yes prettier --write "**/*.scss"
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
