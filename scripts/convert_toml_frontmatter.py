#!/usr/bin/env python3
"""
Convert TOML-style frontmatter (+++ with key = value) to YAML-style (--- with key: value)
for markdown files under src/. Also extract `date` from frontmatter and prepend `YYYY-MM-DD-`
to the filename (replacing any existing date prefix).

Usage:
  python scripts/convert_toml_frontmatter.py [--apply] [--extensions .md,.markdown] [--root src]

By default the script performs a preview (no writes). Use --apply to make changes.

New option: --recursive / -r  : when set, recurse into subdirectories; otherwise only process files directly
under the provided root directory.
"""

import argparse
import os
import re
import sys
import json
from pathlib import Path

# Try to use tomllib (Python 3.11+), then toml package, else fallback
try:
    import tomllib as _toml
    def parse_toml(s):
        return _toml.loads(s)
except Exception:
    try:
        import toml as _toml
        def parse_toml(s):
            return _toml.loads(s)
    except Exception:
        _toml = None
        def parse_toml(s):
            # Fallback naive parser: parse simple key = value lines. Returns dict of string values when unsure.
            data = {}
            for raw in s.splitlines():
                line = raw.strip()
                if not line or line.startswith('#') or line.startswith('['):
                    continue
                m = re.match(r"^([A-Za-z0-9_\-]+)\s*=\s*(.+)$", line)
                if not m:
                    continue
                k = m.group(1)
                v = m.group(2).strip()
                # strip comments
                v = re.sub(r"\s+#.*$", "", v).strip()
                # remove surrounding quotes if present
                if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                    v = v[1:-1]
                data[k] = v
            return data

DATE_PREFIX_RE = re.compile(r"^(\d{4}-\d{2}-\d{2})-")
FRONT_OPEN = re.compile(r"^\+\+\+\s*$", re.MULTILINE)


def convert_toml_dict_to_yaml_lines(d):
    # Convert a plain dict to simple YAML key: value lines. Use JSON for complex structures.
    lines = []
    for k, v in d.items():
        if isinstance(v, str):
            # if string looks like a datetime or contains quotes, keep as double-quoted
            safe = v.replace('"', '\\"')
            lines.append(f"{k}: \"{safe}\"")
        elif isinstance(v, bool):
            lines.append(f"{k}: {str(v).lower()}")
        elif isinstance(v, (int, float)):
            lines.append(f"{k}: {v}")
        else:
            # lists, dicts, etc -> JSON inline
            lines.append(f"{k}: {json.dumps(v, ensure_ascii=False)}")
    return lines


def convert_block_naive(toml_text):
    lines = []
    for raw in toml_text.splitlines():
        if not raw.strip():
            lines.append("")
            continue
        if raw.lstrip().startswith('#'):
            lines.append(raw)
            continue
        m = re.match(r"^([A-Za-z0-9_\-]+)\s*=\s*(.+)$", raw)
        if m:
            k = m.group(1)
            v = m.group(2).strip()
            # keep arrays/dicts as-is; if quoted string, remove outer quotes and re-quote with double quotes
            if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                v_inner = v[1:-1].replace('"', '\\"')
                lines.append(f"{k}: \"{v_inner}\"")
            else:
                lines.append(f"{k}: {v}")
        else:
            # unknown line, copy as comment
            lines.append(f"# {raw}")
    return lines


