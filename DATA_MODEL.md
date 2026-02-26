# Data Model Documentation

This document describes the YAML data structures used for managing projects, project families, and personal data.

## Overview

Data is organized into four related YAML files:

1. **`src/_data/projects.yml`** - Individual project entries
2. **`src/_data/families.yml`** - Project family definitions
3. **`src/_data/orgs.yml`** - GitHub org data with logos
4. **`src/_data/person.yml`** - Author/person biographical and contact information

## person.yml Schema

Consolidates author information including contact details, personal summary, and social links.

### Structure

```yaml
---
# Names
full_name: "Peter Boling, ..."      # Full name with optional title/subtitle
name: "Peter Boling"                # Display name
nickname: "Peter"                   # Short nickname

# Personalization
greeting: "Hi, I am"                # Greeting message for templates
image: "images/avatar.png"          # Profile image path

# Contact Information
contact_info:
  email:
    handle: "peter.boling"          # Email username/handle
    domain: "gmail.com"             # Email domain
    full: "peter.boling@gmail.com"  # Full email address
  phone: "+1-925-252-5351"          # Phone number

# Summary/Bio
summary:                            # Array of personal taglines/summary points
  - I am a computer programmer
  - I build web applications
  - I work on free and open-source projects

# Long-form Description
description: |                      # HTML/markdown description (projects page)
  <span class="intro">
  Hi! I love to solve problems with code...
  </span>

# Professional Info
language: Ruby                       # Primary programming language
role: author                         # Professional role
first_commit_by_person_on: 2004/01/01  # Start date

# Social/Forge Links
forges:                             # Array of social/code hosting links
  - type: GitHub
    url: "https://github.com/pboling"
    owner: pboling
  - type: GitLab
    url: "https://gitlab.com/pboling"

# Support/Funding Links
funding_sites:                      # Array of funding platform links
  - type: OpenCollective
    url: "https://opencollective.com/galtzo-floss"
  - type: Liberapay
    url: "https://liberapay.com/pboling"

# Skills/Interests
tags:                               # Array of technology/skill tags
  - ruby
  - rails
  - javascript
  - open-source
  
docs_site: "https://galtzo.com"    # Primary documentation site
```

### Example

```yaml
---
full_name: "Peter Boling, team leader, web architect, security researcher, and rubyist. Building for web since 2004. 🧐"
name: "Peter Boling"
nickname: "Peter"
greeting: "Hi, I am"
image: "images/avatar.png"

contact_info:
  email:
    handle: "peter.boling"
    domain: "gmail.com"
    full: "peter.boling@gmail.com"
  phone: "+1-925-252-5351"

summary:
  - I am a computer programmer
  - I build web applications
  - I am a father, son, husband, brother
  - I work on free and open-source projects

description: |
  <span class="intro">
  Hi! I love to solve problems with code...
  </span>

language: Ruby
role: author
first_commit_by_person_on: 2004/01/01

forges:
  - type: GitHub
    url: "https://github.com/pboling"
    owner: pboling
  - type: GitLab
    url: "https://gitlab.com/pboling"

funding_sites:
  - type: OpenCollective
    url: "https://opencollective.com/galtzo-floss"
  - type: Liberapay
    url: "https://liberapay.com/pboling"

tags:
  - ruby
  - rails
  - javascript
  - open-source

docs_site: "https://galtzo.com"
```

### Usage

- `person.yml` contains consolidated author/person data (previously split between `person.yml` and `author.yaml`)
- Access in templates via `site.data.person`
- Used primarily on the About page and for footer contact information


## families.yml Schema

Defines project families for grouping related projects.

### Structure

```yaml
---
- id: family-id                  # Unique identifier for the family (e.g., "active-record")
  name: "Family Display Name"    # Human-readable name shown in UI
  position: 1                    # Global sort order for families (lower numbers = appear first)
```

### Example

```yaml
---
- id: active-record
  name: ActiveRecord Plugins
  position: 2
- id: logging-family
  name: Logging Tools
  position: 3
- id: adoptable-family
  name: Looking for Maintainers!
  position: 5
```

### Usage

- Each family has a unique `id` that projects reference via `family_id`
- The `position` field controls the order families appear on the projects page
- Families are displayed in order of `position` (ascending)

## orgs.yml Schema

Defines GitHub organizations with logos and forge links, used by the tag badge system
and the dynamic logos header partial.

### Structure

```yaml
---
- id: org-id                     # Unique identifier (matches GitHub org name)
  name: "Org Name"               # Human-readable name
  position: 1                    # Sort order for header logos
  logo: "https://..."            # Logo image URL
  logo-alt: "alt text"           # Logo alt text
  logo-title: "title text"       # Logo title/tooltip text
  forge_gh: "https://..."        # GitHub org URL
  forge_gl: "https://..."        # GitLab org URL (optional)
  forge_cb: "https://..."        # Codeberg org URL (optional)
```

