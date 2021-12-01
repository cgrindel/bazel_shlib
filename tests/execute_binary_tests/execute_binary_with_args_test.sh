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

my_bin="$(rlocation cgrindel_bazel_shlib/tests/execute_binary_tests/my_bin_with_args.sh)"

output=$("${my_bin}")
[[ "${output}" =~ "Args Count: 5" ]] || fail "Expected args count of 5.
${output}
"
# [[ "${output}" =~ "Args: --first second --third fourth fifth" ]]
[[ "${output}" =~ "  1: --first" ]] || fail "Expected --first
${output}
"
[[ "${output}" =~ "  2: first_value" ]] || fail "Expected first_value
${output}
"
[[ "${output}" =~ "  3: --second" ]] || fail "Expected --second
${output}
"
[[ "${output}" =~ "  4: second value has spaces" ]] || fail "Expected second value has spaces
${output}
"
[[ "${output}" =~ "  5: not_a_flag" ]] || fail "Expected not_a_flag
${output}
"
