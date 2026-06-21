#!/usr/bin/env bash

function pretty() {
  local -a formatter_args=()
  local -a prettier_args=()
  local -a selected_types=()
  local -a unique_types=()
  local -a globs=()
  local add_write=true
  local already_selected
  local arg
  local passthrough=false
  local seen
  local type

  if (($# == 0)); then
    set -- help
  fi

  if (($# == 1)); then
    case "$1" in
      help|-h|--help)
        cat <<'USAGE'
Usage: pretty <command> [command ...] [-- <prettier-option>...]

Commands:
  css      Format CSS files recursively from the current directory
  graphql  Format GraphQL files recursively from the current directory
  hbs      Format Handlebars files recursively from the current directory
  html     Format HTML files recursively from the current directory
  js       Format JavaScript files recursively from the current directory
  json     Format JSON files recursively from the current directory
  json5    Format JSON5 files recursively from the current directory
  jsonc    Format JSONC files recursively from the current directory
  jsx      Format JSX files recursively from the current directory
  less     Format Less files recursively from the current directory
  md       Format Markdown files recursively from the current directory
  mdx      Format MDX files recursively from the current directory
  mjml     Format MJML files recursively from the current directory
  scss     Format SCSS files recursively from the current directory
  ts       Format TypeScript files recursively from the current directory
  tsx      Format TSX files recursively from the current directory
  vue      Format Vue files recursively from the current directory
  yaml     Format YAML files recursively from the current directory

Shortcuts:
  web      Format common frontend files
  all      Format all supported files
  help     Show this help message

Examples:
  pretty html js css
  pretty web -- --check
USAGE
        return 0
        ;;
    esac
  fi

  for arg in "$@"; do
    if [[ "$passthrough" == false && "$arg" == "--" ]]; then
      passthrough=true
      continue
    fi

    if [[ "$passthrough" == true ]]; then
      prettier_args+=("$arg")
    else
      formatter_args+=("$arg")
    fi
  done

  if ((${#formatter_args[@]} == 0)); then
    printf 'pretty: missing formatter command\n' >&2
    printf 'Run `pretty help` for usage.\n' >&2
    return 1
  fi

  for type in "${formatter_args[@]}"; do
    if [[ "$type" == *","* ]]; then
      printf 'pretty: comma-separated formatter types are unsupported: %s\n' \
        "$type" >&2
      printf 'Use spaces instead, for example: pretty html js css\n' >&2
      return 1
    fi

    case "$type" in
      help|-h|--help)
        printf 'pretty: help can only be used by itself\n' >&2
        printf 'Run `pretty help` for usage.\n' >&2
        return 1
        ;;
      web)
        selected_types+=(
          html css scss less js jsx ts tsx vue json json5 jsonc yaml md mdx
          graphql hbs
        )
        ;;
      all)
        selected_types+=(
          css graphql hbs html js json json5 jsonc jsx less md mdx mjml scss
          ts tsx vue yaml
        )
        ;;
      css|graphql|hbs|html|js|json|json5|jsonc|jsx|less)
        selected_types+=("$type")
        ;;
      md|mdx|mjml|scss|ts|tsx|vue|yaml)
        selected_types+=("$type")
        ;;
      -*)
        printf 'pretty: prettier options must follow `--`: %s\n' \
          "$type" >&2
        printf 'Example: pretty html js -- --check\n' >&2
        return 1
        ;;
      *)
        printf 'pretty: unknown formatter command: %s\n' "$type" >&2
        printf 'Run `pretty help` for usage.\n' >&2
        return 1
        ;;
    esac
  done

  for type in "${selected_types[@]}"; do
    already_selected=false

    for seen in "${unique_types[@]}"; do
      if [[ "$seen" == "$type" ]]; then
        already_selected=true
        break
      fi
    done

    if [[ "$already_selected" == false ]]; then
      unique_types+=("$type")
    fi
  done

  for arg in "${prettier_args[@]}"; do
    case "$arg" in
      --check|-c|--list-different|-l|--debug-check)
        add_write=false
        ;;
    esac
  done

  for type in "${unique_types[@]}"; do
    case "$type" in
      css)
        globs+=("**/*.css")
        ;;
      graphql)
        globs+=("**/*.{graphql,gql}")
        ;;
      hbs)
        globs+=("**/*.{hbs,handlebars}")
        ;;
      html)
        globs+=("**/*.html")
        ;;
      js)
        globs+=("**/*.{js,cjs,mjs}")
        ;;
      json)
        globs+=("**/*.json")
        ;;
      json5)
        globs+=("**/*.json5")
        ;;
      jsonc)
        globs+=("**/*.jsonc")
        ;;
      jsx)
        globs+=("**/*.jsx")
        ;;
      less)
        globs+=("**/*.less")
        ;;
      md)
        globs+=("**/*.{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}")
        ;;
      mdx)
        globs+=("**/*.mdx")
        ;;
      mjml)
        globs+=("**/*.mjml")
        ;;
      scss)
        globs+=("**/*.scss")
        ;;
      ts)
        globs+=("**/*.{ts,cts,mts}")
        ;;
      tsx)
        globs+=("**/*.tsx")
        ;;
      vue)
        globs+=("**/*.vue")
        ;;
      yaml)
        globs+=("**/*.{yaml,yml}")
        ;;
    esac
  done

  if [[ "$add_write" == true ]]; then
    npx --yes prettier --write "${prettier_args[@]}" "${globs[@]}"
  else
    npx --yes prettier "${prettier_args[@]}" "${globs[@]}"
  fi
}
