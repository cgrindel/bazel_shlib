#!/usr/bin/env bash

set -euo pipefail

args_count=($# - 1)
echo "Args Count: ${args_count}"
for (( i = 1; i <= ${#}; i++ )); do
  echo "  ${i}: ${!i}"
done


# args=()
# while (("$#")); do
#   case "${1}" in
#     *)
#       args+=("${1}")
#       shift 1
#       ;;
#   esac
# done

# echo "Args Count: ${#args[@]}"
# if [[ ${#args[@]} > 0 ]]; then
#   echo "Args: ${args[@]}"
#   for (( i = 0; i < ${#args[@]}; i++ )); do
#     echo "  ${i}: ${args[${i}]}"
#   done
# fi
