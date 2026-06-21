# AGENTS.md

## Purpose

This file guides AI coding agents working in `prettiermod`.
All work must follow best practices and industry standards where
applicable.

## Scope

This file covers repository-wide expectations for code, docs, tooling,
and git work.
It does not replace verified instructions in source files, tooling
configs, nested `AGENTS.md` files, or release automation.

## Formatting Rules

- Keep lines at 80 characters or fewer when practical.
- Allow longer lines only for URLs, code blocks, tables, hashes, or
  commands that cannot be wrapped cleanly.
- Document any required line-length exception near the exception.

## Quick Start

- Read `README.md` first for project context and setup notes.
- Run `git status --short --branch` before editing to confirm repo
  state.
- Run `git diff --stat` before committing to review the change scope.
- Load the module with `source ./cbc-module.sh` before using `pretty`.
- Run `pretty help` to list available launcher commands.

## Environment

- Bash is required to source and run `cbc-module.sh`.
- Git is required for day-to-day work in this repository.
- Node.js and `npx` are required when running formatter commands.
- npm manages the commit tooling declared in `package.json`.
- `package-lock.json` records commitlint packages requiring Node
  `>=22.12.0`.
- No required environment variables are verified in this repository.

## Repository Overview

- `.github/workflows/`: GitHub Pages documentation deployment workflow.
- `.husky/`: Git hook that runs commitlint on commit messages.
- `docs/`: Zensical documentation source files.
- `site/`: Generated documentation site output.
- Root files define the CBC module, package metadata, docs config,
  license, and repo instructions.

## Tracked Files Overview

- `.github/workflows/docs.yml`: GitHub Pages documentation workflow.
- `.gitignore`: ignored local dependency and virtual environment paths.
- `.husky/commit-msg`: commit message hook running commitlint.
- `AGENTS.md`: root AI coding agent instructions.
- `LICENSE`: GNU GPL version 3 license text.
- `README.md`: primary project overview and `pretty` command reference.
- `cbc-module.sh`: CBC module entrypoint defining the `pretty` launcher.
- `commitlint.config.cjs`: Conventional Commits lint configuration.
- `docs/AGENTS.md`: symlink to the root AGENTS instructions.
- `docs/README.md`: symlink to the root README for docs source.
- `inbox.txt.tuxedo-lock`: empty tracked lock file.
  Verification needed: workflow purpose is not documented.
- `package-lock.json`: npm dependency lockfile for commit tooling.
- `package.json`: npm package metadata, scripts, and dev dependencies.
- `site/404.html`: generated documentation 404 page.
- `site/AGENTS/index.html`: generated AGENTS documentation page.
- `site/assets/images/favicon.png`: generated documentation favicon.
- `site/assets/javascripts/LICENSE`: generated JavaScript license data.
- `site/assets/javascripts/bundle.6e5f0216.min.js`: generated docs JS.
- `site/assets/javascripts/workers/search.e2d2d235.min.js`: search JS.
- `site/assets/stylesheets/classic/main.a2001754.min.css`: classic CSS.
- `site/assets/stylesheets/classic/palette.7dc9a0ad.min.css`: palette CSS.
- `site/assets/stylesheets/modern/main.fba56155.min.css`: modern CSS.
- `site/assets/stylesheets/modern/palette.dfe2e883.min.css`: palette CSS.
- `site/index.html`: generated documentation home page.
- `site/objects.inv`: generated documentation inventory.
- `site/search.json`: generated documentation search index.
- `site/sitemap.xml`: generated documentation sitemap.
- `todo.txt`: user-managed task file; agents must not touch it.
- `zensical.toml`: Zensical documentation site configuration.

## Architecture

- `cbc-module.sh` exposes the `pretty` Bash function.
- `pretty` dispatches subcommands through a `case` statement.
- Formatter arms call `npx --yes prettier --write` with quoted globs.
- `pretty angular` also passes `--parser angular` for component
  templates.
- The quoted globs are resolved by Prettier from the current directory.
- `package.json`, `.husky/commit-msg`, and `commitlint.config.cjs`
  enforce Conventional Commit messages.
- `docs/` is the source for documentation built into `site/` by
  Zensical.

## Commands

