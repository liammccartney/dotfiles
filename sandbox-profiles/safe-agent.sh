#!/usr/bin/env bash
# safe-agent.sh — Launch an agent CLI inside the sandbox profile.
#
# Usage:
#   safe-agent.sh <agent-command> [args...]
#
# Examples:
#   safe-agent.sh claude
#   safe-agent.sh claude --resume
#   safe-agent.sh codex
#
# The script:
#   1. Resolves the physical working directory.
#   2. Copies the base profile to a temp file.
#   3. Appends workdir ancestor literals and a read/write grant for the cwd
#      (skipped if cwd is already under ~/Fulcrum, which is statically granted).
#   4. Launches sandbox-exec with the assembled policy.

set -euo pipefail

PROFILE_DIR="${BASH_SOURCE[0]%/*}"
BASE_PROFILE="${PROFILE_DIR}/agent-sandbox.sb"

if [[ ! -f "$BASE_PROFILE" ]]; then
  echo "error: base profile not found at ${BASE_PROFILE}" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "usage: safe-agent.sh <command> [args...]" >&2
  exit 1
fi

WORKDIR="$(pwd -P)"
HOME_DIR="${HOME}"

# Check if the workdir is already covered by a static grant in the profile.
workdir_needs_grant() {
  local dir="$1"
  # ~/Fulcrum is statically granted R/W in the base profile.
  [[ "$dir" != "${HOME_DIR}/Fulcrum"* ]]
}

# Emit ancestor literal read grants for a path, matching Safehouse's
# emit_path_ancestor_literals() behavior.
emit_ancestor_literals() {
  local path="$1"
  local label="$2"
  local current=""

  echo ""
  echo ";; Dynamic ancestor literals for ${label}: ${path}"
  echo "(allow file-read*"
  echo "    (literal \"/\")"

  IFS='/' read -ra parts <<< "${path#/}"
  for part in "${parts[@]}"; do
    [[ -z "$part" ]] && continue
    current="${current}/${part}"
    echo "    (literal \"${current}\")"
  done

  echo ")"
}

# Build the runtime policy.
POLICY_FILE="$(mktemp "${TMPDIR:-/tmp}/agent-sandbox-policy.XXXXXX")"
trap 'rm -f "$POLICY_FILE"' EXIT

cp "$BASE_PROFILE" "$POLICY_FILE"

if workdir_needs_grant "$WORKDIR"; then
  {
    echo ""
    echo ";; ===== Dynamic workdir grant (appended at launch) ========================="
    emit_ancestor_literals "$WORKDIR" "dynamic workdir"
    echo ""
    echo "(allow file-read* file-write*"
    echo "    (subpath \"${WORKDIR}\")"
    echo ")"
  } >> "$POLICY_FILE"
fi

exec sandbox-exec -f "$POLICY_FILE" "$@"
