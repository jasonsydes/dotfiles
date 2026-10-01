#!/usr/bin/env bash
# test-img.sh — check the flags img() hands to chafa, in and out of tmux.
#
#   bash chafa/tests/test-img.sh
#
# chafa is a fake placed first on PATH that records its arguments, so no
# terminal or image is needed. Rendering itself is checked by eye on a real
# host (see the header of chafa/aliases).

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/fakebin"
cat > "$tmp/fakebin/chafa" <<'FAKE'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$ARGS_OUT"
FAKE
chmod +x "$tmp/fakebin/chafa"

# shellcheck disable=SC1091  # sourced by path; checked on its own
source "$HERE/../aliases"

export ARGS_OUT="$tmp/args"

# Outside tmux: kitty format, no passthrough.
(
    unset TMUX
    PATH="$tmp/fakebin:$PATH" img plot.png
)
check "outside tmux: --format kitty only" \
    test "$(cat "$ARGS_OUT")" = "--format kitty plot.png"

# Inside tmux: kitty format plus tmux passthrough.
(
    export TMUX="/tmp/tmux-1000/default,1234,0"
    PATH="$tmp/fakebin:$PATH" img plot.png
)
check "inside tmux: adds --passthrough tmux" \
    test "$(cat "$ARGS_OUT")" = "--format kitty --passthrough tmux plot.png"

# Extra flags and several files pass through after the defaults.
(
    unset TMUX
    PATH="$tmp/fakebin:$PATH" img --size 80x a.png b.png
)
check "extra flags and files pass through" \
    test "$(cat "$ARGS_OUT")" = "--format kitty --size 80x a.png b.png"

# No chafa on PATH: non-zero exit and a message on stderr.
rc=0
# shellcheck disable=SC2123  # an empty PATH is the point: no chafa anywhere
err="$(PATH="$tmp/empty" img plot.png 2>&1)" || rc=$?
check "missing chafa: exits non-zero" test "$rc" -ne 0
check "missing chafa: says so" grep -q "chafa not installed" <<<"$err"

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
