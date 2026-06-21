# Prettiermod

A module for using `prettier` via `npx` for different file types.

## Usage

Load the CBC module, then run `pretty` from the directory you want to format.

```bash
source ./cbc-module.sh
pretty help
```

Formatter commands run Prettier through `npx` with `--write`, so matching files
are updated in place.

| Command | Files |
| --- | --- |
| `pretty angular` | Angular `**/*.component.html` templates |
| `pretty css` | `**/*.css` |
| `pretty graphql` | `**/*.{graphql,gql}` |
| `pretty hbs` | `**/*.{hbs,handlebars}` |
| `pretty html` | `**/*.html` |
| `pretty js` | `**/*.{js,cjs,mjs}` |
| `pretty json` | `**/*.json` |
| `pretty json5` | `**/*.json5` |
| `pretty jsonc` | `**/*.jsonc` |
| `pretty jsx` | `**/*.jsx` |
| `pretty less` | `**/*.less` |
| `pretty md` | `**/*.{md,markdown,mdown,mkdn,mkd,mdwn,mkdown}` |
| `pretty mdx` | `**/*.mdx` |
| `pretty mjml` | `**/*.mjml` |
| `pretty scss` | `**/*.scss` |
| `pretty ts` | `**/*.{ts,cts,mts}` |
| `pretty tsx` | `**/*.tsx` |
| `pretty vue` | `**/*.vue` |
| `pretty yaml` | `**/*.{yaml,yml}` |

`pretty angular` uses Prettier's Angular parser. The other formatter commands
let Prettier infer the parser from each matching file path.
