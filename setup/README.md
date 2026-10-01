# setup/

Gets the dotfiles onto a machine. pixi installs the tools, a few `$HOME`
symlinks are placed by hand, and some small idempotent scripts fill in the
rest (bash-preexec, terminfo links, tmux plugins).

## Quick start

```bash
bash setup/bootstrap.sh                  # install pixi
export PATH="$HOME/.pixi/bin:$PATH"
# $HOME symlinks, by hand: scripts/symlink-configs.txt
pixi run -e <profile> setup              # container-slim | server | laptop
exec bash -l
```

Symlinks go first: `setup` installs the tmux plugins, and TPM reads its
plugin list from `~/.tmux.conf`.

## Where to look

- `guide-new-linux-server.md` — fresh Linux host, ghee layout
- `guide-update-existing-clone.md` — switch branches on a host where
  `~/.dotfiles` is the repo, keeping its local tweaks
- `guide-macos.md` — the laptop, plus one-time system prefs
- `guide-profiles.md` — what each profile installs, what `setup` does,
  adding tools
- `guide-troubleshooting.md` — known errors, sudo-rs, terminfo
- `scripts/symlink-configs.txt` — the by-hand symlink checklist, and why
  it is not a script
- `NOTES.txt` — running list of rough edges

Tests for the scripts: `bash setup/tests/test-setup-scripts.sh`.

`setup.sh` and `setup.d/` at the repo root are pre-pixi install notes,
kept for reference. Don't run them.
