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

arrays_lib="$(rlocation cgrindel_bazel_shlib/lib/arrays.sh)"
source "${arrays_lib}"

# DEBUG BEGIN
echo >&2 "*** CHUCK START" 
# DEBUG END

# MARK - Even Numbered Array

array=(aa ab ac ba bb bc)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

# DEBUG BEGIN
echo >&2 "*** CHUCK FOO" 
# DEBUG END

# contains_item_sorted "za" "${array[@]}" && fail "Expected 'za' not to be found"
(contains_item_sorted "za" "${array[@]}" && fail "Expected 'za' not to be found") || [[ 0 == 0 ]]

# DEBUG BEGIN
echo >&2 "*** CHUCK END EVEN" 
# DEBUG END

# MARK - Odd Numbered Array

array=(aa ab ac ba bb)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

contains_item_sorted "zb" "${array[@]}" && fail "Expected 'zb' not to be found"

# DEBUG BEGIN
echo >&2 "*** CHUCK END ODD" 
# DEBUG END

# MARK - One Item Array

array=(aa)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

contains_item_sorted "zc" "${array[@]}" && fail "Expected 'zc' not to be found"

# DEBUG BEGIN
echo >&2 "*** CHUCK END ONE" 
# DEBUG END

# MARK - Empty Array

contains_item_sorted "aa" && fail "Expected 'aa' not to be found in empty array"

# DEBUG BEGIN
echo >&2 "*** CHUCK END EMPTY" 
# DEBUG END

# Made it to the end successfully
exit 0
