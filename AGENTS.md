# AGENTS.md — AI Agent Operating Instructions

## ⚠️ Critical: Terminal Output Is Never Visible in the Tool Response

The `run_in_terminal` tool **never shows output in its return value**, even when it appears to.
Any output text shown in the tool result is unreliable and must be treated as absent.

**You MUST always redirect both STDOUT and STDERR to a file in `tmp/`, using `tee`**
so the user can also see the output in their terminal, and then read the file back
with the `read_file` tool.

### Standard Pattern for ALL Terminal Commands

```bash
<your command> 2>&1 | tee tmp/<descriptive_name>.txt
```

Then immediately follow with a `read_file` call:

```
read_file("tmp/<descriptive_name>.txt", startLine: 1, endLine: 100)
```

### Examples

```bash
# Ruby script
ruby scripts/my_script.rb 2>&1 | tee tmp/my_script_output.txt

# Count things in a YAML file
ruby -r yaml -e '...' 2>&1 | tee tmp/yaml_count.txt

# Bundle / gem commands
bundle exec rake 2>&1 | tee tmp/rake_output.txt

# Git commands
git status 2>&1 | tee tmp/git_status.txt

# Multi-step: chain and tee at the end
(cd /some/dir && command1 && command2) 2>&1 | tee tmp/result.txt
```

### Rules

1. **Never** run a command without `2>&1 | tee tmp/<name>.txt`.
2. **Always** call `read_file` on the tee'd file immediately after the terminal call.
3. **Never** assume a command succeeded or produced specific output — always read the file.
4. **Never** make decisions based on the (unreliable) inline tool response text.
5. Use descriptive filenames in `tmp/` so multiple outputs don't collide (e.g., `tmp/rubygems_discover.txt`, `tmp/projects_count.txt`).
6. The `tmp/` directory already exists in this repo (see `tmp/pids/`); files written there are gitignored.

## Project Context

- **Framework**: Bridgetown (Ruby static site generator)
- **Key data files**:
  - `src/_data/projects.yml` — list of all projects shown on the site
  - `src/_data/families.yml` — project family groupings and metadata
  - `src/_data/person.yml` — consolidated author/person biographical data (previously split between person.yml and author.yaml)

### Data Files Overview

**person.yml (as of 2026-02-24)**
- Consolidates author information: full_name, name, nickname, greeting, image, contact_info, summary, description
- Contains professional info (language, role, first_commit_by_person_on)
- Contains social links (forges) and funding sites
- Contains skills/interests (tags) and documentation site link
- Accessed in templates via `site.data.person`
- Used on About page and footer contact information

**projects.yml Entry Count (as of 2026-02-24)**
- Total YAML entries: 106 (person entry moved to person.yml)
- Ruby+rubygems project entries: 101
- RubyGems.org gems owned by pboling: 114
- **Gap: 17 gems missing from projects.yml** (ast-merge, bash-merge, commonmarker-merge,
  dotenv-merge, json-merge, jsonc-merge, markdown-merge, markly-merge, prism-merge,
  psych-merge, rbs-merge, token-resolver, toml-merge, tree_haver, yaml-converter,
  yard-fence, yard-yaml)
- 4 entries in projects.yml not owned by pboling on RubyGems.org (intentional):
  awesome-sponsorships, masq, os, resque

### families.yml

**Data model:** Family metadata (name, global display order) lives exclusively in
`src/_data/families.yml`. Project entries in `projects.yml` carry only:
`theme: family`, `family_id`, and (optionally) `family_primary: true`.
Within-family member order is based on the `family_position` within `projects.yml`.

**Example families.yml entry:**
```yaml
- id: active-record
  name: ActiveRecord Plugins
  position: 2
```

**Example projects.yml entry for a family member:**
```yaml
- name: activerecord-tablefree
  description: "..."
  language: Ruby
  ecosystem: rubygems
  theme: family
  family_id: active-record
  family_position: 3
  family_primary: false  # Optional: marks the primary project in the family
  # ...other fields...
```

**Usage in templates:**
- `site.data.families` - Array of family objects, sorted by position
- `project['family_id']` - References a family's id
- `project['family_position']` - Display order within the family
- Projects are grouped and displayed by family on the projects page
