# peterboling.com

My personal website & blog built with Bridgetown

## Overview

This is a technical coding blog and project showcase built using the Bridgetown static site generator. The site features:

- **Blog Posts**: Technical articles about Ruby, JavaScript, Python, DevOps, and more
- **Projects Page**: Showcase of open source projects with multi-forge support
- **Project-Specific Mini-Blogs**: Each project has its own dedicated blog

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
- **Tags**: Categorize projects by technology
- **Links to Project Blogs**: Each project card links to its dedicated mini-blog

Configuration is managed via YAML in `src/_data/projects.yml`.

### 3. Project-Specific Mini-Blogs

Each project has its own mini-blog accessible at `/<project-name>/`:

- `/oauth-five-nine/` - OAuth library blog
- `/sanitize_email/` - Email sanitization blog
- `/rspec-pending_for/` - RSpec utilities blog
- `/kettle-soup-cover/` - Code coverage blog
- `/flag_shih_tzu/` - Bit fields blog

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
├── src/
│   ├── _posts/              # Blog posts (main blog)
│   ├── _oauth_five_nine/    # OAuth Five Nine project blog posts
│   ├── _sanitize_email/     # Sanitize Email project blog posts
│   ├── _rspec_pending_for/  # RSpec Pending For project blog posts
│   ├── _kettle_soup_cover/  # Kettle Soup Cover project blog posts
│   ├── _flag_shih_tzu/      # Flag Shih Tzu project blog posts
│   ├── _data/
│   │   ├── projects.yml     # Project configuration
│   │   └── site_metadata.yml # Site metadata
│   ├── _layouts/            # Page layouts
│   ├── _components/         # Reusable components
│   ├── _partials/           # Partial templates
│   ├── projects.erb         # Projects page
│   └── *.erb                # Project blog index pages
├── config/
│   └── initializers.rb      # Bridgetown configuration
├── frontend/                # Frontend assets (JS, CSS)
└── output/                  # Generated site (gitignored)
```

## Adding Content

### Adding a Blog Post

Create a new file in `src/_posts/` with the format `YYYY-MM-DD-title.md`:

```markdown
---
layout: post
title: "Your Post Title"
date: 2024-10-09 10:00:00 +0000
categories: ruby
---

Your content here...
```

### Adding a Project

Edit `src/_data/projects.yml`:

```yaml
projects:
  - name: "project-name"
    description: "Project description"
    forges:
      - type: "github"
        url: "https://github.com/user/repo"
        stars: 100
      - type: "gitlab"
        url: "https://gitlab.com/user/repo"
        stars: 50
    tags: ["ruby", "rails"]
```

Then create:
1. Collection directory: `src/_project_name/`
2. Index page: `src/project-name.erb`
3. Update `config/initializers.rb` to add the collection

### Adding a Project Blog Post

Create a new file in the project's collection directory (e.g., `src/_oauth_five_nine/`):

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

> Read the [Bridgetown Deployment Documentation](https://www.bridgetownrb.com/docs/deployment) for more information.
