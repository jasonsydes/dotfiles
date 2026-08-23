# Interactive Soup — which shells read which startup files, and why

## Prelude

The soup is:
- interactive login
- interactive non-login
- non-interactive login
- non-interactive non-login
- ~/.bashrc
- ~/.bash_profile
- other shell init files (/etc/profile, /etc/bashrc, etc)

When the frick are all of these files read by all of these shells???

---

## Intro

This guide describes Bash startup semantics as they actually behave on the 
machines (and beyond) that I work with day-to-day. 

There's a Glossary, a three-zone model, and the testing supporting them.

We keep the explanation within the shell init files brief. 

In this guide, we have the long explanations and provenance.

---

## Glossary

### The Interactive Guard

`bash/bashrc`:

```bash
[[ $- != *i* ]] && return
```

The whole statement, not just the test. It splits `bashrc` in two, and it is
the single most important line in the startup path.

Referred to elsewhere as BEFORE (above) and AFTER (below) the Interactive
Guard. There are other `$-` tests in the tree — `bash_profile`'s Zone C guard,
the missing-tools report — but "the Interactive Guard" always means this one.

### non-interactive

The traditional meaning: a shell that reads **no** startup files at all. Not
`~/.bashrc`, not `~/.bash_profile`.

    bash script.sh
    bash -c 'cmd'
    sh -c 'cmd'
    cron jobs, systemd units, git hooks, Makefile recipes

These never reach any of my dotfiles. If a cron job can't find a command, this
is why: it got sshd's minimal PATH and nothing of mine.

### non-interactive-ssh+ext

Shells that are non-interactive by the definition above, but read `~/.bashrc`
**anyway**. This is the category that matters, and the reason the Interactive
Guard exists.

**ssh** — the main case. By the traditional rules, `ssh host cmd`, `scp`,
`sftp` and `rsync -e ssh` should never read a startup file. In practice bash
compiled with `SSH_SOURCE_BASHRC` detects it was launched by sshd and reads
`~/.bashrc` regardless. Measured 260823: ON in system `/bin/bash` on RHEL 8.10,
Ubuntu 22.04, Ubuntu 24.04 **and** macOS — and OFF in conda-forge/pixi bash.
It is a bash build option, not a distro policy.

**ext** — external tooling that invokes bash as a **login** shell (`bash -lc`,
`--login`, `shell: bash -l {0}`). That pulls in `~/.bash_profile`, which
sources `~/.bashrc`. The tool doesn't matter; the `-l` does. Sometimes I would
opt in — GitHub Actions [4], conda's setup-miniconda [5], Docker [6], systemd
units [7]. Sometimes the tool does it *for* me: VS Code launches a login shell
to capture the dev environment [1], GitLab Runner passes `--login` automatically
on several executors [2], and CircleCI defaults macOS jobs to `--login` [3].
That second group is the point — I never typed `-l`, but my rc files ran anyway.

**'ext' is the minor use case ('ssh' is the main use case), but it's important
to be aware of, so we're including it.**

Worth noting the defaults cut both ways: GitHub Actions' built-in `bash`
keyword expands to `bash --noprofile --norc -eo pipefail`, explicitly *not* a
login shell [8], so the most popular CI defaults to safe and the danger is
opting in. GitLab is the opposite.

A third path exists — an explicit `source ~/.bashrc` — but that one is on
purpose, so it doesn't need a name.

---

## The three-zone model

Two entry points (`~/.bash_profile`, `~/.bashrc`) and one guard yield exactly
three reachable zones. They nest.

| Zone | File | Where sourced | Runs for |
|---|---|---|---|
| **A** | `all/main-common` | `bashrc`, BEFORE the Interactive Guard | interactive login + interactive non-login + **non-interactive-ssh+ext** |
| **B** | `all/main-interactive` | `bashrc`, AFTER the Interactive Guard | interactive login + interactive non-login |
| **C** | `all/main-interactive-login` | `bash_profile` (interactive-guarded) | interactive login only |

Decide with three questions, stopping at the first yes:

1. Would a remote command or `scp` break without it? → **main-common**
2. Is it for a human typing at a prompt? → **main-interactive**
3. …but should nested shells (`sudo bash`, a subshell) skip it? → **main-interactive-login**

Zone A must print **nothing**. The scp/sftp protocol runs over stdout, so a
stray echo there corrupts transfers.

`main-interactive-non-login` is deliberately **not** a zone. `bash_profile`
sources `bashrc`, so nothing is non-login-only without an explicit
`shopt -q login_shell` test. There has never been a reason to want one.

