#!/usr/bin/env bash

# Outputs a message to stderr and exits
exit_with_msg() {
  # local err_msg="${1:-}"
  # local exit_code=${2:-1}
  # local exit_or_return="${3:-exit}"
  local exit_code=1
  local no_exit=0

  local args=()
  while (("$#")); do
    case "${1}" in
      "--exit_code")
        local exit_code=${2}
        shift 2
        ;;
      "--no_exit")
        local no_exit=1
        shift 1
        ;;
      *)
        args+=("${1}")
        shift 1
        ;;
    esac
  done

  local err_msg="${args[*]:-}"

  [[ -n "${err_msg}" ]] || err_msg="Unspecified error occurred."
  echo >&2 "${err_msg}"
  if [[ ${no_exit} == 1 ]]; then
    return ${exit_code}
  fi
  exit ${exit_code}
}

