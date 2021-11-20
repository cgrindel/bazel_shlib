#!/usr/bin/env bash

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

messages_lib="$(rlocation cgrindel_bazel_shlib/lib/messages.sh)"
source "${messages_lib}"

# DEBUG BEGIN
echo >&2 "*** CHUCK execute_binary.sh START" 
echo >&2 "*** CHUCK  @: ${@:-}" 
# DEBUG END

args=()
while (("$#")); do
  case "${1}" in
    "--binary")
      binary="${2}"
      shift 2
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

[[ -z "${binary:-}" ]] && exit_with_msg "A binary was not specified."

if [[ ${#args[@]} > 0 ]]; then
  "${binary}" "${args[@]}"
else
  "${binary}"
fi