### Measured: what reads what

| Invocation | `~/.bashrc` | `~/.bash_profile` |
|---|---|---|
| `bash -c 'cmd'` | no | no |
| `bash -lc 'cmd'` (non-interactive **login**) | yes | yes |
| `bash -ic 'cmd'` (interactive non-login) | yes | no |
| `bash -lic 'cmd'` (interactive login) | yes | yes |

Login-ness and interactive-ness are independent axes. `bash -lc` reads
`bash_profile` not because it's interactive — it isn't — but because it's a
login shell. That corner caused a real bug; see the log below.

---

## Host matrix (measured 260823)

| Host | OS | Login shell | bash | `SSH_SOURCE_BASHRC` |
|---|---|---|---|---|
| bubs | macOS | `~/.pixi/envs/bash/bin/bash` | 5.2.37 | **OFF** |
| login3 (talapas) | RHEL 8.10 | `/bin/bash` | **4.4.20** | ON |
| longreads | Ubuntu 22.04 | `/bin/bash` | 5.1.16 | ON |
| kelvin | Ubuntu 24.04 | `/bin/bash` | 5.2.21 | ON |

**Login shell policy — deliberate, do not "fix":**

- **macOS: pixi bash (modern 5.x+)** System `/bin/bash` is 3.2 (2007). Permanent.
- **Linux hosts: system bash.** Not laziness — system bash has
  `SSH_SOURCE_BASHRC=ON`, which is what makes Zone A run for `scp` and
  `ssh host cmd`. On talapas that is the only thing putting slurm on PATH.
  **Do not `chsh` to pixi bash on these hosts**; it would silently stop remote
  commands from reading `~/.bashrc` at all.

Pixi bash is still installed everywhere as a *tool* (`pixi.toml` pins
`bash >= 5.2`); that's unrelated to the login shell.

**talapas is bash 4.4**, so the whole startup path must stay 4.4-safe: no
`PROMPT_COMMAND` arrays, no `EPOCHSECONDS`/`EPOCHREALTIME`/`SRANDOM`, no
assignable `BASH_ARGV0`, no `varredir_close`. Fine to use: associative arrays,
`mapfile`, `globstar`, `local -n`, `${var^^}`, `${var@Q}`. Verified clean
260823 across all 22 files in the startup path.

### bubs: the ssh asymmetry (accepted trade)

pixi bash has `SSH_SOURCE_BASHRC=OFF`, and it is bubs' passwd shell.

| Into bubs | Reads dotfiles? |
|---|---|
| `ssh bubs` (interactive) | **yes** — login shells read `bash_profile` regardless of the flag |
| `ssh bubs 'cmd'` | no — so pixi tools aren't on PATH |
| `scp file bubs:` | no — but works anyway, `/usr/bin/scp` is in sshd's default PATH |

Accepted deliberately: a guaranteed-modern interactive shell is worth more than
one-off remote commands into a laptop. Interactive ssh is unaffected, which is
what a Tailscale workflow would mostly use. Fixable by setting Ghostty's
`command =` and reverting the passwd shell — at the cost of every other
terminal handing back bash 3.2. Not worth it.

### Checking a host

```bash
ssh HOST 'echo "$BASH_VERSION  $BASH  ->  $(readlink -f /proc/$$/exe)"'
ssh HOST 'echo "DOTFILES=${DOTFILES:-UNSET}"'          # set => reads ~/.bashrc for remote cmds
ssh HOST 'strings /bin/bash | grep -qx SSH2_CLIENT && echo ON || echo OFF'
```

Use `$BASH_VERSION` / `$BASH`, never `bash --version` or `command -v bash` —
those resolve through PATH to pixi bash, which is not the shell you're in.
Test `/bin/bash` explicitly for the compile flag, for the same reason.

---

## Decision log

Dated provenance lives here so the shell files themselves can stay clean. The
files carry the *rule*; this carries *how we found out*.

**(original, undated) — why `etc_profile_workaround` was written.** tmux starts
login shells, login shells read `/etc/profile`, and `/etc/profile` was moving
the miniconda path from the front of PATH to the rear. Result: the wrong `vim`
got picked up under tmux, and the conda `vim` became unusable. Since
`/etc/profile` can't be edited on most of these machines, the fix was to reset
PATH and source `/etc/profile` by hand, early.
Ref: https://superuser.com/a/970847

**Jul 2024 — the same hack turned out to fix VSCode too.** macOS VSCode starts
login shells for its integrated terminal, which under some conditions pushed the
conda/mamba paths to the end of `$PATH`. The file was written for tmux, but it
covers this case for free.

