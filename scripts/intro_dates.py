#!/usr/bin/env python3
"""Date each project's intro post by when the project actually began, not when the post was written.

The intro posts were generated in bulk (112 of them on 2026-02-25), so "Introducing version_gem" claimed to be
from this year while the gem is years old, and every card's "latest post" showed that bogus date.

Rule, per project (all its registry entries considered together):
  author      -> the first registry release (rubygems / npm / crates.io / ...), else my first commit
  maintainer  -> when I joined: the later of the first release and my first commit (resque's 2009 release is not
                 my introduction), else whichever exists
Data: src/_data/projects.yml (first_commit_by_person_on) and the profile's data/first_release.json
(registry first-release dates; fetched from github.com/pboling/pboling when not given locally).

  scripts/intro_dates.py            dry run: show what would change
  scripts/intro_dates.py --apply    rewrite the `date:` of each src/_<collection>/intro.md
"""
import glob, json, re, sys, urllib.request
import yaml

ROOT = __file__.rsplit("/scripts/", 1)[0]
FIRST_RELEASE_URL = "https://raw.githubusercontent.com/pboling/pboling/main/data/first_release.json"


def load_first_release(path=None):
    if path:
        return json.load(open(path))
    with urllib.request.urlopen(FIRST_RELEASE_URL, timeout=30) as r:
        return json.load(r)


def by_collection(projects):
    out = {}
    for p in projects:
        coll = re.sub(r"[^A-Za-z0-9_]", "_", p["name"].replace("-", "_")).strip("_")
        out.setdefault(coll, []).append(p)
    return out


def intro_date(entries, first_release):
    """ISO date string for a project's entries, or None when nothing is known."""
    releases = [first_release.get(f"{e['ecosystem']}:{e['name']}") for e in entries]
    first_rel = min((d for d in releases if d), default=None)
    commits = [str(e.get("first_commit_by_person_on") or "").replace("/", "-") for e in entries]
    first_commit = min((d for d in commits if d), default=None)
    role = entries[0].get("role")
    if role == "author":
        return first_rel or first_commit
    if first_rel and first_commit:
        return max(first_rel, first_commit)
    return first_commit or first_rel


def date_for(name, projects=None, first_release=None):
    """Convenience for generators: the intro date for one project name."""
    projects = projects or yaml.safe_load(open(f"{ROOT}/src/_data/projects.yml"))
    first_release = first_release or load_first_release()
    entries = [p for p in projects if p["name"] == name]
    return intro_date(entries, first_release) if entries else None


def main(apply):
    projects = yaml.safe_load(open(f"{ROOT}/src/_data/projects.yml"))
    first_release = load_first_release()
    colls = by_collection(projects)
    changed = 0
    for path in sorted(glob.glob(f"{ROOT}/src/_*/intro.md")):
        coll = path.split("/")[-2][1:]
        if coll not in colls:
            continue
        new = intro_date(colls[coll], first_release)
        text = open(path).read()
        m = re.search(r"^date:\s*(\"?)(\d{4}-\d{2}-\d{2})[^\n]*$", text, re.M)
        if not (new and m) or m.group(2) == new:
            continue
        print(f"{coll:34} {colls[coll][0].get('role'):11} {m.group(2)} -> {new}")
        if apply:
            q = m.group(1)
            text = text[:m.start()] + f"date: {q}{new}{q}" + text[m.end():]
            open(path, "w").write(text)
        changed += 1
    print(f"{changed} intro dates {'updated' if apply else 'would change (re-run with --apply)'}")


if __name__ == "__main__":
    main("--apply" in sys.argv)
