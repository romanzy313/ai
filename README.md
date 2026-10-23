# What Is This?

A simple docker-compose setup to run local LLMs with Ollama. CPU and AMDGPU
configs are available.

Uncomment Open WebUI to run it.

# Custom Models

`models/qwen3.5-4b-16k.Modelfile` configures `jetelain/Qwen3.5-4B:latest` with a
16,384-token context. To recreate it in the AMD container:

```bash
./import-model-amd.sh qwen3.5-4b-16k
./ollama-amd run qwen3.5-4b-16k
```

The import script accepts a model name and uses the matching
`models/<model-name>.Modelfile`.

# Codex Integration

Codex can connect to the AMD Ollama server using the `gpu` profile. Save this
configuration as `~/.codex/gpu.config.toml` on the machine running Codex:

```toml
model = "qwen3.5-4b-16k"
model_provider = "ollama-remote"
model_catalog_json = "/home/romanzy/.codex/ollama-models.json"

[model_providers.ollama-remote]
name = "Ollama"
base_url = "http://desktop.home.internal:11434/v1"
wire_api = "responses"
requires_openai_auth = false
```

Copy the local model catalog into your Codex configuration directory:

```bash
cp codex/ollama-models.json ~/.codex/ollama-models.json
```

Set `model_catalog_json` to the absolute path of that file on your machine.
The catalog includes the 16K and 64K Qwen3.5 4B models. To add another model,
copy an entry in `codex/ollama-models.json`, set its `slug` to the Ollama model
name, and adjust its display name, description, and context limits. Copy the
updated catalog into `~/.codex/` and restart Codex to load the changes.

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
