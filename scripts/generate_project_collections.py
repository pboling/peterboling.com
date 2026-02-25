#!/usr/bin/env python3
"""
Generate root collection pages for projects listed in `config/initializers.rb`.

Behavior:
- Parses `config/initializers.rb` for `project :name` entries.
- Reads `src/_data/projects.yml` and finds the project entry whose `name` matches
  either the collection name (underscores) or the dash-form (underscores->dashes).
- Creates `src/<project-name>.erb` (the filename equals the `name` value from projects.yml)
  containing a small ERB page that looks up the project data and renders its description.
- Skips files that already exist.
- Dry-run by default; pass `--apply` to actually write files.

Usage:
  scripts/generate_project_collections.py [--apply] [--initializers PATH] [--data PATH] [--src PATH]

"""
from __future__ import annotations
import argparse
import re
from pathlib import Path
import sys


TEMPLATE = """---
layout: page
title: "{title}"
---

<% project = site.data.projects.find {{ |p| p['name'] == '{name}' }} %>
<% project_name = project["name"] %>
<% collection_name = project_name.tr("-", "_") %>

<div class="project-root">
  <p class="project-description">
    <% if project['description'] %>
      <%== project['description'] %>
      <%= project['description'][-1].match?(/[[:punct:]]/) ? "." : "" %>
    <% end %>
    <% if project['docs_site'] && !project['docs_site'].empty? %>
      Read the <a href="<%= project['docs_site'] %>" target="_blank" rel="noopener">documentation</a>.
    <% end %>
  </p>
</div>

<div class="posts-list">
  <p>Tips and updates about <%= project_name %>.</p>
  <% collections.send(collection_name).resources.sort_by(&:date).reverse.each do |post| %>
    <article class="post-item">
      <h2><a href="<%= post.relative_url %>"><%= post.data.title %></a></h2>
      <time datetime="<%= post.date.strftime('%Y-%m-%d') %>">
        <%= post.date.strftime('%B %d, %Y') %>
      </time>
      <% if post.data.excerpt %>
        <p><%= post.data.excerpt %></p>
      <% end %>
    </article>
  <% end %>
</div>
"""