def process_file(path: Path, apply: bool):
    text = path.read_text(encoding='utf-8')
    # If already YAML frontmatter with --- at top, skip
    if text.startswith('---'):
        return None
    # Find leading +++ block (capture entire block between markers). Allow closing marker at EOF.
    m = re.match(r"^\+\+\+\s*\n(.*?)\n\+\+\+\s*(?:\n|$)", text, re.DOTALL)
    if not m:
        return None
    toml_block = m.group(1)
    rest = text[m.end():]

    # Parse toml_block
    parsed = None
    try:
        parsed = parse_toml(toml_block)
    except Exception:
        parsed = None

    if isinstance(parsed, dict):
        yaml_lines = convert_toml_dict_to_yaml_lines(parsed)
    else:
        yaml_lines = convert_block_naive(toml_block)

    new_front = '---\n' + '\n'.join(yaml_lines) + '\n---\n'
    new_text = new_front + rest

    # Extract date for filename
    date_val = None
    # Try parsed dict first
    if isinstance(parsed, dict) and 'date' in parsed:
        date_val = parsed['date']
    else:
        # fallback: search in naive lines for a date key
        for line in toml_block.splitlines():
            m2 = re.match(r"^\s*date\s*=\s*(.+)$", line)
            if m2:
                v = m2.group(1).strip()
                # strip quotes
                if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                    v = v[1:-1]
                date_val = v
                break

    date_prefix = None
    if date_val:
        # try to find YYYY-MM-DD inside date_val
        m3 = re.search(r"(\d{4}-\d{2}-\d{2})", date_val)
        if m3:
            date_prefix = m3.group(1)

    # Determine new filename
    old_name = path.name
    rest_name = old_name
    if DATE_PREFIX_RE.match(old_name):
        # drop existing date prefix
        rest_name = DATE_PREFIX_RE.sub('', old_name)

    new_name = old_name
    if date_prefix:
        new_name = f"{date_prefix}-{rest_name}"

    changes = {}
    if new_text != text:
        changes['frontmatter'] = True
    if new_name != old_name:
        changes['rename'] = (old_name, new_name)

    if not changes:
        return None

    if apply:
        # write new content
        path.write_text(new_text, encoding='utf-8')
        # rename if needed
        if "rename" in changes:
            new_path = path.with_name(new_name)
            path.rename(new_path)
            return {'path': str(new_path), 'changed': changes}
        return {'path': str(path), 'changed': changes}
    else:
        return {'path': str(path), 'would_change': changes, 'new_text_preview': new_text[:2000], 'new_name': new_name}


def find_files(root: Path, exts, recursive=False):
    """Yield files to process. If recursive is True, walk subdirectories (rglob),
    otherwise only return files directly under `root` (one-level)."""
    if recursive:
        for p in root.rglob('*'):
            if p.is_file() and p.suffix.lower() in exts:
                yield p
    else:
        for p in root.iterdir():
            if p.is_file() and p.suffix.lower() in exts:
                yield p


def main():
    p = argparse.ArgumentParser(description='Convert +++ TOML frontmatter to --- YAML and prefix files with date')
    p.add_argument('--apply', action='store_true', help='Apply changes instead of preview')
    p.add_argument('--extensions', default='.md,.markdown', help='Comma-separated extensions to process')
    p.add_argument('--root', default='src', help='Root directory containing files to process')
    p.add_argument('--recursive', '-r', action='store_true', help='Recurse into subdirectories')
    args = p.parse_args()

    root = Path(args.root)
    if not root.exists():
        print(f"Root {root} does not exist", file=sys.stderr)
        sys.exit(2)

    exts = set(e.lower().strip() for e in args.extensions.split(','))

    any_changes = False
    for f in find_files(root, exts, recursive=args.recursive):
        res = process_file(f, args.apply)
        if res:
            any_changes = True
            if args.apply:
                print(f"Updated: {res['path']}")
                if 'changed' in res and 'rename' in res['changed']:
                    old, new = res['changed']['rename']
                    print(f"  Renamed: {old} -> {new}")
            else:
                print(f"Would change: {res['path']}")
                if 'would_change' in res:
                    wc = res['would_change']
                    if 'frontmatter' in wc:
                        print('  - frontmatter will be converted')
                    if 'rename' in wc:
                        old, new = wc['rename'] if isinstance(wc['rename'], tuple) else (f.name, res['new_name'])
                        print(f"  - filename would be: {new}")
    if not any_changes:
        print('No applicable files found or no changes needed.')

if __name__ == '__main__':
    main()
