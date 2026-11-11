#!/usr/bin/env python3
"""Atomically bump Floe's version across typst.toml, docs, schema, and local symlinks.

Usage:
    python3 scripts/bump_version.py 0.2.1
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent


def get_current_version() -> str:
    toml_text = (ROOT_DIR / "typst.toml").read_text(encoding="utf-8")
    m = re.search(r'^version\s*=\s*"([^"]+)"', toml_text, re.MULTILINE)
    if not m:
        raise RuntimeError("Could not find version in typst.toml")
    return m.group(1)


def replace_in_file(path: Path, old: str, new: str) -> bool:
    if not path.exists():
        return False
    text = path.read_text(encoding="utf-8")
    updated = text.replace(old, new)
    if updated != text:
        path.write_text(updated, encoding="utf-8")
        return True
    return False


def main() -> None:
    if len(sys.argv) != 2 or not re.match(r"^\d+\.\d+\.\d+$", sys.argv[1]):
        print("Usage: python3 scripts/bump_version.py <MAJOR.MINOR.PATCH>", file=sys.stderr)
        sys.exit(1)

    new_ver = sys.argv[1]
    old_ver = get_current_version()
    print(f"Bumping Floe version: {old_ver} -> {new_ver}")

    # 1. Update typst.toml
    toml_path = ROOT_DIR / "typst.toml"
    toml_text = toml_path.read_text(encoding="utf-8")
    toml_text = re.sub(
        r'^version\s*=\s*"[^"]+"',
        f'version = "{new_ver}"',
        toml_text,
        count=1,
        flags=re.MULTILINE,
    )
    toml_path.write_text(toml_text, encoding="utf-8")
    print("  [ok] typst.toml")

    # 2. Update @local/floe:<ver> references across README.md and docs/
    old_import = f"@local/floe:{old_ver}"
    new_import = f"@local/floe:{new_ver}"
    old_pkg = f"@preview/floe:{old_ver}"
    new_pkg = f"@preview/floe:{new_ver}"

    doc_files = [
        ROOT_DIR / "README.md",
        ROOT_DIR / "docs" / "index.html",
        *sorted((ROOT_DIR / "docs").glob("*.md")),
    ]
    for path in doc_files:
        changed = False
        changed |= replace_in_file(path, old_import, new_import)
        changed |= replace_in_file(path, old_pkg, new_pkg)
        changed |= replace_in_file(path, f"local/floe/{old_ver}", f"local/floe/{new_ver}")
        changed |= replace_in_file(path, f"v{old_ver}", f"v{new_ver}")
        if changed:
            print(f"  [ok] {path.relative_to(ROOT_DIR)}")

    # 3. Ensure ~/.local/share/typst/packages/local/floe/<new_ver> symlink exists
    local_pkg_dir = Path.home() / ".local" / "share" / "typst" / "packages" / "local" / "floe"
    local_pkg_dir.mkdir(parents=True, exist_ok=True)
    new_link = local_pkg_dir / new_ver
    if new_link.is_symlink() or new_link.exists():
        new_link.unlink()
    new_link.symlink_to(ROOT_DIR)
    print(f"  [ok] symlink {new_link} -> {ROOT_DIR}")

    # 4. Regenerate floe.json
    subprocess.run([sys.executable, str(ROOT_DIR / "scripts" / "generate_schema.py")], check=True)
    print("  [ok] regenerated floe.json")


if __name__ == "__main__":
    main()
