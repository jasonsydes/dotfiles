# Guide: new Linux server

Fresh install in the ghee layout (bare repo + `hub` worktree, `~/.dotfiles`
a symlink to it). Validated on popsicle (Ubuntu 26.04), 260930.
Problems: `guide-troubleshooting.md`.

Run everything as the normal user, never from a root shell: a root shell
would leave every file owned by root. Connect from Ghostty at least once
first, so Ghostty's `ssh-terminfo` feature has installed `xterm-ghostty`
into `~/.terminfo`.

To survive a dropped connection during the downloads, start the system
tmux **before step 1** and leave it (`tmux kill-server`) before step 4.
Do not start it any later: once `~/.tmux.conf` is linked, it loads a
config whose pieces are not installed yet.

## 1. Clone: bare repo plus a `hub` worktree

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

## 2. Symlinks (layout (a))

Work through `scripts/symlink-configs.txt`, steps 0–4. On a fresh Ubuntu
account that means the umbrella link, moving Ubuntu's default `~/.bashrc`
aside, and seven `ln -s` calls.

## 3. pixi and the profile

```bash
cd "$DIR/hub"
bash setup/bootstrap.sh
export PATH="$HOME/.pixi/bin:$PATH"
pixi run -e server setup
```

## 4. Start using it

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

## 5. Record the host

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