- `source ./cbc-module.sh`: load the `pretty` Bash function.
- `pretty help`: show available `pretty` subcommands.
- Formatter commands run recursively from the current directory.
- `pretty angular`: format Angular component templates.
- `pretty css`: format CSS files.
- `pretty graphql`: format GraphQL files.
- `pretty hbs`: format Handlebars files.
- `pretty html`: format HTML files.
- `pretty js`: format JavaScript files.
- `pretty json`: format JSON files.
- `pretty json5`: format JSON5 files.
- `pretty jsonc`: format JSONC files.
- `pretty jsx`: format JSX files.
- `pretty less`: format Less files.
- `pretty md`: format common Markdown files.
- `pretty mdx`: format MDX files.
- `pretty mjml`: format MJML files.
- `pretty scss`: format SCSS files.
- `pretty ts`: format TypeScript files.
- `pretty tsx`: format TSX files.
- `pretty vue`: format Vue files.
- `pretty yaml`: format YAML files.
- `bash -n cbc-module.sh`: check shell syntax.
- `bash -c 'source ./cbc-module.sh; pretty help'`: verify help output.
- `git status --short --branch`: show branch and worktree state.
- `git diff --stat`: review the size and spread of pending changes.
- `git log --oneline --decorate -5`: inspect recent commit history.
- `npm test`: scaffold script that exits with an error; no tests exist.
- `zensical build --clean`: build docs when Zensical is installed.

## Testing

- No automated passing test suite is verified in this repository.
- Use `bash -n cbc-module.sh` after shell changes.
- Use `pretty help` and an unknown command to verify dispatcher behavior.
- Shadow `npx` in a shell function to verify formatter commands safely.
- Do not run real formatter commands in the repo unless formatting
  tracked files is intended.

## Linting and Formatting

- `pretty` formatter commands format files through Prettier via `npx`.
- No shell linter is configured.
- Commit message linting is configured through commitlint and Husky.
- Keep changes minimal and consistent with existing shell style.

## CI and Release

- `.github/workflows/docs.yml` runs on pushes to `main` and `master`.
- The workflow installs Zensical with `pip install zensical`.
- The workflow runs `zensical build --clean` and deploys GitHub Pages.
- Use Conventional Commits for every commit. Prefer a scope when it
  adds clarity.
- Never create, edit, or update `CHANGELOG.md` manually.
- If release automation adds or changes generated files, let the
  tooling own those updates.

## Conventions

- Use small, correct changes that fit the existing project structure.
- Add new `pretty` subcommands as explicit `case` arms.
- Update `pretty help` and `README.md` when launcher commands change.
- Verify behavior from the actual codebase before documenting it.
- Keep `AGENTS.md` as instructions, not as a changelog, diary, or work
  log.
- Do not add update notes, status logs, or change summaries to
  `AGENTS.md`.
- Agents must never read, create, edit, delete, move, stage, commit,
  or otherwise touch `todo.txt`; only the user may modify it manually.

## Security and Compliance

- Never commit secrets, credentials, tokens, or private keys.
- Verify new dependencies, automation, and scripts before trusting them.
- Treat `npx` commands as network-backed dependency execution unless
  the package is already cached locally.
- Preserve the GNU GPL version 3 license unless the user requests a
  license change.

## Dependencies and Services

- `pretty` formatter commands depend on `npx` resolving and running
  Prettier.
- npm dev dependencies provide commitlint and Husky tooling.
- Documentation CI depends on the PyPI `zensical` package.
- No databases, queues, storage services, or runtime web services are
  verified.

## Troubleshooting

- If `pretty` is missing, run `source ./cbc-module.sh` in the shell.
- If a formatter command cannot find `npx`, install or activate
  Node.js/npm.
- If commitlint rejects a commit body, wrap body lines under 100
  characters.
- If generated `site/` files change unexpectedly, verify Zensical owns
  the output before editing or committing them.

## Refining Existing AGENTS.md

- Re-check every statement against the repository before keeping it.
- Remove stale, duplicated, or vague guidance.
- Normalize section order and formatting against the required template.
- Replace placeholders with exact commands, paths, and verified
  workflows.
- Add `Verification needed` notes where data is missing.
- Keep bullets short and optimized for AI agents to scan.

## Maintenance

- After any code, config, or doc change, verify that `AGENTS.md` still
  matches the repository.
- Re-run `git ls-files` and update the tracked files list when tracked
  files change.
- Re-check commands, versions, directory names, and workflows.
- When `AGENTS.md` needs an update, make it in a separate `docs`
  Conventional Commit such as `docs(agents): update repo instructions`.
- Keep `AGENTS.md` out of mixed code commits whenever possible.
- Remove stale instructions instead of appending historical notes.
- Do not record AGENTS.md updates inside AGENTS.md.
