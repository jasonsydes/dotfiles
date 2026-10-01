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

# ── link-terminfo-layouts.sh ────────────────────────────────────────────────

LT="$SCRIPTS/link-terminfo-layouts.sh"

# Fake pixi ncurses in $1/.pixi/bin. infocmp prints an entry only when
# $1/pixi-has-entry exists; tic writes the hex layout under its -o dir.
fake_pixi_ncurses() {
    local h="$1"
    mkdir -p "$h/.pixi/bin"
    cat > "$h/.pixi/bin/infocmp" <<EOF
#!/usr/bin/env bash
[ -e "$h/pixi-has-entry" ] || exit 1
echo "xterm-ghostty|ghostty|Ghostty,"
EOF
    cat > "$h/.pixi/bin/tic" <<'EOF'
#!/usr/bin/env bash
out=""
while [ $# -gt 0 ]; do
    if [ "$1" = "-o" ]; then out="$2"; shift; fi
    shift
done
[ -n "$out" ] || exit 2
mkdir -p "$out/78" "$out/67"
echo compiled > "$out/78/xterm-ghostty"
ln -sf ../78/xterm-ghostty "$out/67/ghostty"
EOF
    chmod +x "$h/.pixi/bin/infocmp" "$h/.pixi/bin/tic"
}

# Step 1 is skipped on macOS; the tests run as if on Linux.
fake_linux() {
    printf '#!/usr/bin/env bash\necho Linux\n' > "$1/fakebin/uname"
    chmod +x "$1/fakebin/uname"
}

run_lt() {
    HOME="$1" PATH="$1/fakebin:$PATH" bash "$LT"
}

# Ubuntu layout (popsicle): letter dirs only -> hex links are added.
h="$(new_home)"; fake_linux "$h"
mkdir -p "$h/.terminfo/x" "$h/.terminfo/g"
touch "$h/.terminfo/x/xterm-ghostty" "$h/.terminfo/g/ghostty"
run_lt "$h" >/dev/null
check "letter layout: 78 -> x" test "$(readlink "$h/.terminfo/78")" = x
check "letter layout: 67 -> g" test "$(readlink "$h/.terminfo/67")" = g
check "letter layout: entry reachable via hex" test -f "$h/.terminfo/78/xterm-ghostty"

# Re-run is a no-op and does not error.
out="$(run_lt "$h")"
check "re-run prints nothing" test -z "$out"
rm -rf "$h"

# Hex layout only (kelvin, 260630): letter links are added.
h="$(new_home)"; fake_linux "$h"
mkdir -p "$h/.terminfo/78" "$h/.terminfo/67"
touch "$h/.terminfo/78/xterm-ghostty"
ln -s ../78/xterm-ghostty "$h/.terminfo/67/ghostty"
run_lt "$h" >/dev/null
check "hex layout: x -> 78" test "$(readlink "$h/.terminfo/x")" = 78
check "hex layout: g -> 67" test "$(readlink "$h/.terminfo/g")" = 67
check "hex layout: entry reachable via letter" test -f "$h/.terminfo/x/xterm-ghostty"
out="$(run_lt "$h")"
check "hex layout: re-run prints nothing" test -z "$out"
rm -rf "$h"

# longreads layout: hex dir is real, letter dirs hold file links -> untouched.
h="$(new_home)"; fake_linux "$h"
mkdir -p "$h/.terminfo/78" "$h/.terminfo/x"
touch "$h/.terminfo/78/xterm-ghostty"
ln -s ../78/xterm-ghostty "$h/.terminfo/x/xterm-ghostty"
run_lt "$h" >/dev/null
check "longreads layout: 78 stays a real directory" test -d "$h/.terminfo/78" -a ! -L "$h/.terminfo/78"
check "longreads layout: x stays a real directory" test -d "$h/.terminfo/x" -a ! -L "$h/.terminfo/x"
rm -rf "$h"

# Entry only inside pixi's ncurses (kelvin, 261001): compiled into
# ~/.terminfo, then linked to the letter layout.
h="$(new_home)"; fake_linux "$h"; fake_pixi_ncurses "$h"
touch "$h/pixi-has-entry"
run_lt "$h" >/dev/null
check "pixi-only: compiled into hex layout" grep -q compiled "$h/.terminfo/78/xterm-ghostty"
check "pixi-only: reachable via letter" test -f "$h/.terminfo/x/xterm-ghostty"
check "pixi-only: alias reachable via letter" test -e "$h/.terminfo/g/ghostty"
rm -rf "$h"

# Entry already in ~/.terminfo -> pixi's tic is not run (a failing tic proves it).
h="$(new_home)"; fake_linux "$h"; fake_pixi_ncurses "$h"
touch "$h/pixi-has-entry"
printf '#!/usr/bin/env bash\nexit 99\n' > "$h/.pixi/bin/tic"
mkdir -p "$h/.terminfo/x"
touch "$h/.terminfo/x/xterm-ghostty"
if run_lt "$h" >/dev/null 2>&1; then rc=0; else rc=$?; fi
check "entry present: no recompile" test "$rc" -eq 0
rm -rf "$h"

# macOS: step 1 is skipped even when pixi's ncurses has an entry.
h="$(new_home)"; fake_pixi_ncurses "$h"
touch "$h/pixi-has-entry"
printf '#!/usr/bin/env bash\necho Darwin\n' > "$h/fakebin/uname"
chmod +x "$h/fakebin/uname"
run_lt "$h" >/dev/null
check "macOS: nothing compiled" test ! -e "$h/.terminfo"
rm -rf "$h"

# Nothing anywhere -> exits 0, creates nothing.
h="$(new_home)"; fake_linux "$h"; fake_pixi_ncurses "$h"
run_lt "$h" >/dev/null
check "no entry anywhere: nothing created" test ! -e "$h/.terminfo"
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
