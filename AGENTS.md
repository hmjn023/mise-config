# Repository Guidelines

## Project Structure & Module Organization

This repository manages an Arch/CachyOS user environment with mise. `mise.toml`
contains shared tools, dotfile mappings, and common tasks; `mise.personal.toml`
adds the desktop, pacman/AUR, repository, and user-shell setup; and
`mise.work.toml` is reserved for work-only tools. `dotfiles/` mirrors files
under `$HOME`, including Zsh, Hyprland Lua modules, Neovim, Waybar, and other
desktop configuration. The local mise package plugin lives in
`plugins/paru/` (`mise.plugin.toml`, `metadata.lua`, and Lua hooks). Bootstrap
repositories under `/vendor/` and host overrides such as `mise.local.toml` are
ignored and should not be committed.

## Build, Test, and Development Commands

There is no compile step. Use mise from the repository root:

```sh
mise trust
mise -E personal bootstrap --dry-run  # preview changes
mise run check                         # report package/dotfile/systemd drift
mise -E personal run check-hyprland    # validate Hyprland Lua
mise -E personal run setup             # apply the personal profile
mise -E work run setup                 # apply the work profile
```

Review dry-run output before applying changes. Use `--force-dotfiles` only
after backing up files that mise will replace.

## Coding Style & Naming Conventions

Keep TOML sections grouped by concern and preserve the existing profile split.
Use four-space indentation in Lua, lowercase descriptive filenames, and
kebab-case task names such as `check-hyprland`. Declare packages with explicit
manager prefixes, for example `"pacman:git"` or `"paru:google-chrome"`.
Keep shell commands defensive and comments brief and operational.

## Testing Guidelines

No automated test runner or coverage requirement is currently configured.
Treat `mise run check`, profile-specific dry runs, and
`Hyprland --verify-config` as required validation for the areas they touch.
For plugin changes, verify install, upgrade, and status behavior without
embedding credentials or host-specific assumptions.

## Commit & Pull Request Guidelines

Recent history follows Conventional Commit-style subjects such as
`feat: ...`, `fix(nvim): ...`, and `chore: ...`; keep subjects short and scoped.
Pull requests should explain the affected profile/host, list exact validation
commands and results, call out package or dotfile side effects, and link a
related issue when one exists. Include before/after screenshots only when a
desktop or UI change is relevant.

## Security & Configuration Tips

Never commit secrets, private keys, tokens, or machine-only values. Put local
overrides in ignored `mise.local.toml` files. Treat `setup-chaotic` and any
`--force-dotfiles` invocation as privileged or destructive operations: review
the command and backup existing configuration first.
