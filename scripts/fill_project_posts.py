#!/usr/bin/env python3
"""
Fill in empty or missing project posts (intro and releases) by fetching data from GitHub.
Requires GITHUB_TOKEN environment variable for higher rate limits.
"""
import os
import sys
import re
import json
import urllib.request
from pathlib import Path
from datetime import datetime

def parse_projects_yml(path: Path):
    text = path.read_text(encoding="utf-8")
    projects = []
    # Split by "- name:" at the start of a line
    chunks = re.split(r'^-\s+name:\s*', text, flags=re.MULTILINE)
    for chunk in chunks:
        if not chunk.strip():
            continue

        lines = chunk.splitlines()
        name_line = lines[0].strip().strip('"').strip("'")
        if name_line == "---": continue # skip front matter marker if captured

        project = {"name": name_line, "funding_sites": []}

        current_forge = None
        current_funding = None

        # Simplified parser for required fields
        for line in lines[1:]:
            stripped = line.strip()
            if not stripped: continue

            if stripped.startswith("role:"):
                project["role"] = stripped.split(":", 1)[1].strip().strip('"').strip("'")
            elif stripped.startswith("description:"):
                desc = stripped.split(":", 1)[1].strip()
                if desc in ("|", ">"):
                    # Find following indented lines
                    desc_lines = []
                    start_collecting = False
                    for l in lines[lines.index(line)+1:]:
                        if not l.strip():
                            desc_lines.append("")
                            continue
                        if l.startswith("    ") or l.startswith("  "):
                            desc_lines.append(l.strip())
                            start_collecting = True
                        elif start_collecting:
                            break
                    project["description"] = " ".join(desc_lines).strip()
                else:
                    project["description"] = desc.strip('"').strip("'")
            elif stripped.startswith("- type: GitHub"):
                current_forge = "GitHub"
            elif current_forge == "GitHub" and stripped.startswith("url:"):
                project["github_url"] = stripped.split(":", 1)[1].strip().strip('"').strip("'")
                current_forge = None
            elif stripped.startswith("- type:"):
                current_funding = {"type": stripped.split(":", 1)[1].strip()}
            elif current_funding and stripped.startswith("url:"):
                current_funding["url"] = stripped.split(":", 1)[1].strip().strip('"').strip("'")
                project["funding_sites"].append(current_funding)
                current_funding = None

        projects.append(project)
    return projects

def github_api_call(url):
    token = os.environ.get("GITHUB_TOKEN")
    req = urllib.request.Request(url)
    if token:
        req.add_header("Authorization", f"token {token}")
    req.add_header("User-Agent", "peterboling.com-automation")
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"Error calling {url}: {e}")
        return None

def get_repo_slug(url):
    if not url: return None
    match = re.search(r"github\.com/([^/]+/[^/]+)", url)
    return match.group(1) if match else None

def fill_intro(project, src_dir):
    coll_name = project["name"].replace("-", "_")
    intro_path = src_dir / f"_{coll_name}" / "intro.md"

    # Check if intro exists and is empty
    needs_fill = False
    intro_file = None
    if not list(src_dir.glob(f"_{coll_name}/*intro.md")):
        needs_fill = True
        intro_path = src_dir / f"_{coll_name}" / "intro.md"
    else:
        intro_path = list(src_dir.glob(f"_{coll_name}/*intro.md"))[0]
        content = intro_path.read_text()
        # If it's just front matter and no body
        if content.count("---") == 2 and not content.split("---")[-1].strip():
            needs_fill = True

    if not needs_fill:
        return

    print(f"Filling intro for {project['name']}...")
    slug = get_repo_slug(project.get("github_url"))
    if not slug:
        print(f"No GitHub slug for {project['name']}")
        return

    # Fetch README
    readme_data = github_api_call(f"https://api.github.com/repos/{slug}/readme")
    if not readme_data or "content" not in readme_data:
        print(f"Could not fetch README for {slug}")
        return

    import base64
    readme_content = base64.b64decode(readme_data["content"]).decode("utf-8")

    # Extract synopsis/first few paragraphs
    # Remove badges, title
    clean_readme = re.sub(r"^#.*", "", readme_content, flags=re.MULTILINE)
    clean_readme = re.sub(r"\[!\[.*?\]\(.*?\)\].*?\n", "", clean_readme)
    clean_readme = re.sub(r"!\[.*?\]\(.*?\)\n", "", clean_readme)

    synopsis = ""
    paragraphs = [p for p in clean_readme.split("\n\n") if p.strip()]
    if paragraphs:
        # Take first 2 non-empty paragraphs as synopsis
        synopsis = "\n\n".join(paragraphs[:2])

    funding_links = ""
    if project["funding_sites"]:
        funding_links = "\n\n### Supporting this Project\n"
        for site in project["funding_sites"]:
            funding_links += f"- [{site['type']}]({site['url']})\n"

    # Front matter
    new_front_matter = {
        "layout": "post",
        "title": f"Introducing {project['name']}",
        "date": datetime.now().strftime("%Y-%m-%d"),
        "tags": ["introduction", project["name"]]
    }

    # Try to keep existing front matter if it exists
    existing_front_matter_str = ""
    if intro_path.exists():
        existing = intro_path.read_text().split("---")
        if len(existing) >= 3:
            existing_front_matter_str = existing[1].strip()

    body = f"""{synopsis}

### Getting Started

For more information and detailed examples, please visit the [documentation]({project.get('github_url', '')}).
{funding_links}
"""

    if existing_front_matter_str:
        full_content = "---\n" + existing_front_matter_str + "\n---\n\n" + body
    else:
        full_content = "---\n"
        for k, v in new_front_matter.items():
            if isinstance(v, list):
                full_content += f"{k}: {json.dumps(v)}\n"
            else:
                full_content += f"{k}: {v}\n"
        full_content += "---\n\n" + body

    intro_path.parent.mkdir(parents=True, exist_ok=True)
    intro_path.write_text(full_content, encoding="utf-8")

def fill_releases(project, src_dir):
    slug = get_repo_slug(project.get("github_url"))
    if not slug: return

    releases = github_api_call(f"https://api.github.com/repos/{slug}/releases")
    if not releases: return

    coll_name = project["name"].replace("-", "_")
    releases_dir = src_dir / f"_{coll_name}" / "releases"
    releases_dir.mkdir(parents=True, exist_ok=True)

    for rel in releases:
        tag = rel["tag_name"]
        published_at = rel["published_at"] # e.g. 2024-07-05T14:41:16Z
        date_str = published_at.split("T")[0]

        # Check if post already exists
        filename = f"{date_str}-{project['name']}-{tag}.md"
        post_path = releases_dir / filename
        if post_path.exists():
            continue

        print(f"Creating release post for {project['name']} {tag}...")

        title = f"{project['name']} {tag} released!"
        body = rel.get("body", "No release notes provided.")

        front_matter = f"""---
layout: post
title: "{title}"
date: "{published_at}"
tags: ["release", "{project['name']}", "{tag}"]
---

{body}
"""
        post_path.write_text(front_matter, encoding="utf-8")

def main():
    projects_path = Path("src/_data/projects.yml")
    src_dir = Path("src")
    projects = parse_projects_yml(projects_path)

    target_roles = ["author", "maintainer"]

    for project in projects:
        role = project.get("role")
        if role in target_roles:
            print(f"Processing {project['name']}...")
            fill_intro(project, src_dir)
            fill_releases(project, src_dir)

if __name__ == "__main__":
    main()
