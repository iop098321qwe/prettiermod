# Prettiermod

A module for using `prettier` via `npx` for different file types.

## Usage

Load the CBC module, then run `pretty` from the directory you want to format.

```bash
source ./cbc-module.sh
pretty
pretty help
```

Running `pretty` with no arguments is equivalent to `pretty all`.

Formatter commands run Prettier through `npx`. By default, `pretty` passes
`--write`, so matching files are updated in place.

Directory flags must appear after formatter commands and before `--`.

When formatting Markdown, `pretty` skips only the exact root
`CHANGELOG.md` path.
`site/CHANGELOG.md` is the only allowed exception.

Pass multiple file types as separate arguments:

```bash
pretty html js css
pretty web mjml
pretty all -d site
pretty web -dr '^site$'
```

Comma-separated file types are not supported. Use `pretty html js css` instead
of `pretty html,js,css`.

Pass Prettier options after `--`:

```bash
pretty web -- --check
pretty html js -- --config .prettierrc
pretty all -d site -- --check
```

When passthrough options include `--check`, `-c`, `--list-different`, `-l`, or
`--debug-check`, `pretty` omits its default `--write` flag.

## Directory Targeting

Target a single relative directory with `-d`:

```bash
pretty all -d site
pretty md -d docs
```

Combine `-d` with `-r` to treat the directory value as a regex over full
relative directory paths beneath the current directory:

```bash
pretty web -dr '^site$'
pretty md -rd '^(docs|site)$'
```

When a directory regex matches more than one directory, `pretty` runs against
every matched directory.

## Shortcuts

| Command      | Expands to                                                                           |
| ------------ | ------------------------------------------------------------------------------------ |
| `pretty`     | `css graphql hbs html js json json5 jsonc jsx less md mdx mjml scss ts tsx vue yaml` |
| `pretty web` | `html css scss less js jsx ts tsx vue json json5 jsonc yaml md mdx graphql hbs`      |
| `pretty all` | `css graphql hbs html js json json5 jsonc jsx less md mdx mjml scss ts tsx vue yaml` |

Shortcuts can be combined with explicit file types. Duplicate file types are
deduplicated in first-seen order.

## Commands

| Command          | Files                                                                            |
| ---------------- | -------------------------------------------------------------------------------- |
| `pretty css`     | `**/*.css`                                                                       |
| `pretty graphql` | `**/*.{graphql,gql}`                                                             |
| `pretty hbs`     | `**/*.{hbs,handlebars}`                                                          |
| `pretty html`    | `**/*.html`                                                                      |
| `pretty js`      | `**/*.{js,cjs,mjs}`                                                              |
| `pretty json`    | `**/*.json`                                                                      |
| `pretty json5`   | `**/*.json5`                                                                     |
| `pretty jsonc`   | `**/*.jsonc`                                                                     |
| `pretty jsx`     | `**/*.jsx`                                                                       |
| `pretty less`    | `**/*.less`                                                                      |
| `pretty md`      | `**/*.{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}` except exact root `CHANGELOG.md` |
| `pretty mdx`     | `**/*.mdx`                                                                       |
| `pretty mjml`    | `**/*.mjml`                                                                      |
| `pretty scss`    | `**/*.scss`                                                                      |
| `pretty ts`      | `**/*.{ts,cts,mts}`                                                              |
| `pretty tsx`     | `**/*.tsx`                                                                       |
| `pretty vue`     | `**/*.vue`                                                                       |
| `pretty yaml`    | `**/*.{yaml,yml}`                                                                |

Formatter commands let Prettier infer the parser from each matching file path.
