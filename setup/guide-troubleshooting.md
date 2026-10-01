# Guide: troubleshooting and host quirks

| Symptom | Cause | Fix |
|---|---|---|
| `fatal: a branch named '<b>' already exists` on `worktree add -b` | `git clone --bare` already made the branch | `worktree add "$DIR/hub" <b>`, then `branch -u origin/<b>` |
| tmux: `can't find terminfo database` | letter vs hex terminfo layout | `bash setup/scripts/link-terminfo-hex.sh` |
| `FATAL: Tmux Plugin Manager not configured in tmux.conf` during setup | TPM's tmux server could not start (terminfo), or `~/.tmux.conf` not linked yet | fix the cause, then `pixi run setup-configs`, or prefix + I inside tmux |
| `git diff` fails: cannot run delta | `git/.gitconfig` sets `pager = delta` | `pixi global install git-delta` (in every profile) |
| `sudo: preserving the entire environment is not supported` | sudo-rs | `sudo env HOME="$HOME" bash` |
| grey `shell: not installed: X` at startup | an optional tool is missing | install X, or ignore it |

## sudo-rs (Ubuntu 26.04 and later)

Ubuntu 26.04 ships sudo-rs as `sudo`. It ignores a bare `-E`
(`preserving the entire environment is not supported, '-E' is ignored`)
and sets `HOME` to the target user's, so `sudo -E bash` gives a root shell
without the dotfiles: bashrc finds everything through `$HOME`
(`~/.dotfiles`, `~/.pixi/bin`). The replacement:

```bash
sudo env HOME="$HOME" bash
```

Only `HOME` crosses; bashrc rebuilds `PATH` and the rest. It also works
with classic sudo, so one command serves every host. Two costs, both
shared with `-E`: root writes into the user's home, and a file root
creates there first (history backups, caches) stays root-owned; and
root's `PATH` starts with user-writable directories (`~/bin`,
`~/.pixi/bin`).

Ubuntu 26.04 also ships uutils (the Rust coreutils) in place of GNU
coreutils. GNU long options mostly work; help text and edge cases differ.

## Terminfo: pixi tmux and Ghostty

ncurses files each terminfo entry under a one-character directory, and
two builds disagree on which character:

| ncurses | `xterm-ghostty` lives at |
|---|---|
| Ubuntu/Debian | `~/.terminfo/x/xterm-ghostty` (first letter) |
| conda-forge (pixi) | `~/.terminfo/78/xterm-ghostty` (its hex code) |

Ghostty installs the entry with the host's own `tic`, so on Linux it lands
in the letter layout, and pixi's tmux fails with
`can't find terminfo database`. `TERM=xterm-256color tmux` and
`/usr/bin/tmux` both work, which is the tell.
`scripts/link-terminfo-hex.sh` (part of `setup`) adds `78 -> x` style
links so both layouts resolve to the same files; when Ghostty later
updates the entry, the links follow. longreads has the reverse,
file-level arrangement from May (real file in `78/`, symlinks in the
letter directories); it works too and the script leaves it alone.
