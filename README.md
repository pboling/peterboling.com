# peterboling.com

My personal website & blog built with Bridgetown

## Overview

This is a technical coding blog and project showcase built using the Bridgetown static site generator. The site features:

- **Blog Posts**: Technical and personal articles
- **Projects Page**: Showcase of open source projects with multi-forge support
- **Project-Specific Mini-Blogs**: Each project has its own dedicated blog, automatically generated
- **Automated Content**: Intro and release posts are automatically populated from GitHub

## Features

### 1. Blog Posts with Category-Based URLs

Blog posts follow the URL pattern: `/posts/<category>/<title>`

Example posts:
- `/posts/ruby/getting-started-with-ruby-on-rails/`
- `/posts/javascript/understanding-javascript-promises/`
- `/posts/python/building-restful-apis-with-python-flask/`
- `/posts/devops/devops-best-practices-for-2024/`

### 2. Projects Page

The projects page displays cards for all projects, with:
- **Multi-Forge Support**: Projects can be hosted on multiple platforms (GitHub, GitLab, Codeberg, Bitbucket)
- **Forge-Specific Accent Colors**: Each forge has a unique color (configurable in `src/_data/projects.yml`)
- **Star Counts**: Display stars/favorites for each forge
- **Tag Badges**: Pill-shaped badges with icons derived from orgs, families, languages, and project names
- **Links to Project Blogs**: Each project card links to its dedicated mini-blog

Configuration is managed via YAML in `src/_data/projects.yml`, `src/_data/families.yml`, and `src/_data/orgs.yml`.

### 3. Project-Specific Mini-Blogs

Each project has its own mini-blog accessible at `/<project-name>/`, which is dynamically generated from project data in `src/_data/projects.yml`.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Development](#development)
- [Project Structure](#project-structure)
- [Adding Content](#adding-content)
- [Commands](#commands)
- [Deployment](#deployment)

## Prerequisites

- [GCC](https://gcc.gnu.org/install/)
- [Make](https://www.gnu.org/software/make/)
- [Ruby](https://www.ruby-lang.org/en/downloads/)
  - `>= 3.1`
- [Bridgetown Gem](https://rubygems.org/gems/bridgetown)
  - `gem install bridgetown -N`
- [Node](https://nodejs.org)
  - `>= 20`

## Install

```sh
cd peterboling.com
bundle install && npm install
npm run esbuild
```
> Learn more: [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/).

## Development

To start your site in development mode, run `bin/bridgetown start` and navigate to [localhost:4000](https://localhost:4000/)!

## Project Structure

```
.
├── scripts/             # Automation scripts for project management
├── src/
│   ├── _posts/              # Tech blog posts (main blog)
│   ├── _blog/               # Personal blog posts
│   ├── _<project_name>/     # Individual project collections (e.g., _oauth2)
│   ├── _data/
│   │   ├── projects.yml     # Project configuration
│   │   ├── families.yml     # Project family definitions
│   │   ├── orgs.yml         # GitHub org logos & links (tag badges + header)
│   │   ├── person.yml       # Personal profile & organization data
│   │   └── site_metadata.yml # Site metadata
│   ├── _layouts/            # Page layouts
│   ├── _components/         # Reusable components
│   ├── _partials/           # Partial templates
│   │   ├── _project_card.erb    # Project card with tag badges
│   │   ├── _tag_badge.erb       # Tag badge pill (icon + label)
│   │   └── _logos.erb           # Dynamic header logos from orgs.yml
│   ├── images/
│   │   ├── languages/       # Language SVGs (Bash, Go, JS, Ruby, Rust, TS)
│   │   └── forges/          # Forge SVGs (Codeberg, GitHub, GitLab, SourceHut)
│   ├── projects.erb         # Projects page
│   └── <project_name>.erb   # Individual project blog root pages
├── plugins/
│   ├── helpers/
│   │   └── tag_badge_helpers.rb  # Tag badge icon resolution & tag derivation
│   └── builders/
│       └── tag_badge_builder.rb  # Registers helpers with Bridgetown
├── config/
│   └── initializers.rb      # Bridgetown configuration (includes project collections)
├── frontend/                # Frontend assets (JS, CSS)
└── output/                  # Generated site (gitignored)
```

## Adding Content

### Adding a Technical Post

Create a new file in `src/_posts/` with the format `YYYY-MM-DD-title.md`.

### Adding a Personal Post

Create a new file in `src/_blog/` with the format `YYYY-MM-DD-title.md`.

### Adding a Project

Edit `src/_data/projects.yml`:

```yaml
- name: "project-name"
  description: "Project description"
  language: Ruby
  ecosystem: rubygems
  theme: family  # Optional: set to "family" if this project belongs to a family
  family_id: active-record  # Optional: reference to a family in families.yml
  family_position: 1  # Optional: display order within the family
  forges:
    - type: GitHub
      url: "https://github.com/user/repo"
    - type: GitLab
      url: "https://gitlab.com/user/repo"
  tags:
    - ruby
    - rails
  github_stars: 100
  gitlab_stars: 50
```

#### Project Families

Projects can be organized into families using the `theme: family` attribute. Family metadata (name, global display order) is defined in `src/_data/families.yml`:

```yaml
- id: active-record
  name: ActiveRecord Plugins
  position: 2
```

Projects reference families using:
- `theme: family` - Indicates this project belongs to a family
- `family_id: <family-id>` - References a family from families.yml
- `family_position: <number>` - Display order within that family (optional)
- `family_primary: true` - Marks the primary/flagship project in the family (optional)

Then run the automation script to set up the collection, directory, and index page:

```sh
python3 scripts/generate_project_collections.py --apply
```

This will automatically:
1. Update `config/initializers.rb` to add the new collection.
2. Create the collection directory `src/_project_name/`.
3. Create the project index page `src/project_name.erb`.

### Automated Content Generation

You can automatically populate project "intro" posts and "release" posts from GitHub using the following script:

```sh
# Fetch and populate content (dry-run by default)
python3 scripts/fill_project_posts.py

# Apply changes and provide GitHub token to avoid rate limits
GITHUB_TOKEN=your_token python3 scripts/fill_project_posts.py
```

The script will:
- Find projects where you are the "author" or "maintainer".
- Populate empty "intro" posts using the project's README from GitHub.
- Create new "release" posts in `src/_<project_name>/releases/` based on GitHub release notes.

### Adding a Project Blog Post Manually

Create a new file in the project's collection directory (e.g., `src/_oauth2/`):

```markdown
---
layout: post
title: "Project-Specific Post"
date: 2024-10-09 10:00:00 +0000
---

Your content here...
```

### Commands

```sh
# running locally
bin/bridgetown start

# build frontend assets
npm run esbuild

# build for production
BRIDGETOWN_ENV=production bin/bridgetown build

# load the site up within a Ruby console (IRB)
bin/bridgetown console
```

> Learn more: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Deployment

You can deploy Bridgetown sites on hosts like Render or Vercel as well as traditional web servers by simply building and copying the output folder to your HTML root.

Recommended production build commands (ensure both frontend assets and HTML are generated):

- Using npm scripts:
  - `npm ci`
  - `npm run build:site`

- Or using Rake (default task runs frontend + build):
  - `bundle install`
  - `bundle exec rake`

This will:
- Build hashed CSS/JS to `output/_bridgetown/static` via esbuild
- Build the site with `BRIDGETOWN_ENV=production` to `output/`

> Read the [Bridgetown Deployment Documentation](https://www.bridgetownrb.com/docs/deployment) for more information.
