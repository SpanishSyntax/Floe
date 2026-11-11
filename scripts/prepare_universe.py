#!/usr/bin/env python3
"""Stage Floe for submission to typst/packages.

Usage:
    python3 scripts/prepare_universe.py /path/to/typst-packages-fork

Copies every file not matched by `exclude` in typst.toml into
<fork>/packages/preview/floe/<version>/, rewrites no sources, then runs
`typst-package-check` on it if installed.
"""

from __future__ import annotations

import re
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    fork = Path(sys.argv[1]).expanduser().resolve()
    if not (fork / "packages" / "preview").is_dir():
        sys.exit(f"{fork} does not look like a typst/packages checkout")

    meta = tomllib.loads((ROOT / "typst.toml").read_text())["package"]
    ver, name = meta["version"], meta["name"]
    exclude = set(meta.get("exclude", [])) | {".git", ".gitignore"}
    for required in ("LICENSE", "README.md", meta["entrypoint"], meta.get("thumbnail", "thumbnail.png")):
        if not (ROOT / required).exists():
            sys.exit(f"missing required file: {required}")

    dest = fork / "packages" / "preview" / name / ver
    if dest.exists():
        sys.exit(f"{dest} already exists; published versions are immutable, bump the version")

    def ignore(directory: str, names: list[str]) -> list[str]:
        rel = Path(directory).relative_to(ROOT)
        return [n for n in names if str(rel / n).lstrip("./") in exclude or n in exclude or n == "__pycache__"]

    shutil.copytree(ROOT, dest, ignore=ignore)
    size = sum(f.stat().st_size for f in dest.rglob("*") if f.is_file())
    print(f"staged {dest} ({size / 1024:.0f} KiB)")

    leaked = [p for p in dest.rglob("*.typ") if "@local/floe" in p.read_text()]
    for p in leaked:
        print(f"  warning: @local/floe import in {p.relative_to(dest)}")

    checker = shutil.which("typst-package-check")
    if checker:
        subprocess.run([checker, "check", f"{name}/{ver}"], cwd=fork, check=False)
    else:
        print("typst-package-check not found; install it and run: typst-package-check check floe/" + ver)
    print(f"next: cd {fork} && git checkout -b floe-{ver} && git add packages/preview/{name}/{ver} && git commit -m '{name}:{ver}'")


if __name__ == "__main__":
    main()
