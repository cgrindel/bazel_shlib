#!/usr/bin/env bash

# Outputs a message to stderr and exits
exit_with_msg() {
  local err_msg="${1:-}"
  local exit_code=${2:-1}
  [[ -n "${err_msg}" ]] || err_msg="Unspecified error occurred."
  echo >&2 "${err_msg}"
  # exit 1
  exit ${exit_code}
}