### Example

```yaml
---
- id: kettle-rb
  name: "kettle-rb"
  position: 2
  logo: "https://logos.galtzo.com/assets/images/kettle-rb/avatar-128px.svg"
  logo-alt: "kettle-rb Logo by Aboling0, CC BY-SA 4.0"
  logo-title: "kettle-rb Logo by Aboling0, CC BY-SA 4.0"
  forge_gh: "https://github.com/kettle-rb"
  forge_gl: "https://gitlab.com/kettle-rb"
  forge_cb: "https://codeberg.org/kettle-rb"
```

### Usage

- Org logos appear in the header via the dynamic `_logos.erb` partial
- The tag badge system matches tag strings against org `id` fields
- When a tag matches an org, the org logo is displayed in the badge pill

## Tag Badge System

Tag badges are pill-shaped elements rendered on project cards and blog posts.
Each badge shows an icon/logo on the left and the tag label on the right.

### Full Tag Derivation for Projects

The full tag set for a project is derived from these fields (in order):
1. `family_id` — the family the project belongs to
2. GH forge `owner` — the GitHub org that owns the project
3. `name` — the project's own name
4. `tags` — explicit tags from the project data

Tags are deduplicated (case-insensitive, first occurrence wins).

### Logo Resolution Hierarchy

| Tag Type | Match Condition | Logo Source |
|----------|----------------|-------------|
| **org** | Tag matches `orgs.yml` id | Org logo from orgs.yml |
| **family** | Tag matches `families.yml` id | Family logo (future) → 👪 emoji |
| **project** | Tag matches `projects.yml` name | Org logo → language SVG → 📦 emoji |
| **language** | Tag matches language SVG filename | Language SVG from `/images/languages/` |
| **generic** | No match found | 🏷️ emoji |

### Key Files

- `plugins/helpers/tag_badge_helpers.rb` — `tag_badge_info(tag)` and `project_full_tags(project)`
- `plugins/builders/tag_badge_builder.rb` — Registers helpers with Bridgetown
- `src/_partials/_tag_badge.erb` — Renders a single badge pill
- `src/_partials/_logos.erb` — Dynamic header logos from orgs.yml
- `src/images/languages/` — Language SVGs (Bash, Go, JavaScript, Ruby, Rust, TypeScript)
- `src/images/forges/` — Forge SVGs (Codeberg, GitHub, GitLab, SourceHut)
- `frontend/styles/index.css` — `.tag-badge` CSS with type-specific colour themes

## projects.yml Schema

Defines individual projects with detailed metadata.

### Core Fields

```yaml
- name: project-name                     # Project name (kebab-case, used in URLs)
  description: "Project description"     # Markdown-formatted description
  language: Ruby                         # Primary programming language
  ecosystem: rubygems                    # Package ecosystem (rubygems, npm, pip, go, etc.)
```

### Family-Related Fields

When a project belongs to a family, include:

```yaml
  theme: family                          # Set to "family" to indicate family membership
  family_id: active-record               # References a family id from families.yml
  family_position: 1                     # Sort order within the family (ascending)
  family_primary: true                   # Optional: marks this as the primary project in the family
```

### Hosting & Links

```yaml
  forges:
    - type: GitHub                       # Forge type: GitHub, GitLab, Codeberg, Bitbucket, etc.
      url: "https://github.com/user/repo"
      owner: username                    # Optional: GitHub/GitLab username
  docs_site: "https://example.com"       # Optional: official documentation URL
```

### Metadata

```yaml
  role: author                           # author, maintainer, contributor
  minimum_version: "2.7"                 # Minimum Ruby/language version required
  tags:                                  # Array of technology tags
    - rails
    - database
    - orm
```

### Funding & Support

```yaml
  funding_sites:
    - type: OpenCollective
      url: "https://opencollective.com/org"
    - type: Liberapay
      url: "https://liberapay.com/user"
```

### Statistics (usually auto-populated)

```yaml
  github_stars: 42
  gitlab_stars: 10
  codeberg_stars: 5
  total_downloads: 100000
  daily_downloads: 50
  release_downloads: 25000
  release_date: 2024/01/15
  first_commit_on: 2020/03/10
  first_commit: "https://github.com/user/repo/commit/hash"
  last_commit_on: 2024/12/01
  status: active                        # active, inactive, archived, etc.
  last_scrape_at: "2024-12-01T10:00:00Z"
```

### Flags

```yaml
  archive: false                        # If true, project is hidden from listings
  archived: true                        # If true, project is marked as archived
  adoptable: true                       # If true, project is looking for maintainers
```


