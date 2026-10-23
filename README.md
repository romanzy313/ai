# What Is This?

A simple docker-compose setup to run local LLMs with Ollama. CPU and AMDGPU
configs are available.

Uncomment Open WebUI to run it.

# Custom Models

The `models/` directory contains Qwen3.5 4B and 9B variants with 16K, 32K,
and 64K contexts. Each uses a batch size of 128 and disables speculative
decoding to reduce memory usage.

| Base model | Variants |
| --- | --- |
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

Codex can connect to the AMD Ollama server using the `gpu` profile. Install
its configuration and model catalog on the machine running Codex:

```bash
./install-codex-configs.sh
```

This overwrites `gpu.config.toml` and `ollama-models.json` in `~/.codex/`
(or `$CODEX_HOME` when set). The script sets the catalog path to its absolute
installation path. It requires Python 3.

Edit `codex/gpu.config.toml` to change the server address or default model.
The profile disables web search, app connectors (including Sites), plugins,
memory generation and use, analytics, feedback submission, and OpenTelemetry
export. Local memory storage does not by itself guarantee local processing:
memory generation can involve model requests. These settings do not enforce
a network block on the Codex process or its shell commands.

The catalog includes all six Qwen3.5 variants listed above. To add another model,
copy an entry in `codex/ollama-models.json`, set its `slug` to the Ollama model
name, and adjust its display name, description, and context limits. Run
`./install-codex-configs.sh` again and restart Codex to load the changes.

Start Codex with this profile:

```bash
codex -p gpu
```

Use `/model` inside Codex to select a model from the local catalog. The catalog
replaces the built-in model list for the `gpu` profile; other profiles keep
their usual model lists.

To use another model after importing it:

```bash
codex -p gpu -m qwen3.5-whatever
```

# Models I Recommend

These are okay models capable running on higher-end desktop hardware.

- [llama3.1:8b](https://ollama.com/library/llama3.1)
- [llama3.2:3b](https://ollama.com/library/llama3.2)
- [qwen2.5-coder:7b](https://ollama.com/library/qwen2.5-coder)
- [qwen2.5-coder:14b](https://ollama.com/library/qwen2.5-coder)
- [deepseek-coder-v2:16b](https://ollama.com/library/deepseek-coder-v2)
