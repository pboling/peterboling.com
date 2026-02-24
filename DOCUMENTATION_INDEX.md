# Documentation Index

This is a comprehensive index of all documentation files related to the project families data model update.

## Quick Navigation

- **[README.md](README.md)** - Project overview, installation, setup guide
- **[AGENTS.md](AGENTS.md)** - Agent operating instructions with data model details
- **[DATA_MODEL.md](DATA_MODEL.md)** - Complete schema documentation
- **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** - Quick reference and common tasks

## Documentation Files

### Core Documentation

#### 1. **README.md**
The main project documentation covering:
- Project overview and features
- Installation and setup
- Project structure
- Adding content (blog posts, projects)
- Build and deployment

---

#### 2. **AGENTS.md**
AI agent operating instructions and project context:
- Terminal output handling guidelines
- Project framework (Bridgetown)
- projects.yml statistics and structure
- families.yml data model explanation

---

### Implementation & Usage

#### 3. **DATA_MODEL.md**
Complete schema and reference documentation:
- Overview of two-file system (projects.yml, families.yml)
- families.yml schema with examples
- projects.yml schema (all fields documented)
- Complete real-world examples
- Using data in templates
- Best practices for updating

---

#### 4. **DEVELOPER_GUIDE.md**
Practical guide for working with the data:
- Quick reference (locations, template access)
- Common tasks with code examples:
  - Display all projects by family
  - List projects in a family
  - Find primary project
  - Count projects per family
  - Sort families and projects
- Schema reference
- Filtering patterns (15+ examples)
- Sorting patterns (10+ examples)
- Working with forges
- Performance tips
- Common errors and fixes
- Testing your code

---

## File Relationships

```
README.md
  ├── Project overview
  ├── Setup instructions
  └── Links to other docs

AGENTS.md
  ├── Agent guidelines
  └── Data model summary

DATA_MODEL.md
  ├── Complete schema reference
  ├── Field documentation
  └── Examples

DEVELOPER_GUIDE.md
  ├── Common tasks & examples
  ├── Code patterns
  └── Error reference
```

## Key Concepts

### Data Model
- **families.yml**: Metadata about project families (id, name, position)
- **projects.yml**: Individual projects with family references (family_id, family_position)
- Projects with `theme: family` belong to a family
- Projects without family fields are displayed in "Other Projects"

### Key Fields
- `theme: family` - Marks a project as family-affiliated
- `family_id` - References a family.id from families.yml
- `family_position` - Sort order within the family
- `family_primary` - Marks the primary project in a family

### Pages & Components
- `/src/projects.erb` - Main projects page (groups by family)
- `/src/_partials/_project_card.erb` - Reusable project card component

## Files in Workspace

### Documentation Files
```
peterboling.com/
├── README.md ......................... Project overview
├── AGENTS.md ......................... Agent instructions
├── DATA_MODEL.md ..................... Schema reference (NEW)
├── DEVELOPER_GUIDE.md ................ Usage guide (NEW)
└── DOCUMENTATION_INDEX.md ............ This file (NEW)
```

### Data Files
```
├── src/_data/
│   ├── projects.yml ................. Projects with family references
│   └── families.yml ................. Family definitions
```

### Template Files
```
├── src/
│   ├── projects.erb ................. Projects page (UPDATED)
│   └── _partials/
│       └── _project_card.erb ........ Project card (NEW)
```

## Last Updated

- **Date:** February 23, 2026
- **Version:** 1.0
- **Status:** Complete

All code updated, tested, and documented.
