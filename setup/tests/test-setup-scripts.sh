#!/usr/bin/env bash
# test-setup-scripts.sh — exercise the setup scripts against a throwaway $HOME.
#
#   bash setup/tests/test-setup-scripts.sh
#
# Never touches the real $HOME and never reaches the network: each case gets
# a fresh temp HOME, and `curl` is a fake placed first on PATH.
# install-tmux-plugins.sh is not covered (it clones from GitHub and starts a
# tmux server); it is checked by hand on a real host.

set -euo pipefail

SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"
PASS=0
FAIL=0

check() {
    local name="$1"
    shift
    if "$@"; then
        PASS=$((PASS + 1))
        echo "ok   $name"
    else
        FAIL=$((FAIL + 1))
        echo "FAIL $name"
    fi
}

new_home() {
    local h
    h="$(mktemp -d)"
    mkdir -p "$h/fakebin"
    echo "$h"
}

# ── link-terminfo-hex.sh ────────────────────────────────────────────────────

# Ubuntu layout (popsicle): letter dirs only -> hex links are added.
h="$(new_home)"
mkdir -p "$h/.terminfo/x" "$h/.terminfo/g"
touch "$h/.terminfo/x/xterm-ghostty" "$h/.terminfo/g/ghostty"
HOME="$h" bash "$SCRIPTS/link-terminfo-hex.sh" >/dev/null
check "letter layout: 78 -> x" test "$(readlink "$h/.terminfo/78")" = x
check "letter layout: 67 -> g" test "$(readlink "$h/.terminfo/67")" = g
check "letter layout: entry reachable via hex" test -f "$h/.terminfo/78/xterm-ghostty"

# Re-run is a no-op and does not error.
out="$(HOME="$h" bash "$SCRIPTS/link-terminfo-hex.sh")"
check "re-run prints nothing" test -z "$out"
rm -rf "$h"

# longreads layout: hex dir is real, letter dirs are links -> untouched.
h="$(new_home)"
mkdir -p "$h/.terminfo/78" "$h/.terminfo/x"
touch "$h/.terminfo/78/xterm-ghostty"
ln -s ../78/xterm-ghostty "$h/.terminfo/x/xterm-ghostty"
HOME="$h" bash "$SCRIPTS/link-terminfo-hex.sh" >/dev/null
check "hex layout: 78 stays a real directory" test -d "$h/.terminfo/78" -a ! -L "$h/.terminfo/78"
rm -rf "$h"

# No ~/.terminfo at all -> exits 0, creates nothing.
h="$(new_home)"
HOME="$h" bash "$SCRIPTS/link-terminfo-hex.sh" >/dev/null
check "no ~/.terminfo: nothing created" test ! -e "$h/.terminfo"
rm -rf "$h"

# ── install-bash-preexec.sh ─────────────────────────────────────────────────

# Download path: fake curl writes the --output file.
h="$(new_home)"
cat > "$h/fakebin/curl" <<'EOF'
#!/usr/bin/env bash
while [ $# -gt 0 ]; do
    if [ "$1" = "--output" ]; then echo "# fake bash-preexec" > "$2"; exit 0; fi
    shift
done
exit 1
EOF
chmod +x "$h/fakebin/curl"
HOME="$h" PATH="$h/fakebin:$PATH" bash "$SCRIPTS/install-bash-preexec.sh" >/dev/null
check "preexec: file installed" grep -q 'fake bash-preexec' "$h/.bash-preexec.sh"
check "preexec: no temp file left" test ! -e "$h/.bash-preexec.sh.tmp"

# Already present -> curl is never called (a failing curl proves it).
printf '#!/usr/bin/env bash\nexit 99\n' > "$h/fakebin/curl"
HOME="$h" PATH="$h/fakebin:$PATH" bash "$SCRIPTS/install-bash-preexec.sh" >/dev/null
check "preexec: existing file skips download" grep -q 'fake bash-preexec' "$h/.bash-preexec.sh"
rm -rf "$h"

# Failed download -> script fails and leaves no ~/.bash-preexec.sh to source.
h="$(new_home)"
printf '#!/usr/bin/env bash\nexit 22\n' > "$h/fakebin/curl"
chmod +x "$h/fakebin/curl"
if HOME="$h" PATH="$h/fakebin:$PATH" bash "$SCRIPTS/install-bash-preexec.sh" >/dev/null 2>&1; then
    rc=0
else
    rc=$?
fi
check "preexec: failed download exits non-zero" test "$rc" -ne 0
check "preexec: failed download leaves no file" test ! -e "$h/.bash-preexec.sh"
rm -rf "$h"

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
