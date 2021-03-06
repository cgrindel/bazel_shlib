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

# MARK - Additional Assertions

assert_arg() {
  local output="${1}"
  local index="${2}"
  local value="${3}"
  [[ "${output}" =~ "  ${index}: ${value}" ]] || fail "Expected ${index}: ${value}
  ${output}
  "
}

assert_embedded_args() {
  local output="${1}"
  assert_arg "${output}" 1 "--first"
  assert_arg "${output}" 2 "first_value"
  assert_arg "${output}" 3 "--second"
  assert_arg "${output}" 4 "second value has spaces"
  assert_arg "${output}" 5 "not_a_flag"
  assert_arg "${output}" 6 "quoted value with spaces"
}

# MARK - Test that embedded arguments are passed along properly.

output=$("${my_bin}")
[[ "${output}" =~ "Args Count: 6" ]] || fail "Expected args count of 6.
${output}
"
assert_embedded_args "${output}"

# MARK - Test that additional arguments are passed along properly

output=$("${my_bin}" additional_arg)

[[ "${output}" =~ "Args Count: 7" ]] || fail "Expected args count of 7.
${output}
"
assert_embedded_args "${output}"
assert_arg "${output}" 7 "additional_arg"
