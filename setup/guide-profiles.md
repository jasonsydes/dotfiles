# Guide: profiles and what `setup` does

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
     (see `guide-troubleshooting.md`, "Terminfo")
   - `install-tmux-plugins.sh` → catppuccin at the XDG path, TPM, and the
     TPM plugins

It does **not** place the `$HOME` symlinks (see
`scripts/symlink-configs.txt` for why), and the symlinks
must exist **before** it runs: TPM reads its plugin list from
`~/.tmux.conf`. It is sudo-free, container-safe, and safe to re-run;
`pixi run setup-configs` re-runs just the second half.

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