**260509 — the labels were wrong.** `bashrc` line 1 read "bashrc is for
non-interactive shells". Flatly wrong, and it had propagated into the include
filenames. Fixed into the three-zone model above.

**260822 — `bash -lc` was leaking Zone C.** `~/.bash_profile` is read by ALL
login shells, interactive or not, and had no guard. Confirmed in production on
longreads: `bash -lc 'echo "$PATH"'` returned the `df -h /JBOD /storage` login
greeting mixed into its output. Fixed with `[[ $- == *i* ]]` in `bash_profile`.

**260822 — Ghostty doesn't use `precmd_functions`.** As of 1.3.1 it appends
`__ghostty_hook` to `PROMPT_COMMAND` and adds to `PS0`; `precmd_functions` is
only an else-branch fallback. Grep for `__ghostty_hook`, not `__ghostty_precmd`.
An old note claiming otherwise produced two false "MISSING" results.

**260822 — history sync was running twice per prompt.** The old combined
`history_and_prompt_command` was sourced twice by `bashrc` and registered
`PROMPT_COMMAND` both times, and forked the backup script twice per shell. Split
into `history_vars` (re-sourceable) and `history_sync` (once). Also: starship
stashes any pre-existing `PROMPT_COMMAND` into `$STARSHIP_PROMPT_COMMAND` and
evals it from `starship_precmd`, which is why the sync isn't visible in
`PROMPT_COMMAND` itself.

**260823 — `path_helper` named at last.** macOS `/etc/profile` runs
`eval $(/usr/libexec/path_helper -s)`, which rebuilds PATH from `/etc/paths` +
`/etc/paths.d` and appends whatever you had. Measured: an entry at position 1
came back at position 13. That is the whole reason `etc_profile_workaround`
exists. Conda was the original symptom; pixi now stands where conda stood.

**260823 — the interactivity gate: tried and reverted the same day.** Gating
`etc_profile_workaround` on `[[ $- == *i* ]]` looked like a free win. It is not:

- **talapas loses slurm.** `/etc/profile.d/slurm.sh` is the only thing putting
  `${SLURM_ROOT}/bin` on PATH and setting `LD_LIBRARY_PATH` for a remote
  command. sshd does not supply it. `ssh talapas squeue` would break.
- **PATH gains duplicates.** The rebuild starts from a known base, which
  dedupes. Measured on bubs: `~/.pixi/bin` went from 1 entry to 2 within the
  hour the gate was live.

So the workaround does three jobs, not one, and only the first is macOS-only:
undo `path_helper`; dedupe PATH everywhere; load `/etc/profile.d/*` on Linux
for shells that would otherwise never see it.

**260823 — `HISTCONTROL` is asserted empty on purpose.** Record everything: no
`ignorespace`, no `ignoredups`, no `ignoreboth`, no `erasedups`. It has to be an
active `unset`, because talapas's `/etc/profile` *exports* `ignoredups` and our
own workaround re-runs `/etc/profile`. Note the consequence: prefixing a command
with a space no longer keeps it out of history.

---

## References

[1] VS Code terminal profiles — launches your shell as a login shell to source your dev environment
    https://code.visualstudio.com/docs/terminal/profiles

[2] GitLab Runner shells — `shell`/`parallels`/`virtualbox`/`ssh` executors pass `--login` automatically
    https://docs.gitlab.com/runner/shells/

[3] CircleCI configuration reference — macOS jobs default to `/bin/bash --login -eo pipefail`
    https://circleci.com/docs/configuration-reference/

[4] GitHub Actions — setting a default shell (`shell: bash -l {0}`)
    https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/setting-a-default-shell-and-working-directory

[5] conda-incubator/setup-miniconda — requires `shell: bash -l {0}` on every conda step
    https://github.com/conda-incubator/setup-miniconda

[6] Activating conda in a Dockerfile — `SHELL ["/bin/bash", "--login", "-c"]`
    https://pythonspeed.com/articles/activate-conda-dockerfile/

[7] systemd + RVM — `ExecStart=/bin/bash -lc '...'`
    https://github.com/puma/puma/issues/1735

[8] GitHub Actions runner ADR 0277 — the built-in `bash` keyword is `bash --noprofile --norc -eo pipefail`
    https://github.com/actions/runner/blob/main/docs/adrs/0277-run-action-shell-options.md

[9] purcell/exec-path-from-shell — starts an interactive *and login* shell to capture PATH
    https://github.com/purcell/exec-path-from-shell/blob/master/README.md
