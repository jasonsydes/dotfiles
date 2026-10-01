# Guide: macOS laptop

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

## One-time system prefs (separate, opt-in)

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

## Not yet automated

- **Homebrew casks** (e.g. macfuse) — install manually as needed.
- **Kanata** (keyboard remapping) — see `kanata/README.setup`.
- **Nerd Fonts** — see `nerd-fonts/README`.
