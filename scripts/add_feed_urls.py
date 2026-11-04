#!/usr/bin/env python3
"""Add `feed_url:` front matter to project blog pages missing it.

A page gets feed_url only when the project collection it renders has a feed
declared in config/initializers.rb (feed.collections list).
Skips pages that already have feed_url.
Dry-run by default; --apply writes.
"""
import re
import sys
from pathlib import Path

SRC = Path("src")
INIT = Path("config/initializers.rb")

def feed_collections() -> set[str]:
    text = INIT.read_text()
    names = set(re.findall(r"^\s+([a-z0-9_]+) \{\}", text, re.M))
    names.discard("collections")
    return names

def main(apply: bool) -> int:
    feeds = feed_collections()
    added, skipped_nofeed, skipped_has = [], [], []
    for page in sorted(SRC.glob("*.erb")):
        text = page.read_text()
        if "feed_url:" in text.split("---", 2)[1] if text.startswith("---") else False:
            skipped_has.append(page.name)
            continue
        m = re.search(r"p\['name'\]\s*==\s*'([^']+)'", text)
        if not m:
            continue  # not a project blog page (about, family pages, etc.)
        slug = m.group(1)
        coll = slug.replace("-", "_")
        if coll not in feeds:
            skipped_nofeed.append(f"{page.name} -> {coll}")
            continue
        feed_url = f"/feed/{coll}.xml"
        new_text, n = re.subn(r"(^---\n(?:.*\n)*?)(---\n)",
                              lambda mo: mo.group(1) + f"feed_url: {feed_url}\n" + mo.group(2),
                              text, count=1)
        if n != 1:
            print(f"!! could not patch front matter: {page.name}", file=sys.stderr)
            continue
        if apply:
            page.write_text(new_text)
        added.append(f"{page.name} -> {feed_url}")
    print(f"added: {len(added)}  skipped(no feed configured): {len(skipped_nofeed)}  skipped(already has): {len(skipped_has)}")
    for a in added:
        print("  +", a)
    if skipped_nofeed:
        print("pages whose collection has no feed configured:")
        for s in skipped_nofeed:
            print("  -", s)
    return 0

if __name__ == "__main__":
    sys.exit(main("--apply" in sys.argv))
