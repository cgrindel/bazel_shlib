#!/usr/bin/env bash
args=()
while (("$#")); do
  case "${1}" in
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

echo "Args Count: ${#args[@]}"
if [[ ${#args[@]} > 0 ]]; then
  echo "Args: ${args[@]}"
fi
