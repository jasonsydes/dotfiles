# Dotfiles Setup

Provisioning for a fresh system (Linux server, container, macOS laptop), and
updating one that already has the dotfiles. pixi supplies the tools, a short
by-hand checklist places the `$HOME` symlinks, and a few idempotent scripts
cover what pixi does not package.

Three procedures, each validated on a real host:

- **A. Fresh Linux server** (ghee layout) — popsicle, Ubuntu 26.04, 260930
- **B. Updating an existing plain clone** — longreads, Ubuntu 22.04, 260930
- **C. macOS laptop** — bubs

## Profiles

| Profile | Target | Tools |
|---------|--------|-------|
| `container-slim` | Linux container (e.g. ubuntu:24.04) | bash, nvim, tmux, starship, ripgrep, fd-find, git, git-delta |
| `server` | Linux host a human logs into (longreads, kelvin, popsicle) | container-slim + gh, ncurses, fzf, bat, jq, tree, ncdu |
| `laptop` | macOS workstation | container-slim + ast-grep, bat, choose, difftastic, dust, fzf, gh, glow, go, lazygit, neovim (pynvim), nodejs, procs, rust, tree, tree-sitter-cli, vim, wget, xlsx2csv |

`git-delta` and `gh` are in every profile that links `git/.gitconfig`,
because that file depends on them: delta is the pager (without it
`git diff`, `log` and `show` fail) and gh is the GitHub https credential
helper. `ncurses` in `server` provides a current `tic`/`infocmp` for
terminfo work.

Host-specific work tools (bioinformatics, Python environments, language
toolchains) belong to no profile. Install them per host with
`pixi global install`.

## What `pixi run -e <profile> setup` does

1. **`setup-tools`** — `pixi global install` of the profile's tools into
   `~/.pixi/bin`.
