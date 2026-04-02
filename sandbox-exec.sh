#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# run-sandboxed.sh
# Wrapper that resolves the working directory, patches the sandbox profile
# with ancestor literals + workdir path, and execs under sandbox-exec.
# ---------------------------------------------------------------------------

PROFILE="${HOME}/.config/sandbox-exec/agent.sb"
WORKDIR_TOKEN="__SAFEHOUSE_WORKDIR__"
ANCESTORS_MARKER=";; __WORKDIR_ANCESTORS_INJECT__"
BLOCK_START=";; __WORKDIR_BLOCK_START__"

# --- Parse optional --workdir flag ---
EXPLICIT_WORKDIR=""
if [[ "${1:-}" == --workdir=* ]]; then
    EXPLICIT_WORKDIR="${1#--workdir=}"
    shift
fi

if [[ $# -eq 0 ]]; then
    echo "Usage: run-sandboxed.sh [--workdir=/path] <command> [args...]" >&2
    exit 1
fi

# --- Resolve effective workdir ---
if [[ -n "$EXPLICIT_WORKDIR" ]]; then
    WORKDIR="$(cd "$EXPLICIT_WORKDIR" && pwd -P)"
elif git rev-parse --show-toplevel >/dev/null 2>&1; then
    WORKDIR="$(git rev-parse --show-toplevel)"
else
    WORKDIR="$(pwd -P)"
fi

# --- Build ancestor (literal ...) rules ---
# Walk dirname from WORKDIR up to / so agents can readdir() parent dirs.
ancestor_rules=""
current="$WORKDIR"
while true; do
    parent="$(dirname "$current")"
    if [[ "$parent" == "$current" ]]; then
        break
    fi
    ancestor_rules="${ancestor_rules}(allow file-read* (literal \"${parent}\"))
"
    current="$parent"
done

# --- Assemble patched profile in a temp file ---
tmpfile="$(mktemp /tmp/sandbox-profile.XXXXXX)"
trap 'rm -f "$tmpfile"' EXIT

# 1. Copy base profile
cp "$PROFILE" "$tmpfile"

# 2. Replace workdir token with resolved path
sed -i '' "s|${WORKDIR_TOKEN}|${WORKDIR}|g" "$tmpfile"

# 3. Inject ancestor rules before the ancestors marker
if [[ -n "$ancestor_rules" ]]; then
    # Write ancestor rules to a temp file to avoid sed multi-line issues
    ancestors_tmp="$(mktemp /tmp/sandbox-ancestors.XXXXXX)"
    printf '%s' "$ancestor_rules" > "$ancestors_tmp"

    # Use sed to read and inject the ancestors file at the marker line
    sed -i '' "/${ANCESTORS_MARKER}/r ${ancestors_tmp}" "$tmpfile"
    rm -f "$ancestors_tmp"
fi

# --- Exec under sandbox ---
exec sandbox-exec -p "$(cat "$tmpfile")" "$@"