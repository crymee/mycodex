# mycodex

Fast multi-account switching for Codex CLI using isolated `CODEX_HOME` directories.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/crymee/mycodex/main/install.sh | bash
```

The bootstrap installer will:

- download `mycodex` into `~/.local/share/mycodex/mycodex`
- symlink `~/.local/bin/mycodex`
- wire shell integration into `~/.bashrc` or `~/.zshrc`
- try to install `codex` via `npm` or `brew` if it is missing

## Daily usage

```bash
mycodex login <name>
mycodex use <name>
codex
```

`<name>` is any local label you choose for that login, for example `work`, `personal`, or `client-a`.

Useful commands:

```bash
mycodex list
mycodex usage
mycodex usage <name> --json
mycodex default <name>
mycodex logout <name>
mycodex forget <name>
mycodex where <name>
mycodex prune --dry-run
```

## Notes

- `use` only selects the current account. It does not launch `codex`.
- `logout` only clears current/default pointers and keeps saved auth.
- `forget` removes saved auth for an account.
- `list` and `usage` hide stub accounts without saved auth.

## Update

Re-run the install command:

```bash
curl -fsSL https://raw.githubusercontent.com/crymee/mycodex/main/install.sh | bash
```
