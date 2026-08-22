#!/usr/bin/env bash
# macos-system-prefs.sh - apply macOS system-level preferences.
# 
# Not part of the normal setup, only for new laptop setup.
# Can run with `pixi run setup-macos` or directly.
# 
### Hostname pinning (e.g., want 'sydes@bubs' prevent 'sydes@dyn-10-108-5-245'
# macOS keeps three hostname-ish values:
#   ComputerName   friendly name (System Settings > Sharing); does NOT drift
#   LocalHostName  Bonjour/.local name; macOS may auto-suffix it ("bubs-2")
#   HostName       the actual system hostname read by gethostname()
# When HostName is UNSET, macOS derives a transient name from DHCP every time
# the network changes - so the Starship prompt (which reads gethostname())
# shows e.g. `bubs-2` at home and `dyn-10-108-5-245` on foreign wifi.

set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
    echo "Not macOS (uname=$(uname)); nothing to do."
    exit 0
fi

echo "Applying macOS system preferences"
echo

### Hostname pinning
# Hardcoded on purpose. An earlier version derived this from
# `scutil --get ComputerName` so the script would be identical on every Mac;
# that didn't work in practice. Edit this line when setting up a new machine.
NAME="bubs"

echo "  Pinning hostname to: '$NAME'"
sudo scutil --set HostName "$NAME"
# Pin LocalHostName too, to clear any auto-applied "-N" suffix. Note: if a real
# device named "$NAME" coexists on a LAN, macOS may re-suffix this later;
# HostName (what Starship reads) is unaffected.
sudo scutil --set LocalHostName "$NAME"

echo
echo "macOS system preferences applied. Open a new shell to see the change."
