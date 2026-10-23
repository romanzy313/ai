#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "Usage: $0" >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
codex_dir="${CODEX_HOME:-$HOME/.codex}"
mkdir -p -- "$codex_dir"
cp -f -- "$script_dir/codex/gpu.config.toml" "$codex_dir/gpu.config.toml"
cp -f -- "$script_dir/codex/oss.config.toml" "$codex_dir/oss.config.toml"
cp -f -- "$script_dir/codex/ollama-models.json" "$codex_dir/ollama-models.json"
cp -f -- "$script_dir/codex/oss-models.json" "$codex_dir/oss-models.json"
printf 'Installed GPU and OSS profiles and model catalogs in %s\n' "$codex_dir"
