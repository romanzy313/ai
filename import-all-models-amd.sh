#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "Usage: $0" >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
shopt -s nullglob
model_files=("$script_dir"/models/*.Modelfile)

if [[ ${#model_files[@]} -eq 0 ]]; then
  echo "No Modelfiles found in $script_dir/models" >&2
  exit 1
fi

for model_file in "${model_files[@]}"; do
  model_name=${model_file##*/}
  "$script_dir/import-model-amd.sh" "${model_name%.Modelfile}"
done
