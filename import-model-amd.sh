#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <model-name>" >&2
  exit 1
fi

model_name=$1
case "$model_name" in
  ''|[!a-zA-Z0-9]*|*[!a-zA-Z0-9._:-]*)
    echo "Invalid model name: $model_name" >&2
    exit 1
    ;;
esac

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
model_file="$script_dir/models/$model_name.Modelfile"
container_file="/tmp/$model_name.Modelfile"

if [[ ! -f "$model_file" ]]; then
  echo "Modelfile not found: $model_file" >&2
  exit 1
fi

docker cp "$model_file" "ollama-amd:$container_file"
docker exec ollama-amd ollama create "$model_name" -f "$container_file"
