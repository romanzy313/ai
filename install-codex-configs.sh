#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "Usage: $0" >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
codex_dir="${CODEX_HOME:-$HOME/.codex}"
mkdir -p -- "$codex_dir"
codex_dir=$(cd -- "$codex_dir" && pwd)

python3 - "$script_dir/codex/gpu.config.toml" "$codex_dir" <<'PY'
import json
import sys
from pathlib import Path

source = Path(sys.argv[1])
destination = Path(sys.argv[2])
profile = source.read_text().replace(
    'model_catalog_json = "ollama-models.json"',
    'model_catalog_json = ' + json.dumps(str(destination / 'ollama-models.json')),
)
(destination / 'gpu.config.toml').write_text(profile)
PY

cp -f -- "$script_dir/codex/ollama-models.json" "$codex_dir/ollama-models.json"
printf 'Overwrote %s/gpu.config.toml and %s/ollama-models.json\n' "$codex_dir" "$codex_dir"
