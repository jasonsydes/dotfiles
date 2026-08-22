# Dotfiles Setup Substrate

Self-contained, multi-target setup substrate for my dotfiles. Goal is
to hopefully up a fresh system (container, laptop, server) with a few 
commands (bootstrap to get pixi up, then some pixi tasks).

## Quick start (fresh system)

From a freshly cloned dotfiles repo:

```bash
# 1. Install pixi (idempotent — skips if pixi is already present)
bash setup/bootstrap.sh

# 2. Add pixi to PATH for this shell
#    (the dotfiles bashrc handles PATH after setup completes)
export PATH="$HOME/.pixi/bin:$PATH"

# 3. Install the profile's tools, then bootstrap tmux plugins
pixi run -e <profile> setup

# 4. Place the $HOME symlinks BY HAND — see scripts/symlink-configs.txt
#    (deliberately not automated; see "Why symlinking is manual" below)

# 5. Reload shell to pick up the new dotfiles
exec bash
```

Profiles: `container-slim` (minimal Linux container) or `laptop` (full macOS).

## Why symlinking is manual

`scripts/symlink-configs.txt` is a checklist, not a script, and that is on
purpose. The former `symlink-configs.sh` began by ensuring
`~/.dotfiles -> <repo>`. On a host where `~/.dotfiles` **is** the repo — a real
directory, not a symlink — it took its "back up whatever is in the way" branch,
renamed the entire repo to `~/.dotfiles.pre-dotfiles.<date>`, and then pointed
the new symlink at a path that no longer existed. That broke longreads on
260518 (see `NOTES.txt`).

Two layouts are both legitimate and the script could not distinguish them:

| Layout | `~/.dotfiles` | Example |
|--------|---------------|---------|
| (a) | symlink to the repo elsewhere | bubs |
| (b) | **is** the repo | longreads |

It is a handful of `ln -s` calls run once per machine. An installer that
guesses wrong is worse than no installer.

## macOS one-time system prefs (separate, opt-in)

The `setup` task above is intentionally **sudo-free and container-safe** — it
only does `pixi global install` + `$HOME` symlinks. macOS system-level tweaks
that need `sudo` (and only make sense on a Mac) live in a separate, opt-in task
so they never break that property:

```bash
pixi run setup-macos       # macOS only; prompts for sudo once
```

Currently this pins the hostname so it stops drifting with the network. macOS
derives a transient hostname from DHCP when `HostName` is unset, which makes the
Starship prompt show e.g. `bubs-2` at home and `dyn-10-108-5-245` on foreign
wifi. The script pins `HostName`/`LocalHostName` permanently — across reboots
and OS updates.

**Currently hardcoded to `bubs`.** An earlier version derived the name from
`scutil --get ComputerName` so it would work unedited on any Mac; that didn't
work in practice, so it was replaced with the blunt version. Revisit when
there's a second Mac to run it on. Re-add macOS `defaults write` tweaks
(key-repeat, Finder, etc.) here as needed.

## Layout

```
setup/
├── README.md                         (this file)
├── NOTES.txt                         running list of setup rough edges
├── bootstrap.sh                      step 0: install pixi itself
└── scripts/
    ├── symlink-configs.txt           step 2a: place $HOME symlinks — BY HAND
    ├── install-tmux-plugins.sh       step 2b: clone TPM, install tmux plugins
    └── macos-system-prefs.sh         macOS-only, opt-in: system prefs (sudo)
```

The pixi manifest (`pixi.toml`, `pixi.lock`) lives at the **repo root**, per
pixi convention. Profile definitions and the `setup-tools` task are there.

## Profiles

| Profile | Target | Tools |
|---------|--------|-------|
| `container-slim` | Linux container (e.g. ubuntu:24.04) | bash, nvim, tmux, starship, ripgrep, fd-find, git |
| `laptop` | macOS workstation | the above + ast-grep, bat, choose, difftastic, dust, fzf, gh, git-delta, glow, go, lazygit, neovim (pynvim), nodejs, procs, rust, tree, vim, wget, xlsx2csv |

### Not yet addressed (potentially tricky installs?):

Haven't attempted these installs yet, potentially tricky, not sure if 
automatable (but honestly haven't looked yet):

- **Homebrew casks** (e.g. macfuse) — install manually on macOS as needed.
- **Kanata** (keyboard remapping, macOS) — see `hub/kanata/README.setup`.
- **Nerd Fonts** — see `hub/nerd-fonts/README`.

## Adding a new profile

1. Add `[feature.profile-<name>.dependencies]` to `pixi.toml`.
2. Add `[feature.profile-<name>.tasks]` with a `setup-tools` task containing
   the matching `pixi global install` invocation.
   **KEEP THE LIST IN SYNC WITH THE DEPENDENCIES BLOCK.**
3. Add `<name> = ["profile-<name>"]` to `[environments]`.
4. Run `pixi lock` to update the lockfile.
5. Test on a representative target.

## Adding a tool to an existing profile

1. Add it to `[feature.profile-X.dependencies]`.
2. Add it to the `setup-tools` task command (KEEP IN SYNC).
3. Run `pixi lock`.

## Migration from the old `setup.sh`

`hub/setup.sh` (Mac) and `hub/setup.d/260310-setup-bumble.sh` (Linux/bumble)
are the pre-pixi rough-notes install logs. They are preserved for reference
but superseded by this substrate. Don't run them.
