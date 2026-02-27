# Generate PowerPoint Presentations with OpenClaw and Oracle Cloud Generative AI 

## Enterprise AI Power, Open Ecosystem, Zero Compromise

The rapid evolution of AI orchestration tools has reshaped how companies build intelligent systems. Among these tools, OpenClaw has emerged as a powerful open-source platform designed to simplify the creation of AI agents, conversational workflows, and multi-channel integrations.

OpenClaw is not just another wrapper around LLM APIs. It is:

* Modular
* Plugin-driven
* Open-source
* OpenAI-compatible
* Community-powered

Its OpenAI-compatible design makes it instantly interoperable with the entire AI tooling ecosystem — SDKs, automation frameworks, browser clients, bots, and custom agent pipelines.

And because it is open source, innovation happens in public.

There is an active and growing community contributing:

* New plugins
* Messaging integrations (WhatsApp, web, etc.)
* Tool execution engines
* Agent frameworks
* Workflow automation patterns
* Performance optimizations

This means OpenClaw evolves continuously — without vendor lock-in.

But while agility and innovation are essential, enterprises require something more:
* Security
* Governance
* Compliance
* Regional data sovereignty
* Observability
* Controlled network exposure
* Predictable scalability

This is where Oracle Cloud Infrastructure (OCI) Generative AI becomes the strategic enterprise choice.

⸻

## The Power of Ecosystem + Enterprise Security

### OpenClaw: Open Ecosystem Advantage

Because OpenClaw is:
* Open-source
* Community-driven
* Plugin-extensible
* OpenAI-protocol compatible

You benefit from:

* Rapid innovation
* Transparent architecture
* Community-tested integrations
* Zero dependency on a single SaaS provider
* Full customization capability

You are not locked into one AI vendor.
You control your orchestration layer.

This flexibility is critical in a world where models evolve rapidly and enterprises need adaptability.

⸻

## OCI Generative AI: Enterprise Trust Layer

Oracle Cloud Infrastructure adds what large organizations require:
* Fine-grained IAM control
* Signed API requests (no exposed API keys)
* Dedicated compartments
* Private VCN networking
* Sovereign cloud regions
* Enterprise SLAs
* Monitoring & logging integration
* Production-ready inference endpoints

OCI Generative AI supports powerful production-grade models such as:
* Cohere Command
* LLaMA family
* Embedding models
* Custom enterprise deployments
* OpenAI-compatible models via mapping

This creates a secure AI backbone inside your own tenancy.

⸻

## Why This Combination Is Strategically Powerful

By implementing a local OpenAI-compatible gateway backed by OCI:

OpenClaw continues to behave exactly as designed —
while inference happens securely inside Oracle Cloud.

You gain:
* Full OpenAI protocol compatibility
* Enterprise security boundaries
* Cloud tenancy governance
* Scalable AI inference
* Ecosystem extensibility
* Open-source flexibility

Without rewriting your agents.
Without breaking plugins.
Without sacrificing innovation.

------------------------------------------------------------------------

# Why Use OCI Generative AI?

Oracle Cloud Infrastructure provides:

-   Enterprise security (IAM, compartments, VCN)
-   Flexible model serving (ON_DEMAND, Dedicated)
-   High scalability
-   Cost control
-   Regional deployment control
-   Native integration with Oracle ecosystem

By building an OpenAI-compatible proxy, we combine:

OpenClaw flexibility + OCI enterprise power

------------------------------------------------------------------------


# OpenClaw + OCI Generative AI Gateway **and** PPTX Template Builder


## About the tutorial


### OpenAI-compatible endpoint 

