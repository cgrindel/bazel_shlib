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

# Succeeds if the first argument is one of the follow-on arguments. Otherwise fails.
#
# Args:
#   expected: The first argument is the expected value.
#   *: The follow on arguments are the list values being checked. They can be in any order.
#
# Outputs:
#   stdout: None.
#   stderr: None.
#   Returns 0 if the expected value is found. Otherwise returns -1.
contains_item() {
  local expected="${1}"
  shift
  # Do a quick regex to see if the value is in the rest of the args
  # If not, then don't bother looping
  [[ ! "${*}" =~ "${expected}" ]] && return -1
  # Loop through items for a precise match
  for item in "${@}" ; do
    [[ "${item}" == "${expected}" ]] && return 0
  done
  # We did not find the item
  return -1
}

contains_item_sorted() {
  local expected="${1}"
  shift

  local items_count=${#}
  # DEBUG BEGIN
  echo >&2 "*** CHUCK  items_count: ${items_count}" 
  # DEBUG END
  [[ ${items_count} == 0 ]] && return -1

  if [[ ${items_count} == 1 ]]; then
    [[ "${expected}" == ${1} ]] && return
    return -1
  fi

  local half=$(( ${items_count}/2 ))
  local mid_idx=$(( ${half} + 1))
  local mid="${!mid_idx}"
  # DEBUG BEGIN
  echo >&2 "*** CHUCK  half: ${half}" 
  echo >&2 "*** CHUCK  mid_idx: ${mid_idx}" 
  echo >&2 "*** CHUCK  mid: ${mid}" 
  # DEBUG END
  [[  "${expected}" == "${mid}" ]] && return 

  if [[ "${expected}" < "${mid}" ]]; then
    # DEBUG BEGIN
    echo >&2 "*** CHUCK LESS THAN" 
    # DEBUG END
    local subarray=( "${@:1:$half}" )
  else
    # DEBUG BEGIN
    echo >&2 "*** CHUCK GREATER THAN" 
    # DEBUG END
    local subarray=( "${@:$mid_idx}" )
  fi
  contains_item_sorted "${expected}" "${subarray[@]}"
}
