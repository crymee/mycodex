# mycodex

`mycodex` is a small wrapper for switching between multiple Codex logins on one machine.

It works by giving each login its own isolated `CODEX_HOME` under `~/.mycodex/accounts/<name>`, then wiring your shell so plain `codex` automatically uses the currently selected account.

## Install

Install with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/crymee/mycodex/main/install.sh | bash
```

What the bootstrap installer does:

- downloads the latest `mycodex` into `~/.local/share/mycodex/mycodex`
- creates `~/.local/bin/mycodex`
- adds shell integration to `~/.bashrc` or `~/.zshrc`
- tries to install `codex` automatically via `npm` or `brew` if `codex` is missing

After install:

```bash
source ~/.bashrc
```

If you use `zsh`:

```bash
source ~/.zshrc
```

## Core idea

`<name>` is not your real account name from OpenAI or ChatGPT.

It is just a local label you choose for a login, for example:

- `work`
- `personal`
- `client-a`

That means these are all valid:

```bash
mycodex login work
mycodex login personal
mycodex login client-a
```

## Quick start

1. Log in once under a local name:

```bash
mycodex login work
```

2. Select the account you want to use:

```bash
mycodex use work
```

3. Start Codex normally:

```bash
codex
```

4. Switch later without logging in again:

```bash
mycodex use personal
codex
```

## Daily workflow

Typical flow:

```bash
mycodex login <name>
mycodex use <name>
codex
```

Important behavior:

- `login <name>` logs into Codex and stores that login under `~/.mycodex/accounts/<name>`
- `use <name>` only changes the selected account; it does not launch `codex`
- after `use`, you run normal `codex`
- changing accounts only affects new `codex` processes, not sessions that are already open

## Commands

### Account management

```bash
mycodex login <name>
mycodex use <name>
mycodex current
mycodex default <name>
mycodex where <name>
```

- `login <name>` creates or reuses an isolated account directory and logs that account in
- `use <name>` marks the account as current
- `current` prints the currently selected account
- `default <name>` sets a fallback account used when no current account is selected
- `where <name>` prints the local path for that account

### Inspection

```bash
mycodex list
mycodex usage
mycodex usage <name>
mycodex usage --json <name>
```

- `list` shows saved accounts, email, and local path
- `usage` shows all saved accounts with plan hints and local 5h/week limit data
- `usage <name>` shows one account in detail
- `usage --json` is for scripting

`usage` is local-first. It does not call a live billing API. It infers data from saved auth, local session telemetry, and Codex logs.
Text output formats times in your local time zone for readability. `--json` keeps raw timestamps for scripts.

### Removing state

```bash
mycodex logout <name>
mycodex forget <name>
mycodex prune --dry-run
mycodex prune
mycodex uninstall
```

- `logout <name>` is safe for switching; it only clears current/default pointers and keeps saved auth
- `forget <name>` removes the saved auth for one account and auto-switches current/default first if that account is active and another saved account exists
- `prune` removes stub account folders that do not have saved auth
- `uninstall` is destructive and removes:
  - the local `mycodex` symlink
  - shell integration
  - all saved account data under `~/.mycodex/accounts`

## Account data

By default, `mycodex` stores local account data here:

```text
~/.mycodex/accounts/<name>/
```

That directory may contain:

- `auth.json`
- `config.toml`
- local session files
- local logs used by `usage`

This is local credential material. Treat it as sensitive.

## Update

To update to the latest version, run the install command again:

```bash
curl -fsSL https://raw.githubusercontent.com/crymee/mycodex/main/install.sh | bash
```

## Uninstall

To remove `mycodex` completely:

```bash
mycodex uninstall
```

This is destructive. It removes saved local account data under `~/.mycodex/accounts`.

If you only want to stop using one saved login, prefer:

```bash
mycodex forget <name>
```

## Troubleshooting

### `mycodex` not found after install

Reload your shell:

```bash
source ~/.bashrc
```

or:

```bash
source ~/.zshrc
```

### `codex` still uses the old account

`mycodex use <name>` only affects new `codex` processes. Close the old Codex session and start a new one after switching.

### `list` or `usage` does not show an account I expected

`list` and `usage` hide stub account directories without saved auth. Use:

```bash
mycodex prune --dry-run
```

to inspect removable stub entries.