This tutorial is based on [Integrating OpenClaw with Oracle Cloud Generative AI (OCI)](https://github.com/hoshikawa2/openclaw-oci) tutorial and  explains how to integrate **OpenClaw** with **Oracle Cloud
Infrastructure (OCI) Generative AI** by building an OpenAI-compatible
API gateway using FastAPI.

Instead of modifying OpenClaw's core, we expose an **OpenAI-compatible
endpoint** (`/v1/chat/completions`) that internally routes requests to
OCI Generative AI.

This approach provides:

-   ✅ Full OpenClaw compatibility
-   ✅ Control over OCI model mapping
-   ✅ Support for streaming responses
-   ✅ Enterprise-grade OCI infrastructure
-   ✅ Secure request signing via OCI SDK

### PPTX Builder

**A PPTX builder** will generate a professional **PowerPoint deck from a template** (`.pptx`) + a structured `content.json`

The goal is to keep **OpenClaw** fully compatible with the OpenAI protocol while moving inference to **OCI** and enabling **artifact generation (PPTX)** using a repeatable, governed pipeline.

---

## Architecture

```
OpenClaw
  ↓ (OpenAI protocol)
OpenAI-compatible Gateway (FastAPI)
  ↓ (signed OCI REST)
OCI Generative AI (chat endpoint)
  ↓
LLM response

(Optional)
Material (URL / file / text)
  ↓
content.json (validated / governed)
  ↓
PPTX Builder (template + content.json)
  ↓
openclaw_oci_presentation.pptx
```

---

## Project structure

```
project/
 ├── oci_openai_proxy.py                 # FastAPI OpenAI-compatible gateway -> OCI GenAI
 ├── pptx_runner_policy_strict.txt       # Strict policy for extracting/validating material -> content.json
 ├── openclaw.json                       # Example OpenClaw config using the gateway
 └── README.md
 AND these files:
 ├── generate_openclaw_ppt_template.py   # PPTX generator (template + content.json)
 ├── read_url_and_read_file.sh           # Helper script to create read_url/read_file in OpenClaw workspace
 └── template_openclaw_oci_clean.pptx    # You MUST have one template here

 
 Move these files to:
 $HOME/.openclaw/workspace/openclaw_folder
 ├── generate_openclaw_ppt_template.py   # PPTX generator (template + content.json)
 ├── read_url_and_read_file.sh           # Helper script to create read_url/read_file in OpenClaw workspace
 └── template_openclaw_oci_clean.pptx    # You MUST have one template here
```

---

# Part A — OpenAI-compatible Gateway (OpenClaw → OCI GenAI)

## Why OCI Generative AI?

OCI provides what enterprises usually need:

- IAM & compartments
- Signed requests (no API key leakage)
- Regional control / sovereignty
- VCN options
- Observability integration
- Production-grade inference endpoints

By putting an OpenAI-compatible API in front of OCI, you get:

- ✅ OpenClaw compatibility
- ✅ Model mapping (OpenAI names → OCI modelIds)
- ✅ Streaming compatibility (simulated if OCI returns full text)
- ✅ Governance inside your tenancy

---

## Requirements

- Python 3.10+ (recommended)
- OCI config file (`~/.oci/config`) + API key
- Network access to OCI GenAI endpoint

Install dependencies:

```bash

pip install fastapi uvicorn requests oci pydantic
```

---

## Configuration (environment variables)

The gateway reads OCI configuration using environment variables (defaults shown):

```bash

export OCI_CONFIG_FILE="$HOME/.oci/config"
export OCI_PROFILE="DEFAULT"
export OCI_COMPARTMENT_ID="ocid1.compartment.oc1..."
export OCI_GENAI_ENDPOINT="https://inference.generativeai.<region>.oci.oraclecloud.com"
```

---

## Run the server

```bash

uvicorn oci_openai_proxy:app --host 0.0.0.0 --port 8050
```

---

## Test with curl

```bash

curl http://127.0.0.1:8050/v1/chat/completions   -H "Content-Type: application/json"   -d '{
    "model": "gpt-5",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

---

## OpenClaw configuration (openclaw.json)

Point OpenClaw to the gateway:

- `baseUrl` → your local gateway (port 8050)
- `api` → **openai-completions**
- `model id` → must match a `MODEL_MAP` key inside `oci_openai_proxy.py`

Example provider block:

```json
{
  "models": {
    "providers": {
      "openai-compatible": {
        "baseUrl": "http://127.0.0.1:8050/v1",
        "apiKey": "sk-test",
        "api": "openai-completions"
      }
    }
  }
}
```

---

# Part B — PPTX generation from a template (Template → Deck)

## What it does

`generate_openclaw_ppt_template.py` builds a **fixed 7-slide** strategic deck:

1. Cover
2. Intro (use case)
3. Technologies
4. Architecture
5. Problems
6. Demo (includes the source link)
7. Conclusion

The deck is generated from:

- a **PPTX template** (with expected layouts),
- a `content.json` file,
- and a `OCI_LINK_DEMO` link (material source shown on the Demo slide).

---

## Inputs

### 1) PPTX template

You MUST have a PowerPoint template named **template_openclaw_oci_clean.pptx** with some master layout slides.

Default expected layout names inside the template:

- `Cover 1 - Full Image`
- `Full Page - Light`

You can change the template by passing `--template` or `PPTX_TEMPLATE_PATH`.

### 2) content.json

`content.json` must contain:

- `cover_title` (string)
- `introduction`, `technologies`, `architecture`, `problems`, `demo`, `conclusion` (objects)

Each section object must include:

- `bullets`: 3–6 short bullets
- `keywords`: 5–12 keywords that appear literally in the material
- `evidence`: 2–4 short excerpts (10–25 words) extracted from the material (no HTML)

The strict validation rules are described in `pptx_runner_policy_strict.txt`.

---

## Configure paths

Create a folder named **openclaw_folder** inside the $HOME/.openclaw/workspace.

``` bash

cd $HOME/.openclaw
mkdir openclaw_folder
cd openclaw_folder
```

Put these files into the openclaw_folder:

````
generate_openclaw_ppt_template.py
read_url_and_read_file.sh 
template_openclaw_oci_clean.pptx (Your PPTX template if you have)
````

Run this command only one time:
```
bash read_url_and_read_file.sh
```
This will generate the read_url and read_file tools.


You can run everything **without hardcoded paths** using either CLI flags or environment variables.

### Environment variables

```bash
# Optional: where your files live (default: current directory)
export OPENCLAW_WORKDIR="$HOME/.openclaw/workspace/openclaw_folder"

# Template + output
export PPTX_TEMPLATE_PATH="$OPENCLAW_WORKDIR/template_openclaw_oci_clean.pptx"
export PPTX_OUTPUT_PATH="$OPENCLAW_WORKDIR/openclaw_oci_presentation.pptx"

# Content JSON (if not set, defaults to $OPENCLAW_WORKDIR/content.json)
export OCI_CONTENT_FILE="$OPENCLAW_WORKDIR/content.json"

# Source link shown on the Demo slide
export OCI_LINK_DEMO="https://docs.oracle.com/en-us/iaas/Content/generative-ai/home.htm"
```

### CLI usage

```bash
python generate_openclaw_ppt_template.py   --template "$PPTX_TEMPLATE_PATH"   --output "$PPTX_OUTPUT_PATH"   --content "$OCI_CONTENT_FILE"   --link "$OCI_LINK_DEMO"
```

---

## End-to-end pipeline (URL → content.json → PPTX)

A typical (strict) flow:

1) **Read material** (URL or local file)  
2) **Generate `content.json`** following the strict policy  
3) **Validate JSON**  
4) **Generate PPTX**

### Helper scripts (read_url / read_file)

The repository includes `read_url e read_file.sh` to install helper scripts into your OpenClaw workspace.

Example:

```bash
bash "read_url e read_file.sh"
```

Then:

```bash
# Read URL
~/.openclaw/workspace/openclaw_folder/read_url "https://example.com" > material_raw.txt

# Read local file
~/.openclaw/workspace/openclaw_folder/read_file "/path/to/file.pdf" > material_raw.txt
```

### Validate JSON

```bash
python -m json.tool "$OCI_CONTENT_FILE" >/dev/null
```

### Generate PPTX

```bash
python gera_oci_ppt_openclaw_template.py --link "$OCI_LINK_DEMO"
```

---

## Deploying (common options)

### Option 1 — Run locally (developer laptop)

- Run the gateway with `uvicorn`
- Generate decks on demand in the workspace folder

### Option 2 — Server VM (systemd for gateway)

Create a systemd service (example):

```ini
[Unit]
Description=OpenAI-compatible OCI GenAI Gateway
After=network.target

[Service]
WorkingDirectory=/opt/openclaw-oci
Environment=OCI_CONFIG_FILE=/home/ubuntu/.oci/config
Environment=OCI_PROFILE=DEFAULT
Environment=OCI_COMPARTMENT_ID=ocid1.compartment...
Environment=OCI_GENAI_ENDPOINT=https://inference.generativeai.<region>.oci.oraclecloud.com
ExecStart=/usr/bin/python -m uvicorn oci_openai_proxy:app --host 0.0.0.0 --port 8050
Restart=always

[Install]
WantedBy=multi-user.target
```

### Option 3 — Containerize

- Put `oci_openai_proxy.py` inside an image
- Mount `~/.oci/config` read-only
- Pass the same env vars above

(Exact Dockerfile depends on how you manage OCI config and keys in your environment.)

---

## Troubleshooting

### PPTX builder errors

- **Layout not found**: your template does not have the expected layout names.
- **Too few placeholders**: your selected layout must have at least 2 text placeholders.
- **Exactly 7 slides**: the generator enforces the fixed structure.

### Content issues

- If `content.json` has generic bullets/keywords not present in the material, the strict policy should fail validation.
- If you cannot extract enough literal keywords, re-check your material extraction (HTML removal, raw GitHub URL, etc.).

---

## Test the Solution

Go to the openclaw dashboard:

```
openclaw dashboard
```

![img_1.png](images/img_1.png)

Try this:

```
generate a pptx based on this material https://github.com/hoshikawa2/openclaw-oci
```

![img_2.png](images/img_2.png)

And you get a temporary OCI Object Storage link:

![img_3.png](images/img_3.png)

This is the oci_openai_proxy.py monitoring output:

![img.png](images/img.png)

And the Presentation generated is:

![img_4.png](images/img_4.png)


---

# Final Notes

You now have:

✔ OpenClaw fully integrated\
✔ OCI Generative AI backend\
✔ Streaming compatibility\
✔ Enterprise-ready architecture

------------------------------------------------------------------------

# Reference

- [Integrating OpenClaw with Oracle Cloud Generative AI (OCI)](https://github.com/hoshikawa2/openclaw-oci)
- [Installing the OCI CLI](https://docs.oracle.com/en-us/iaas/private-cloud-appliance/pca/installing-the-oci-cli.htm)
- [Oracle Cloud Generative AI](https://www.oracle.com/artificial-intelligence/generative-ai/generative-ai-service/)
- [OpenClaw](https://openclaw.ai/)

# Acknowledgments

- **Author** - Cristiano Hoshikawa (Oracle LAD A-Team Solution Engineer)
