#!/usr/bin/env bash

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source ".runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " ".runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " ".exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

if [[ $(type -t paths_lib_loaded) != function ]]; then
  paths_lib="$(rlocation cgrindel_bazel_shlib/lib/paths.sh)"
  source "${paths_lib}"
fi

# This is used to determine if the library has been loaded
files_lib_loaded() {
  return 0
}

# Recursively searches for a file starting from the current directory up to the root of the filesystem.
#
# Flags:
# 
# Args:
#
# Outputs:
#   stdout: None.
#   stderr: None.
upsearch() {
  # Lovingly inspired by https://unix.stackexchange.com/a/13474.

  local error_if_not_found=0
  local start_dir="${PWD}"
  local args=()
  while (("$#")); do
    case "${1}" in
      "--start_dir")
        local start_dir="${2}"
        shift 2
        ;;
      *)
        args+=( "${1}" )
        shift 1
        ;;
    esac
  done

  local target_file="${args[0]}"

  slashes=${start_dir//[^\/]/}
  directory="${start_dir}"
  for (( n=${#slashes}; n>0; --n ))
  do
    local test_path="${directory}/${target_file}"
    test -e "${test_path}" && \
      normalize_path "${test_path}" &&  return 
    directory="${directory}/.."
  done

  # Did not find the file
  if [[ ${error_if_not_found} == 1 ]]; then
    return 1
  fi
}

