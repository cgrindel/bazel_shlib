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

assertions_lib="$(rlocation cgrindel_bazel_shlib/lib/assertions.sh)"
source "${assertions_lib}"

# DEBUG BEGIN
echo >&2 "*** CHUCK execute_binary_no_args_test START" 
echo >&2 "*** CHUCK  @: ${@:-}" 
set -x
# DEBUG END

my_bin="$(rlocation cgrindel_bazel_shlib/tests/execute_binary_tests/my_bin_no_args)"
"${my_bin}"

# output=$("${my_bin}")
# Cheap and dirty assertion
# grep "Args Count: 0"

# DEBUG BEGIN
fail "STOP"
# DEBUG END
