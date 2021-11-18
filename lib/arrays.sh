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

# RECURSIVE IMPL
# contains_item_sorted() {
#   local expected="${1}"
#   shift

#   local items_count=${#}
#   [[ ${items_count} == 0 ]] && return -1

#   if [[ ${items_count} == 1 ]]; then
#     [[ "${expected}" == ${1} ]] && return
#     return -1
#   fi

#   local half=$(( ${items_count}/2 ))
#   local mid_idx=$(( ${half} + 1))
#   local mid="${!mid_idx}"
#   [[  "${expected}" == "${mid}" ]] && return 

#   if [[ "${expected}" < "${mid}" ]]; then
#     local subarray=( "${@:1:$half}" )
#   else
#     local subarray=( "${@:$mid_idx}" )
#   fi
#   contains_item_sorted "${expected}" "${subarray[@]}"
# }

# LOOP IMPL - WORKS BUT SLOWER THAN contains_item
contains_item_sorted() {
  local expected="${1}"
  shift

  local start_idx=1
  local end_idx=${#}
  local items_count=${end_idx}
  # for (( i = 0; i < ${#}; i++ )); do
  # for i in {1..${#}}; do
  [[ ${items_count} == 0 ]] && return -1
  while [[ 0 == 0 ]]; do
    # Find midpoint
    local half=$(( ${items_count}/2 ))
    local mid_idx=$(( ${start_idx} + ${half} ))
    local mid="${!mid_idx}"

    [[  "${expected}" == "${mid}" ]] && return 
    [[ ${items_count} == 1 ]] && return -1

    if [[ "${expected}" < "${mid}" ]]; then
      local end_idx=$(( ${mid_idx} - 1 ))
    else
      [[ ${mid_idx} == ${end_idx} ]] && return -1
      local start_idx=$(( ${mid_idx} + 1 ))
    fi
    local items_count=$(( ${end_idx} - ${start_idx} + 1 ))
  done
  return -1
}

# Removed one var - FASTER THAN contains_item_sorted
contains_item_sorted_a() {
  local expected="${1}"
  shift
  [[ ${#} == 0 ]] && return -1

  local start_idx=1
  local end_idx=${#}
  local items_count=${end_idx}
  while [[ 0 == 0 ]]; do
    # Find midpoint
    local mid_idx=$(( ${start_idx} + ${items_count}/2 ))
    local mid="${!mid_idx}"

    [[  "${expected}" == "${mid}" ]] && return 
    [[ ${items_count} == 1 ]] && return -1

    if [[ "${expected}" < "${mid}" ]]; then
      local end_idx=$(( ${mid_idx} - 1 ))
    else
      [[ ${mid_idx} == ${end_idx} ]] && return -1
      local start_idx=$(( ${mid_idx} + 1 ))
    fi
    local items_count=$(( ${end_idx} - ${start_idx} + 1 ))
  done
  return -1
}

# Shortend var names - FASTER THAN contains_item_sorted_a
contains_item_sorted_b() {
  local x="${1}"
  shift
  [[ ${#} == 0 ]] && return -1

  local s=1
  local e=${#}
  local c=${e}
  while [[ 0 == 0 ]]; do
    # Find midpoint
    local mi=$(( ${s} + ${c}/2 ))
    local me="${!mi}"

    [[  "${x}" == "${me}" ]] && return 
    [[ ${c} == 1 ]] && return -1

    if [[ "${x}" < "${me}" ]]; then
      local e=$(( ${mi} - 1 ))
    else
      [[ ${mi} == ${e} ]] && return -1
      local s=$(( ${mi} + 1 ))
    fi
    local c=$(( ${e} - ${s} + 1 ))
  done
  return -1
}

# Removed me variable - Faster than contains_item_sorted_b, same as contains_item
contains_item_sorted_c() {
  local x="${1}"
  shift
  [[ ${#} == 0 ]] && return -1

  local s=1
  local e=${#}
  local c=${e}
  while [[ 0 == 0 ]]; do
    # Find midpoint
    local mi=$(( ${s} + ${c}/2 ))

    [[  "${x}" == "${!mi}" ]] && return 
    [[ ${c} == 1 ]] && return -1

    if [[ "${x}" < "${!mi}" ]]; then
      local e=$(( ${mi} - 1 ))
    else
      [[ ${mi} == ${e} ]] && return -1
      local s=$(( ${mi} + 1 ))
    fi
    local c=$(( ${e} - ${s} + 1 ))
  done
  return -1
}

# Removed count var - Fastest (0.191s vs 0.214s contains_item)
contains_item_sorted_d() {
  local x="${1}"
  shift
  [[ ${#} == 0 ]] && return -1

  local s=1
  local e=${#}
  while [[ 0 == 0 ]]; do
    # Find midpoint
    local mi=$(( ${s} + (${e} - ${s} + 1)/2 ))

    [[  "${x}" == "${!mi}" ]] && return 
    [[ ${s} == ${e} ]] && return -1

    if [[ "${x}" < "${!mi}" ]]; then
      local e=$(( ${mi} - 1 ))
    else
      [[ ${mi} == ${e} ]] && return -1
      local s=$(( ${mi} + 1 ))
    fi
  done
  return -1
}

# Shortened var names - Faster than contains_item (0.209s vs 0.216s)
contains_item_a() {
  local x="${1}"
  shift
  # Do a quick regex to see if the value is in the rest of the args
  # If not, then don't bother looping
  [[ ! "${*}" =~ "${x}" ]] && return -1
  # Loop through items for a precise match
  for it in "${@}" ; do
    [[ "${it}" == "${x}" ]] && return 0
  done
  # We did not find the item
  return -1
}