2. **`setup-configs`** — three idempotent scripts, in this order, each
   writing only under `$HOME`:
   - `install-bash-preexec.sh` → `~/.bash-preexec.sh` (bashrc sources it)
   - `link-terminfo-hex.sh` → hex-named aliases in `~/.terminfo`
     (see [Terminfo](#terminfo-pixi-tmux-and-ghostty))
   - `install-tmux-plugins.sh` → catppuccin at the XDG path, TPM, and the
     TPM plugins

It does **not** place the `$HOME` symlinks (see
[Why symlinking is manual](#why-symlinking-is-manual)), and the symlinks
must exist **before** it runs: TPM reads its plugin list from
`~/.tmux.conf`. It is sudo-free, container-safe, and safe to re-run;
`pixi run setup-configs` re-runs just the second half.

## A. Fresh Linux server (ghee layout)

Run everything as the normal user, never from a root shell: a root shell
would leave every file owned by root. Connect from Ghostty at least once
first, so Ghostty's `ssh-terminfo` feature has installed `xterm-ghostty`
into `~/.terminfo`.

To survive a dropped connection during the downloads, start the system
tmux **before step 1** and leave it (`tmux kill-server`) before step 4.
Do not start it any later: once `~/.tmux.conf` is linked, it loads a
config whose pieces are not installed yet.

### 1. Clone: bare repo plus a `hub` worktree

```bash
DIR=~/C/devops/dotfiles
BRANCH=dev        # the branch the other hosts run
git clone --bare https://github.com/jasonsydes/dotfiles "$DIR/.bare-repo"
git -C "$DIR/.bare-repo" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git -C "$DIR/.bare-repo" fetch origin
git -C "$DIR/.bare-repo" worktree add "$DIR/hub" "$BRANCH"
git -C "$DIR/hub" branch -u "origin/$BRANCH"
git -C "$DIR/hub" status -sb      # want: ## <branch>...origin/<branch>
```

`git clone --bare` already creates a local branch for every remote branch,
so the familiar `worktree add -b <branch> ... origin/<branch>` fails with
`a branch named '<branch>' already exists`. Check out the existing branch
and set its upstream instead, as above.

### 2. Symlinks (layout (a))

Work through `scripts/symlink-configs.txt`, steps 0–4. On a fresh Ubuntu
account that means the umbrella link, moving Ubuntu's default `~/.bashrc`
aside, and seven `ln -s` calls.

### 3. pixi and the profile

```bash
cd "$DIR/hub"
bash setup/bootstrap.sh
export PATH="$HOME/.pixi/bin:$PATH"
pixi run -e server setup
```

### 4. Start using it

```bash
exec bash -l
command -v tmux; tmux -V      # want: ~/.pixi/bin/tmux, tmux 3.6a
tmux
```

Check for the starship prompt, the absence of a grey
`shell: not installed: ...` line, and the catppuccin status bar. If the
bar or a plugin is missing, press prefix + I once inside tmux.

Leave the login shell as the system `/bin/bash`; see the host matrix in
`bash/README.Interactive-Soup.md` for why Linux hosts must not `chsh` to
pixi bash.

### 5. Record the host

Add a row to the host matrix in `bash/README.Interactive-Soup.md`:

```bash
lsb_release -ds
getent passwd "$USER" | cut -d: -f7
/bin/bash --version | head -n 1        # /bin/bash: after setup, plain `bash` is pixi's
```

and, from another machine, for the `SSH_SOURCE_BASHRC` column:

```bash
ssh <host> 'echo "DOTFILES=$DOTFILES"'      # a path = ON, empty = OFF
```

## B. Updating an existing plain clone (layout (b))

For a host where `~/.dotfiles` **is** the repo. Such hosts tend to carry
host-specific tweaks as uncommitted edits (on longreads, the GitHub
credential helper in `git/.gitconfig`), local commits, and stashes. The
aim is to switch branches without losing any of them.

```bash
cd ~/.dotfiles
git fetch origin

# 1. Take stock
git status                                    # uncommitted edits, untracked files
git log --oneline --stat @{upstream}..HEAD    # local commits not on the remote
git stash list
git diff origin/<branch> -- <edited file>     # no output: that edit is already upstream

# 2. Keep everything reachable
git branch <host>-backup-$(date +%y%m%d)

# 3. Set aside tweaks to keep; drop edits that are already upstream
git stash push -m '<host>: local tweaks' -- <files to keep>
git restore <files already upstream>

# 4. Switch and restore the tweaks
git switch -c <branch> --track origin/<branch>    # or, if it exists: git switch <branch> && git pull
git stash pop                                     # on conflict the stash is kept; resolve by hand

# 5. Pick up new tools and scripts (idempotent)
pixi run -e server setup
exec bash -l
```

Untracked files are carried across the switch untouched. Afterwards, look
at the local commits and old stashes (`git show <sha>`,
`git stash show -p stash@{N}`) and bring across only what the new branch
does not already cover; the backup branch keeps the rest until it is
deleted.

## C. macOS laptop

```bash
bash setup/bootstrap.sh
export PATH="$HOME/.pixi/bin:$PATH"
# symlinks: scripts/symlink-configs.txt, steps 0–4
pixi run -e laptop setup
pixi run setup-macos       # optional; see below
exec bash -l
```

On macOS the login shell is pixi bash, not `/bin/bash` (3.2, from 2007);
see the host matrix.

## Host notes

### sudo-rs (Ubuntu 26.04 and later)

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

### Terminfo: pixi tmux and Ghostty

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

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `fatal: a branch named '<b>' already exists` on `worktree add -b` | `git clone --bare` already made the branch | `worktree add "$DIR/hub" <b>`, then `branch -u origin/<b>` |
| tmux: `can't find terminfo database` | letter vs hex terminfo layout | `bash setup/scripts/link-terminfo-hex.sh` |
| `FATAL: Tmux Plugin Manager not configured in tmux.conf` during setup | TPM's tmux server could not start (terminfo), or `~/.tmux.conf` not linked yet | fix the cause, then `pixi run setup-configs`, or prefix + I inside tmux |
| `git diff` fails: cannot run delta | `git/.gitconfig` sets `pager = delta` | `pixi global install git-delta` (in every profile) |
| `sudo: preserving the entire environment is not supported` | sudo-rs | `sudo env HOME="$HOME" bash` |
| grey `shell: not installed: X` at startup | an optional tool is missing | install X, or ignore it |

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
| (a) | symlink to the repo elsewhere | bubs, popsicle |
| (b) | **is** the repo | longreads |

It is a handful of `ln -s` calls run once per machine. An installer that
guesses wrong is worse than no installer.

## macOS one-time system prefs (separate, opt-in)

The `setup` task above is intentionally **sudo-free and container-safe** — it
only does `pixi global install` and writes under `$HOME`. macOS system-level
tweaks that need `sudo` (and only make sense on a Mac) live in a separate,
opt-in task so they never break that property:

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
├── scripts/
│   ├── symlink-configs.txt           place $HOME symlinks — BY HAND, before setup
│   ├── install-bash-preexec.sh       setup-configs 1: ~/.bash-preexec.sh
│   ├── link-terminfo-hex.sh          setup-configs 2: ~/.terminfo hex aliases
│   ├── install-tmux-plugins.sh       setup-configs 3: catppuccin, TPM, plugins
│   └── macos-system-prefs.sh         macOS-only, opt-in: system prefs (sudo)
└── tests/
    └── test-setup-scripts.sh         temp-$HOME tests for the scripts above
```

The pixi manifest (`pixi.toml`) lives at the **repo root**, per pixi
convention. Profile definitions and the `setup-tools` tasks are there.
`pixi.lock` is deliberately not committed; `.gitignore` explains why.

Run the tests after changing a script:

```bash
bash setup/tests/test-setup-scripts.sh
```

## Adding a new profile

1. Add `[feature.profile-<name>.dependencies]` to `pixi.toml`.
2. Add `[feature.profile-<name>.tasks]` with a `setup-tools` task containing
   the matching `pixi global install` invocation.
   **KEEP THE LIST IN SYNC WITH THE DEPENDENCIES BLOCK.**
3. Add `<name> = ["profile-<name>"]` to `[environments]`.
4. Run `pixi lock` to confirm it solves on every platform.
5. Test on a representative target.

## Adding a tool to an existing profile

1. Add it to `[feature.profile-X.dependencies]`.
2. Add it to the `setup-tools` task command (KEEP IN SYNC).
3. Run `pixi lock` to confirm it solves.

## Not yet addressed

- **Homebrew casks** (e.g. macfuse) — install manually on macOS as needed.
- **Kanata** (keyboard remapping, macOS) — see `hub/kanata/README.setup`.
- **Nerd Fonts** — see `hub/nerd-fonts/README`.

## Migration from the old `setup.sh`

`hub/setup.sh` (Mac) and `hub/setup.d/260310-setup-bumble.sh` (Linux/bumble)
are the pre-pixi rough-notes install logs. They are preserved for reference
but superseded by this substrate. Don't run them.
