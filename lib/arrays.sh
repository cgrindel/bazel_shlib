#!/usr/bin/env bash

# This is used to determine if the library has been loaded
arrays_lib_loaded() { return; }

sort_items() {
  local IFS=$'\n'
  sort -u <<<"$*"
}

print_by_line() {
  for item in "${@:-}" ; do
    echo "${item}"
  done
}

# Lovingly inspired by https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