def parse_initializers(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    # match lines like: project :activerecord_tablefree
    names = re.findall(r"\bproject\s+:([a-zA-Z0-9_]+)", text)
    return sorted(set(names))


def parse_projects_yml(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    names: list[str] = []
    # find occurrences of '- name: <value>' capturing quoted or unquoted names
    for m in re.finditer(r"-\s+name:\s*(?:\"([^\"]+)\"|'([^']+)'|([^\n]+))", text):
        name = (m.group(1) or m.group(2) or m.group(3) or "").strip()
        # strip any trailing spaces
        names.append(name)
    return names


def update_initializers(init_path: Path, project_names: list[str], apply: bool = False) -> list[str]:
    text = init_path.read_text(encoding="utf-8")
    existing_collections = parse_initializers(init_path)

    # We want a collection for every project.
    # Bridgetown collection names should use underscores.
    new_collections = []
    for name in project_names:
        coll_name = name.replace("-", "_").replace(" ", "_").lower()
        if coll_name not in existing_collections:
            new_collections.append(coll_name)

    if not new_collections:
        return []

    new_collections = sorted(set(new_collections))

    # Find the last 'project :name' line or the end of the 'collections do' block
    lines = text.splitlines()
    last_project_idx = -1
    collections_block_start = -1
    collections_block_end = -1

    for i, line in enumerate(lines):
        if "collections do" in line:
            collections_block_start = i
        if collections_block_start != -1 and line.strip() == "end" and collections_block_end == -1:
            # This is a bit naive if there are multiple 'end's, but should work for standard Bridgetown config
            # Let's look for the 'end' that matches the 'collections do' indentation
            if line.startswith("  end") or line.startswith("    end"):
                 collections_block_end = i
        if "project :" in line:
            last_project_idx = i

    if last_project_idx != -1:
        insert_idx = last_project_idx + 1
        indent = "    " # default Bridgetown indent
        new_lines = [f"{indent}project :{coll}" for coll in new_collections]

        if apply:
            for i, new_line in enumerate(new_lines):
                lines.insert(insert_idx + i, new_line)
            init_path.write_text("\n".join(lines) + "\n", encoding="utf-8")

        return [f"project :{coll}" for coll in new_collections]

    return []


def find_project_name_for_collection(collection: str, project_names: list[str]) -> str | None:
    """Given a collection name from the initializer (underscored), find the project name
    as it appears in projects.yml. Return None if not found.

    Matching is dash/underscore agnostic: we normalize both sides by removing
    dashes, underscores and spaces and comparing lowercase values.
    """
    # Fast exact checks first
    if collection in project_names:
        return collection
    cand_dash = collection.replace("_", "-")
    if cand_dash in project_names:
        return cand_dash
    cand_underscore = collection.replace("-", "_")
    if cand_underscore in project_names:
        return cand_underscore

    # Build normalized map for project names: normalized -> original
    def _normalize(s: str) -> str:
        return re.sub(r"[-_\s]+", "", s or "").lower()

    norm_map: dict[str, str] = {}
    for p in project_names:
        norm = _normalize(p)
        # keep the first occurrence if duplicates normalize the same
        if norm not in norm_map:
            norm_map[norm] = p

    coll_norm = _normalize(collection)
    if coll_norm in norm_map:
        return norm_map[coll_norm]

    # As a last resort, case-insensitive exact match
    for p in project_names:
        if p.lower() == collection.lower():
            return p

    return None


def make_page_content(name: str) -> str:
    # Use the name as title by default; if the name contains '-'/"_", present a nicer title
    title = name.replace('-', ' ').replace('_', ' ').strip().title()
    return TEMPLATE.format(title=title, name=name)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Generate project root collection pages")
    parser.add_argument("--apply", action="store_true", help="Write files (default: dry-run)")
    parser.add_argument("--initializers", default="config/initializers.rb")
    parser.add_argument("--data", default="src/_data/projects.yml")
    parser.add_argument("--src", default="src")
    args = parser.parse_args(argv)

    init_path = Path(args.initializers)
    data_path = Path(args.data)
    src_dir = Path(args.src)

    if not init_path.exists():
        print(f"Initializers file not found: {init_path}", file=sys.stderr)
        return 2
    if not data_path.exists():
        print(f"Projects data file not found: {data_path}", file=sys.stderr)
        return 2
    if not src_dir.exists():
        print(f"Source dir not found: {src_dir}", file=sys.stderr)
        return 2

    project_names = parse_projects_yml(data_path)
    inits_added = update_initializers(init_path, project_names, apply=args.apply)

    collections = parse_initializers(init_path)

    created = []
    skipped = []
    not_found = []
    dirs_created = []

    for coll in collections:
        proj_name = find_project_name_for_collection(coll, project_names)
        if not proj_name:
            not_found.append(coll)
            continue

        # Ensure collection directory exists: src/_<collection_name>
        # Note: Bridgetown expects underscores for collection directories.
        coll_dir = src_dir / f"_{coll}"
        if not coll_dir.exists():
            if args.apply:
                coll_dir.mkdir(parents=True, exist_ok=True)
                dirs_created.append(str(coll_dir))
            else:
                dirs_created.append(str(coll_dir) + " (dry-run)")

        dest = src_dir / f"{proj_name}.erb"
        if dest.exists():
            skipped.append(str(dest))
            continue
        content = make_page_content(proj_name)
        if args.apply:
            dest.write_text(content, encoding="utf-8")
            created.append(str(dest))
        else:
            created.append(str(dest) + " (dry-run)")

    print("Summary:")
    if inits_added:
        print(f"  initializers added: {len(inits_added)}")
        for i in inits_added:
            print(f"    {i}{' (dry-run)' if not args.apply else ''}")
    if dirs_created:
        print(f"  directories created: {len(dirs_created)}")
        for d in dirs_created:
            print(f"    {d}")
    print(f"  to_create: {len(created)}")
    if created:
        for c in created:
            print(f"    {c}")
    if skipped:
        print(f"  skipped (already exist): {len(skipped)}")
        for s in skipped:
            print(f"    {s}")
    if not_found:
        print(f"  collections with no matching project in projects.yml: {len(not_found)}")
        for n in not_found:
            print(f"    {n}")

    if not args.apply:
        print("\nDry-run mode: no files were written. Re-run with --apply to create files.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
