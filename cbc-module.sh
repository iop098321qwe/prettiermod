#!/usr/bin/env bash

function pretty() {
  local -a base_globs=()
  local -a formatter_args=()
  local -a prettier_args=()
  local -a selected_types=()
  local -a target_dirs=()
  local -a unique_types=()
  local -a globs=()
  local add_write=true
  local already_selected
  local arg
  local candidate
  local directory_value=""
  local directory_value_set=false
  local directory_flags_started=false
  local dotglob_was_set
  local globstar_was_set
  local nullglob_was_set
  local passthrough=false
  local regex_status
  local seen
  local target_dir
  local type
  local use_directory_regex=false

  if (($# == 0)); then
    set -- all
  fi

  if (($# == 1)); then
    case "$1" in
      help|-h|--help)
        cat <<'USAGE'
Usage: pretty <command> [command ...] [directory-flag ...]
  [-- <prettier-option>...]

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

Directory Flags:
  -d <dir>    Format only within the given relative directory
  -r          Treat the `-d` value as a regex over relative directories
  -dr <expr>  Combine `-d` and `-r`
  -rd <expr>  Combine `-r` and `-d`

Examples:
  pretty html js css
  pretty all -d site
  pretty web -dr '^site$'
  pretty web -- --check
USAGE
        return 0
        ;;
    esac
  fi

  while (($# > 0)); do
    arg="$1"
    shift

    if [[ "$passthrough" == false && "$arg" == "--" ]]; then
      passthrough=true
      continue
    fi

    if [[ "$passthrough" == true ]]; then
      prettier_args+=("$arg")
      continue
    fi

    case "$arg" in
      -d)
        if ((${#formatter_args[@]} == 0)); then
          printf 'pretty: formatter commands must appear before directory flags\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        directory_flags_started=true

        if [[ "$directory_value_set" == true ]]; then
          printf 'pretty: only one directory selector may be used\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        if (($# == 0)); then
          printf 'pretty: missing directory after `-d`\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        directory_value="$1"
        directory_value_set=true
        shift
        ;;
      -dr|-rd)
        if ((${#formatter_args[@]} == 0)); then
          printf 'pretty: formatter commands must appear before directory flags\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        directory_flags_started=true
        use_directory_regex=true

        if [[ "$directory_value_set" == true ]]; then
          printf 'pretty: only one directory selector may be used\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        if (($# == 0)); then
          printf 'pretty: missing directory regex after `%s`\n' "$arg" >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        directory_value="$1"
        directory_value_set=true
        shift
        ;;
      -r)
        if ((${#formatter_args[@]} == 0)); then
          printf 'pretty: formatter commands must appear before directory flags\n' >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        directory_flags_started=true
        use_directory_regex=true
        ;;
      -*)
        if [[ "$directory_flags_started" == true ]]; then
          printf 'pretty: unknown directory flag: %s\n' "$arg" >&2
          printf 'Run `pretty help` for usage.\n' >&2
        else
          printf 'pretty: prettier options must follow `--`: %s\n' \
            "$arg" >&2
          printf 'Example: pretty html js -- --check\n' >&2
        fi

        return 1
        ;;
      *)
        if [[ "$directory_flags_started" == true ]]; then
          printf 'pretty: formatter commands must appear before directory flags: %s\n' "$arg" >&2
          printf 'Run `pretty help` for usage.\n' >&2
          return 1
        fi

        formatter_args+=("$arg")
        ;;
    esac
  done

  if [[ "$use_directory_regex" == true && "$directory_value_set" == false ]]; then
    printf 'pretty: `-r` requires `-d <directory>` or `-dr <regex>`\n' >&2
    printf 'Run `pretty help` for usage.\n' >&2
    return 1
  fi

  if [[ "$directory_value_set" == true && "$use_directory_regex" == false ]]; then
    directory_value="${directory_value%/}"

    if [[ -z "$directory_value" ]]; then
      directory_value='.'
    fi

    if [[ ! -d "$directory_value" ]]; then
      printf 'pretty: directory does not exist: %s\n' "$directory_value" >&2
      return 1
    fi

    target_dirs+=("$directory_value")
  elif [[ "$directory_value_set" == true && "$use_directory_regex" == true ]]; then
    [[ '' =~ $directory_value ]] 2>/dev/null
    regex_status=$?

    if ((regex_status == 2)); then
      printf 'pretty: invalid directory regex: %s\n' "$directory_value" >&2
      return 1
    fi

    shopt -q globstar
    globstar_was_set=$?
    shopt -q nullglob
    nullglob_was_set=$?
    shopt -q dotglob
    dotglob_was_set=$?

    shopt -s globstar nullglob dotglob

    for candidate in **/; do
      candidate="${candidate%/}"

      if [[ -z "$candidate" || "$candidate" == '.' ]]; then
        continue
      fi

      if [[ "$candidate" =~ $directory_value ]]; then
        target_dirs+=("$candidate")
      fi
    done

    if ((globstar_was_set != 0)); then
      shopt -u globstar
    fi

    if ((nullglob_was_set != 0)); then
      shopt -u nullglob
    fi

    if ((dotglob_was_set != 0)); then
      shopt -u dotglob
    fi

    if ((${#target_dirs[@]} == 0)); then
      printf 'pretty: no directories matched regex: %s\n' "$directory_value" \
        >&2
      return 1
    fi
  fi

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
        base_globs+=("**/*.css")
        ;;
      graphql)
        base_globs+=("**/*.{graphql,gql}")
        ;;
      hbs)
        base_globs+=("**/*.{hbs,handlebars}")
        ;;
      html)
        base_globs+=("**/*.html")
        ;;
      js)
        base_globs+=("**/*.{js,cjs,mjs}")
        ;;
      json)
        base_globs+=("**/*.json")
        ;;
      json5)
        base_globs+=("**/*.json5")
        ;;
      jsonc)
        base_globs+=("**/*.jsonc")
        ;;
      jsx)
        base_globs+=("**/*.jsx")
        ;;
      less)
        base_globs+=("**/*.less")
        ;;
      md)
        base_globs+=("!(CHANGELOG).{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}")
        base_globs+=("**/*/*.{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}")
        ;;
      mdx)
        base_globs+=("**/*.mdx")
        ;;
      mjml)
        base_globs+=("**/*.mjml")
        ;;
      scss)
        base_globs+=("**/*.scss")
        ;;
      ts)
        base_globs+=("**/*.{ts,cts,mts}")
        ;;
      tsx)
        base_globs+=("**/*.tsx")
        ;;
      vue)
        base_globs+=("**/*.vue")
        ;;
      yaml)
        base_globs+=("**/*.{yaml,yml}")
        ;;
    esac
  done

  if ((${#target_dirs[@]} == 0)); then
    globs=("${base_globs[@]}")
  else
    for target_dir in "${target_dirs[@]}"; do
      for arg in "${base_globs[@]}"; do
        globs+=("$target_dir/$arg")
      done
    done
  fi

  if [[ "$add_write" == true ]]; then
    npx --yes prettier --write "${prettier_args[@]}" "${globs[@]}"
  else
    npx --yes prettier "${prettier_args[@]}" "${globs[@]}"
  fi
}
