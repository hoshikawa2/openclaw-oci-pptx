#!/usr/bin/env bash
set -euo pipefail

# Where to install scripts (default matches typical OpenClaw workspace folder)
TARGET_DIR="${OPENCLAW_WORKDIR:-$HOME/.openclaw/workspace/openclaw_folder}"
mkdir -p "$TARGET_DIR"

cat > "$TARGET_DIR/read_url" << 'EOF'
#!/usr/bin/env python3
import sys
import requests
from bs4 import BeautifulSoup

def normalize_github_blob(url: str) -> str:
    # Convert github.com/.../blob/... to raw.githubusercontent.com/.../.../...
    if "github.com/" in url and "/blob/" in url:
        parts = url.split("github.com/", 1)[1].split("/blob/", 1)
        repo = parts[0].strip("/")
        rest = parts[1].lstrip("/")
        return f"https://raw.githubusercontent.com/{repo}/{rest}"
    return url

if len(sys.argv) < 2:
    print("Usage: read_url <url>", file=sys.stderr)
    sys.exit(1)

url = normalize_github_blob(sys.argv[1])

try:
    r = requests.get(url, timeout=30)
    r.raise_for_status()
    content = r.text

    # If HTML, extract visible text
    if "<html" in content.lower() or "<body" in content.lower():
        soup = BeautifulSoup(content, "html.parser")
        content = soup.get_text("\n")

    print(content)

except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
EOF

cat > "$TARGET_DIR/read_file" << 'EOF'
#!/usr/bin/env python3
import sys
from pathlib import Path

def read_pdf(path: Path) -> str:
    try:
        import fitz  # PyMuPDF
    except Exception:
        raise RuntimeError("PyMuPDF (fitz) not installed. Install with: pip install pymupdf")
    doc = fitz.open(str(path))
    out = []
    for i in range(doc.page_count):
        out.append(doc.load_page(i).get_text("text"))
    return "\n".join(out)

if len(sys.argv) < 2:
    print("Usage: read_file <path>", file=sys.stderr)
    sys.exit(1)

p = Path(sys.argv[1]).expanduser()
if not p.exists():
    print(f"ERROR: file not found: {p}", file=sys.stderr)
    sys.exit(1)

suffix = p.suffix.lower()
try:
    if suffix == ".pdf":
        print(read_pdf(p))
    else:
        print(p.read_text(encoding="utf-8", errors="replace"))
except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
EOF

chmod +x "$TARGET_DIR/read_url" "$TARGET_DIR/read_file"

echo "✅ Installed: $TARGET_DIR/read_url and $TARGET_DIR/read_file"
