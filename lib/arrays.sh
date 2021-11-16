#!/usr/bin/env bash

# This is used to determine if the library has been loaded
cgrindel_bazel_shlib_lib_arrays_loaded() { return; }

# Sorts the arguments and outputs a unique and sorted list with each item on its own line.
#
# Args:
#   *: The items to sort.
#
# Outputs:
#   stdout: A line per unique item.
#   stderr: None.
sort_items() {
  local IFS=$'\n'
  sort -u <<<"$*"
}

# Prints the arguments with each argument on its own line.
#
# Args:
#   *: The items to print.
#
# Outputs:
#   stdout: A line per item.
#   stderr: None.
print_by_line() {
  for item in "${@:-}" ; do
    echo "${item}"
  done
}

# Joins the arguments by the provided separator.
#
# Args:
#   separator: The separator that should be printed between each item.
#   *: The items to join.
#
# Outputs:
#   stdout: A string where the items are separated by the separator.
#   stderr: None.
join_by() {
  # Lovingly inspired by https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
  local IFS="$1"
  shift
  echo "$*"
}

