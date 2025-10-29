#!/usr/bin/env python3
"""
Add `layout: post` to YAML front matter of markdown files under src/.

Usage:
  scripts/add_layout_to_frontmatter.py [--apply] [--src DIR] [--exts EXT,EXT]

By default the script runs in dry-run mode and prints the actions it would take.
Use --apply to actually write changes.

Behavior:
 - Recursively finds files in `src/` with the given extensions (default: .md,.markdown)
 - If a file has YAML front matter (starts with `---`), it checks for an existing `layout:` key.
   - If `layout:` exists, the file is skipped.
   - Otherwise `layout: post` is inserted as the first key in the front matter.
 - If a file does not have YAML front matter, a front matter block is prepended:
   ---\nlayout: post\n---\n\n
This script is conservative and safe by default (dry-run). It attempts to preserve file encoding
and permissions when writing.
"""

from __future__ import annotations
import argparse
import sys
from pathlib import Path
import re
import shutil
import tempfile


def process_file(path: Path, apply: bool) -> str:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return "skipped: binary or non-utf8"

    lines = text.splitlines(keepends=True)
    if lines and lines[0].strip() == "---":
        # find closing '---'
        end_idx = None
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                end_idx = i
                break
        if end_idx is None:
            # malformed front matter, treat as no front matter
            prepend = "---\nlayout: post\n---\n\n"
            new_text = prepend + text
            if apply:
                _atomic_write(path, new_text)
            return "added (malformed front matter, prepended)"

        front_matter = "".join(lines[1:end_idx])
        # Detect existing layout key (case-insensitive) to avoid duplicate additions
        if re.search(r"^\s*layout\s*:", front_matter, flags=re.M | re.I):
            return "skipped: already has layout"

        # insert layout: post as the first item in front matter (after opening ---\n)
        insertion = "layout: post\n"
        lines.insert(1, insertion)
        new_text = "".join(lines)
        if apply:
            _atomic_write(path, new_text)
        return "added"
    else:
        # no front matter, prepend one
        prepend = "---\nlayout: post\n---\n\n"
        new_text = prepend + text
        if apply:
            _atomic_write(path, new_text)
        return "added (prepended)"


def _atomic_write(path: Path, text: str) -> None:
    # preserve mode
    mode = path.stat().st_mode
    dirpath = path.parent
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=str(dirpath), delete=False) as tf:
        tf.write(text)
        tmpname = tf.name
    shutil.copymode(path, tmpname)
    Path(tmpname).replace(path)
    path.chmod(mode)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Add `layout: post` to markdown front matter in src/")
    parser.add_argument("--apply", action="store_true", help="Actually modify files. Default: dry-run")
    parser.add_argument("--src", default="src", help="Source directory to scan (default: src)")
    parser.add_argument("--exts", default="md,markdown", help="Comma-separated extensions to include (default: md,markdown)")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    args = parser.parse_args(argv)

    src = Path(args.src)
    if not src.exists():
        print(f"Source directory {src} does not exist", file=sys.stderr)
        return 2

    exts = tuple(f".{e.lstrip('.').lower()}" for e in args.exts.split(",") if e.strip())
    files = [p for p in src.rglob("*") if p.is_file() and p.suffix.lower() in exts]
    if not files:
        print("No matching markdown files found.")
        return 0

    summary = {"added": 0, "skipped: already has layout": 0, "skipped: binary or non-utf8": 0, "added (prepended)": 0, "added (malformed front matter, prepended)": 0}
    other_skips = 0
    for p in sorted(files):
        result = process_file(p, apply=args.apply)
        if args.verbose:
            print(f"{p}: {result}")
        # increment summary key if known
        if result in summary:
            summary[result] += 1
        else:
            # other messages like 'added' or others
            if result == "added":
                summary["added"] += 1
            else:
                other_skips += 1
    # print brief report
    print("Summary:")
    print(f"  added: {summary['added']}")
    print(f"  added (prepended): {summary['added (prepended)']}")
    print(f"  added (malformed front matter, prepended): {summary['added (malformed front matter, prepended)']}")
    print(f"  skipped: already has layout: {summary['skipped: already has layout']}")
    print(f"  skipped: binary/non-utf8: {summary['skipped: binary or non-utf8']}")
    if other_skips:
        print(f"  other: {other_skips}")

    if not args.apply:
        print("\nDry-run mode: no files were modified. Re-run with --apply to make changes.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
