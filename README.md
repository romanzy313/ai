# What Is This?

A simple docker-compose setup to run local LLMs with Ollama. CPU and AMDGPU
configs are available.

Uncomment Open WebUI to run it.

# Custom Models

The `models/` directory contains Qwen3.5 4B and 9B variants with 16K, 32K, and
64K contexts. Each uses a batch size of 128 and disables speculative decoding to
reduce memory usage.

| Base model                   | Variants                                             |
| ---------------------------- | ---------------------------------------------------- |
| `jetelain/Qwen3.5-4B:latest` | `qwen3.5-4b-16k`, `qwen3.5-4b-32k`, `qwen3.5-4b-64k` |
| `jetelain/Qwen3.5-9B:latest` | `qwen3.5-9b-16k`, `qwen3.5-9b-32k`, `qwen3.5-9b-64k` |

To recreate a variant in the AMD container:

```bash
./import-model-amd.sh qwen3.5-4b-16k
./ollama-amd run qwen3.5-4b-16k
```

The import script accepts a model name and uses the matching
`models/<model-name>.Modelfile`. To import all variants, replacing any existing
models with the same names:

```bash
./import-all-models-amd.sh
```

# Codex Integration

Codex can connect to the AMD Ollama server using the `gpu` profile. Install its
configuration and model catalog on the machine running Codex:

```bash
./install-codex-configs.sh
```

Start Codex with these profiles:

```bash
codex -p gpu
codex -p oss
```

Use `/model` inside Codex to select a model from the local catalog. The catalog
replaces the built-in model list for the `gpu` profile; other profiles keep
their usual model lists. Thinking mode is also implemented, but its super slow.

## Keep small models focused

The GPU catalog's shortened base prompt is also stored in
[codex/short-instruction.txt](codex/short-instruction.txt) for readability. Keep that file
and every `base_instructions` entry in `codex/ollama-models.json` identical.

The full official prompt used by `codex/oss-models.json` is duplicated in
[codex/official-instruction.txt](codex/official-instruction.txt).

Use [codex/AGENTS.md](codex/AGENTS.md) as a starting point for a project's root
`AGENTS.md`. It makes small models behave better.

# Models I Recommend

These are okay models capable running on higher-end desktop hardware.

- [llama3.1:8b](https://ollama.com/library/llama3.1)
- [llama3.2:3b](https://ollama.com/library/llama3.2)
- [qwen2.5-coder:7b](https://ollama.com/library/qwen2.5-coder)
- [qwen2.5-coder:14b](https://ollama.com/library/qwen2.5-coder)
- [deepseek-coder-v2:16b](https://ollama.com/library/deepseek-coder-v2)
