#!/usr/bin/env python3
"""Floe Schema Generator — Automated Typst AST & Docstring Extractor for AI Agents.

Extracts all exported primitives, mixins, components, and presets from Floe's Typst
source code and compiles them into a structured, machine-readable `floe.json` schema.

Usage:
    python3 scripts/generate_schema.py
"""

from __future__ import annotations

import json
import re
import tomllib
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent


def parse_typst_toml() -> dict[str, str]:
    """Parse Floe package metadata from typst.toml."""
    manifest_path = ROOT_DIR / "typst.toml"
    if not manifest_path.is_file():
        return {"name": "floe", "version": "0.2.0", "description": "Floe Design System"}
    with manifest_path.open("rb") as f:
        data = tomllib.load(f).get("package", {})
    return {
        "name": data.get("name", "floe"),
        "version": data.get("version", "0.2.0"),
        "description": data.get("description", "Floe Design System"),
    }


def parse_function_definition(doc_lines: list[str], def_text: str) -> dict[str, any]:
    """Parse a single #let func(args) = definition."""
    match = re.match(r"#let\s+([a-zA-Z0-9_\-]+)\s*\((.*?)\)\s*=", def_text, re.DOTALL)
    if not match:
        return None

    name = match.group(1).strip()
    raw_args = match.group(2).strip()

    description = " ".join(line.lstrip("/").strip() for line in doc_lines if line.startswith("///")).strip()
    if not description:
        description = f"Floe component `{name}`"

    # Tokenize arguments
    args: dict[str, dict[str, any]] = {}
    if raw_args:
        # Split top-level commas respecting parentheses and brackets
        tokens = []
        depth = 0
        current = []
        for ch in raw_args:
            if ch in "([{":
                depth += 1
            elif ch in ")]}":
                depth -= 1
            elif ch == "," and depth == 0:
                tokens.append("".join(current).strip())
                current = []
                continue
            current.append(ch)
        if current:
            tokens.append("".join(current).strip())

        for token in tokens:
            if not token or token == "..sink" or token == "..args":
                continue
            if ":" in token:
                arg_name, def_val = token.split(":", 1)
                arg_name = arg_name.strip()
                def_val = def_val.strip()
                args[arg_name] = {
                    "type": infer_type(def_val),
                    "default": def_val,
                    "required": False,
                }
            else:
                arg_name = token.strip()
                if arg_name == "body":
                    args["body"] = {"type": "content", "required": True}
                else:
                    args[arg_name] = {"type": "content | str", "required": True}

    return {
        "name": name,
        "description": description,
        "args": args,
    }


def infer_type(val_str: str) -> str:
    """Infer argument type from Typst default value expression."""
    clean = val_str.strip()
    if clean in ("none", "auto"):
        return "content | str | none"
    if clean in ("true", "false"):
        return "bool"
    if clean.startswith('"') or clean.startswith("'"):
        return "str"
    if clean.isdigit() or (clean.startswith("-") and clean[1:].isdigit()):
        return "int"
    if clean.endswith("pt") or clean.endswith("cm") or clean.endswith("mm") or clean.endswith("em") or clean.endswith("fr"):
        return "length | fraction"
    if clean.startswith("rgb(") or "floe-" in clean or "slate-" in clean:
        return "color"
    if clean.startswith("(") and clean.endswith(")"):
        return "array | tuple"
    return "any"


def scan_typst_file(file_path: Path) -> list[dict[str, any]]:
    """Scan a Typst file for exported #let components with preceding doc comments."""
    text = file_path.read_text(encoding="utf-8")
    lines = text.splitlines()

    components = []
    doc_lines = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line.startswith("///"):
            doc_lines.append(line)
            i += 1
            continue
        if line.startswith("#let ") and not line.startswith("#let _"):
            # Accumulate full definition up to assignment
            def_lines = [line]
            while i < len(lines) and "=" not in def_lines[-1]:
                i += 1
                if i < len(lines):
                    def_lines.append(lines[i].strip())
            def_text = " ".join(def_lines)
            comp = parse_function_definition(doc_lines, def_text)
            if comp:
                rel_path = file_path.relative_to(ROOT_DIR)
                comp["file"] = str(rel_path)
                components.append(comp)
            doc_lines = []
        elif line and not line.startswith("//"):
            doc_lines = []
        i += 1

    return components


def generate_floe_schema() -> dict[str, any]:
    """Generates the master schema index across all layers."""
    meta = parse_typst_toml()
    layers = {
        "layer_0_core": {
            "title": "Core Foundation",
            "path": "core/lib.typ",
            "description": "Design tokens, color scales, typography stacks, radii, strokes, and third-party packages.",
            "tokens": {
                "colors": ["floe-navy", "floe-cyan", "floe-slate", "floe-muted", "floe-green", "floe-amber", "floe-red", "floe-purple"],
                "slate": ["slate-50", "slate-100", "slate-200", "slate-300", "slate-400", "slate-500", "slate-600", "slate-700", "slate-800", "slate-900", "slate-950"],
                "fonts": {
                    "sans": "Inter, Liberation Sans, FreeSans",
                    "serif": "New Computer Modern, Linux Libertine, Times New Roman",
                    "display": "Inter Display, Inter",
                    "mono": "Iosevka NF, Source Code Pro, Consolas",
                },
                "radii": ["xs", "sm", "md", "lg", "xl", "full"],
                "strokes": ["hairline", "thin", "border", "thick", "accent"],
            },
        },
        "layer_1_primitives": {
            "title": "Atomic Primitives",
            "path": "primitives/lib.typ",
            "description": "Zero-domain structural boxes, plaques, badges, dividers, and steppers.",
            "components": [],
        },
        "layer_2_mixins": {
            "title": "Composable Show Rules",
            "path": "mixins/lib.typ",
            "description": "Pure document show rules configuring global typography, math, code blocks, tables, and running chrome.",
            "components": [],
        },
        "layer_3_components": {
            "title": "High-Level Pedagogical Components",
            "path": "components/lib.typ",
            "description": "Academic callouts, exam trap cards, formula breakdown canvases, layout grids, and headers.",
            "components": [],
        },
        "layer_4_presets": {
            "title": "Document Presets",
            "path": "presets/lib.typ",
            "description": "Ready-to-use master document wrappers configured with appropriate geometry, typography, and headers.",
            "components": [],
        },
    }

    dir_to_layer = {
        "primitives": "layer_1_primitives",
        "mixins": "layer_2_mixins",
        "components": "layer_3_components",
        "presets": "layer_4_presets",
    }

    for dir_name, layer_key in dir_to_layer.items():
        layer_dir = ROOT_DIR / dir_name
        if not layer_dir.is_dir():
            continue
        for f in sorted(layer_dir.glob("*.typ")):
            if f.name == "lib.typ":
                continue
            comps = scan_typst_file(f)
            layers[layer_key]["components"].extend(comps)

    return {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "name": meta["name"],
        "version": meta["version"],
        "description": meta["description"],
        "import_statement": f'#import "@local/{meta["name"]}:{meta["version"]}": *',
        "layers": layers,
    }


def main():
    schema = generate_floe_schema()
    out_file = ROOT_DIR / "floe.json"
    with out_file.open("w", encoding="utf-8") as f:
        json.dump(schema, f, indent=2)
    total_comps = sum(len(layer.get("components", [])) for layer in schema["layers"].values())
    print(f"✔ Successfully extracted {total_comps} components across {len(schema['layers'])} layers -> {out_file}")


if __name__ == "__main__":
    main()
