# Guide: updating an existing plain clone

Validated on longreads (Ubuntu 22.04), 260930.

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
