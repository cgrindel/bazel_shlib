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


# MARK - Even Numbered Array

array=(aa ab ac ba bb bc)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

contains_item_sorted "za" "${array[@]}" && fail "Expected 'za' not to be found"

# MARK - Odd Numbered Array

array=(aa ab ac ba bb)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

contains_item_sorted "zb" "${array[@]}" && fail "Expected 'zb' not to be found"


# MARK - One Item Array

array=(aa)

for item in "${array[@]}" ; do
  contains_item_sorted "${item}" "${array[@]}" || fail "Expected '${item}' to be found."
done

contains_item_sorted "zc" "${array[@]}" && fail "Expected 'zc' not to be found"


# MARK - Empty Array

contains_item_sorted "aa" && fail "Expected 'aa' not to be found in empty array"

# MARK - Performance Tests

iterations=1000
array=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

do_contains_item_perf_test() {
  for (( i = 0; i < $iterations; i++ )); do
    for item in "${array[@]}" ; do
      contains_item "${item}" "${array[@]}"
    done
  done
}

do_contains_item_sorted_perf_test() {
  for (( i = 0; i < $iterations; i++ )); do
    for item in "${array[@]}" ; do
      contains_item_sorted "${item}" "${array[@]}"
    done
  done
}

# contains_item_time=$(time 2>&1  for (( i = 0; i < $iterations; i++ )); do do_contains_item_perf_test;  done)
# contains_item_sorted_time=$(time 2>&1 for (( i = 0; i < $iterations; i++ )); do do_contains_item_sorted_perf_test;  done)
# contains_item_time="$(time do_contains_item_perf_test 2>&1)"
# contains_item_sorted_time="$(time 2>&1 do_contains_item_sorted_perf_test 2>&1)"
contains_item_time="$( (time do_contains_item_perf_test) 2>&1 )"
contains_item_sorted_time="$( (time do_contains_item_sorted_perf_test) 2>&1 )"

echo >&2 "*** CHUCK  contains_item_time: ${contains_item_time}" 
echo >&2 "*** CHUCK  contains_item_sorted_time: ${contains_item_sorted_time}" 

# DEBUG BEGIN

# echo >&2 "*** CHUCK contains_item a" 
# time for (( i = 0; i < $iterations; i++ )); do contains_item "a" "${array[@]}";  done

# echo >&2 "*** CHUCK contains_item_sorted a" 
# time for (( i = 0; i < $iterations; i++ )); do contains_item_sorted "a" "${array[@]}";  done


# echo >&2 "*** CHUCK contains_item z" 
# time for (( i = 0; i < ${iterations}; i++ )); do contains_item "z" "${array[@]}";  done

# echo >&2 "*** CHUCK contains_item_sorted z" 
# time for (( i = 0; i < ${iterations}; i++ )); do contains_item_sorted "z" "${array[@]}";  done


fail "STOP"

# DEBUG END

# Made it to the end successfully
exit 0