## Complete Example

### families.yml

```yaml
---
- id: active-record
  name: ActiveRecord Plugins
  position: 2
- id: logging-family
  name: Logging Tools
  position: 3
```

### projects.yml (excerpt)

```yaml
---
- name: activerecord-tablefree
  description: "ActiveRecord Tablefree Models provides a simple mixin for creating models that are not bound to the database."
  language: Ruby
  ecosystem: rubygems
  theme: family
  family_id: active-record
  family_position: 3
  family_primary: false
  minimum_version: "2.2"
  role: author
  first_commit_on: 2017/11/08
  first_commit: "https://github.com/galtzo-floss/activerecord-tablefree/commit/abc123"
  funding_sites:
    - type: OpenCollective
      url: "https://opencollective.com/galtzo-floss"
    - type: Liberapay
      url: "https://liberapay.com/pboling"
  forges:
    - type: GitHub
      url: "https://github.com/galtzo-floss/activerecord-tablefree"
      owner: galtzo-floss
    - type: GitLab
      url: "https://gitlab.com/galtzo-floss/activerecord-tablefree"
  tags:
    - rails
    - activerecord
    - database
  docs_site: "https://www.rubydoc.info/gems/activerecord-tablefree"
  github_stars: 85
  total_downloads: 250000
  release_date: 2024/07/05
  last_commit_on: 2026/01/22
  status: active
  last_scrape_at: "2026-02-23T04:34:59Z"

- name: activesupport-broadcast_logger
  description: "ActiveSupport::BroadcastLogger extension for Rails logging."
  language: Ruby
  ecosystem: rubygems
  theme: family
  family_id: logging-family
  family_position: 4
  minimum_version: "2.7"
  role: author
  first_commit_on: 2024/11/20
  first_commit: "https://github.com/galtzo-floss/activesupport-broadcast_logger/commit/xyz789"
  funding_sites:
    - type: OpenCollective
      url: "https://opencollective.com/galtzo-floss"
  forges:
    - type: GitHub
      url: "https://github.com/galtzo-floss/activesupport-broadcast_logger"
      owner: galtzo-floss
  tags:
    - rails
    - activesupport
    - logging
  github_stars: 9
  total_downloads: 7950
  status: active
  last_scrape_at: "2026-02-23T04:35:23Z"
```

## Using the Data in Templates

### In Bridgetown ERB Templates

```erb
<!-- Access all projects -->
<% site.data.projects.each do |project| %>
  <%= project['name'] %>
<% end %>

<!-- Access all families -->
<% site.data.families.each do |family| %>
  <%= family['name'] %>
<% end %>

<!-- Group projects by family -->
<%
  family_projects = site.data.projects.select { |p| p['theme'] == 'family' }
  projects_by_family = family_projects.group_by { |p| p['family_id'] }
%>

<!-- Filter by family_id -->
<% active_record_projects = site.data.projects.select { |p| p['family_id'] == 'active-record' } %>

<!-- Render a tag badge for a single tag -->
<%= render "tag_badge", tag: "ruby" %>

<!-- Get the full derived tag list for a project and render badges -->
<% all_tags = project_full_tags(project) %>
<% all_tags.each do |tag| %>
  <%= render "tag_badge", tag: tag %>
<% end %>

<!-- Render a project card (includes derived tag badges automatically) -->
<%= render "project_card", project: project %>
```

## Updating Projects Data

### When Adding a New Project

1. Add entry to `src/_data/projects.yml` with required fields
2. If it belongs to a family:
   - Add `theme: family`
   - Add `family_id` referencing an existing family
   - Add `family_position` for ordering within the family

### When Creating a New Family

1. Add entry to `src/_data/families.yml` with:
   - Unique `id` (kebab-case)
   - Display `name`
   - `position` number (lower = appears first)
2. Update any existing projects to reference the new family via `family_id`

### When Adding a New Org

1. Add entry to `src/_data/orgs.yml` with:
   - `id` matching the GitHub org name
   - `name`, `position`, and `logo` URL
   - `logo-alt` and `logo-title` for accessibility
   - `forge_gh` (required for header display), `forge_gl`, `forge_cb` (optional)
2. The org logo will automatically be used by tag badges for matching tags
3. The header logos partial will automatically include the new org

### Best Practices

- Use kebab-case for project names (e.g., `active-record-plugin`)
- Use kebab-case for family ids (e.g., `active-record`)
- Use GitHub org name for org ids (e.g., `kettle-rb`)
- Keep descriptions concise but informative
- Keep `forges` array current with all active hosting locations
- Update `status`, `github_stars`, and other metrics regularly
- Maintain chronological ordering of projects within families
