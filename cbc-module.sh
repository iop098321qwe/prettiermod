#!/usr/bin/env bash

function pretty() {
  local command="${1:-help}"

  case "$command" in
    help|-h|--help)
      cat <<'USAGE'
Usage: pretty <command>

Commands:
  angular  Format Angular templates recursively from the current directory
  css   Format CSS files recursively from the current directory
  graphql  Format GraphQL files recursively from the current directory
  hbs   Format Handlebars files recursively from the current directory
  html  Format HTML files recursively from the current directory
  js    Format JavaScript files recursively from the current directory
  json  Format JSON files recursively from the current directory
  json5 Format JSON5 files recursively from the current directory
  jsonc Format JSONC files recursively from the current directory
  jsx   Format JSX files recursively from the current directory
  less  Format Less files recursively from the current directory
  md    Format Markdown files recursively from the current directory
  mdx   Format MDX files recursively from the current directory
  mjml  Format MJML files recursively from the current directory
  scss  Format SCSS files recursively from the current directory
  ts    Format TypeScript files recursively from the current directory
  tsx   Format TSX files recursively from the current directory
  vue   Format Vue files recursively from the current directory
  yaml  Format YAML files recursively from the current directory
  help  Show this help message
USAGE
      ;;
    angular)
      npx --yes prettier --write --parser angular "**/*.component.html"
      ;;
    css)
      npx --yes prettier --write "**/*.css"
      ;;
    graphql)
      npx --yes prettier --write "**/*.{graphql,gql}"
      ;;
    hbs)
      npx --yes prettier --write "**/*.{hbs,handlebars}"
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
    json5)
      npx --yes prettier --write "**/*.json5"
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
    md)
      npx --yes prettier --write \
        "**/*.{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}"
      ;;
    mdx)
      npx --yes prettier --write "**/*.mdx"
      ;;
    mjml)
      npx --yes prettier --write "**/*.mjml"
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
    vue)
      npx --yes prettier --write "**/*.vue"
      ;;
    yaml)
      npx --yes prettier --write "**/*.{yaml,yml}"
      ;;
    *)
      printf 'pretty: unknown command: %s\n' "$command" >&2
      printf 'Run `pretty help` for usage.\n' >&2
      return 1
      ;;
  esac
}
