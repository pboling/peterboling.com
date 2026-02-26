# Developer Guide: Working with Projects, Families, and Person Data

This guide explains how to work with the project, family, and person data structures in your code and templates.

## Quick Reference

### Data Locations
- Projects: `src/_data/projects.yml`
- Families: `src/_data/families.yml`
- Orgs: `src/_data/orgs.yml`
- Person/Author: `src/_data/person.yml` (consolidated from person.yml + author.yaml)
- Main projects page: `src/projects.erb`
- Tech posts index (paginated): `src/posts.erb`
- About page: `src/about.erb`
- Project card partial: `src/_partials/_project_card.erb`
- Tag badge partial: `src/_partials/_tag_badge.erb`
- Logos partial: `src/_partials/_logos.erb` (dynamic from orgs.yml)
- Tag badge helpers: `plugins/helpers/tag_badge_helpers.rb`
- Pagination defaults builder: `plugins/builders/pagination_defaults_builder.rb`
- Language SVGs: `src/images/languages/`
- Forge SVGs: `src/images/forges/`

### Access in Templates
```erb
<!-- All projects -->
<% site.data.projects %>

<!-- All families -->
<% site.data.families %>

<!-- Person/author data -->
<% site.data.person %>
<% site.data.person['name'] %>
<% site.data.person['contact_info']['email']['full'] %>
<% site.data.person['forges'] %>

<!-- A specific project's family reference -->
<% project['family_id'] %>
<% project['family_position'] %>

<!-- Find a family by id -->
<% family = site.data.families.find { |f| f['id'] == project['family_id'] } %>
```

## Working with Person Data

### Access Author Information

```erb
<!-- Display author greeting -->
<%= site.data.person['greeting'] %>
<%= site.data.person['name'] %>

<!-- Get contact information -->
<% person = site.data.person %>
<p>Email: <%= person['contact_info']['email']['full'] %></p>
<p>Phone: <%= person['contact_info']['phone'] %></p>

<!-- Display summary -->
<% person['summary'].each do |item| %>
  <li><%= item %></li>
<% end %>

<!-- Show social links (forges) -->
<% person['forges'].each do |forge| %>
  <a href="<%= forge['url'] %>"><%= forge['type'] %></a>
<% end %>

<!-- Show funding options -->
<% person['funding_sites'].each do |site| %>
  <a href="<%= site['url'] %>"><%= site['type'] %></a>
<% end %>
```

### Render Person Description
```erb
<div class="person-bio">
  <%== site.data.person['description'] %>
</div>
```

## Common Tasks

### 1. Display All Projects by Family

```erb
<%
  # Group projects by family
  family_projects = site.data.projects.select { |p| p['theme'] == 'family' }
  projects_by_family = family_projects.group_by { |p| p['family_id'] }
  families = site.data.families.sort_by { |f| f['position'] }
%>

<% families.each do |family| %>
  <% family_id = family['id'] %>
  <% projects = projects_by_family[family_id] %>
  <% next unless projects %>
  
  <h2><%= family['name'] %></h2>
  <% projects.sort_by { |p| p['family_position'] || 999 }.each do |project| %>
    <p><%= project['name'] %></p>
  <% end %>
<% end %>
```

### 2. List Projects in a Specific Family

```erb
<%
  activerecord_projects = site.data.projects.select do |p|
    p['family_id'] == 'active-record'
  end.sort_by { |p| p['family_position'] || 999 }
%>

<h2>ActiveRecord Plugins</h2>
<% activerecord_projects.each do |project| %>
  <p><%= project['name'] %></p>
<% end %>
```

### 3. Find the Primary Project in a Family

```erb
<% ar_family = site.data.families.find { |f| f['id'] == 'active-record' } %>
<% primary = site.data.projects.find do |p|
  p['family_id'] == ar_family['id'] && p['family_primary'] == true
end %>

Primary project: <%= primary['name'] %>
```

### 4. Count Projects per Family

```erb
<%
  family_counts = site.data.families.each_with_object({}) do |family, counts|
    count = site.data.projects.count { |p| p['family_id'] == family['id'] }
    counts[family['id']] = count
  end
%>

<% family_counts.each do |family_id, count| %>
  <p><%= family_id %>: <%= count %> projects</p>
<% end %>
```

### 5. Get All Non-Family Projects

```erb
<%
  non_family = site.data.projects.reject do |p|
    p['theme'] == 'family' || p['archive'] || p['type'] == 'person'
  end
%>

<% non_family.each do |project| %>
  <p><%= project['name'] %></p>
<% end %>
```

### 6. Sort Families by Position

```erb
<%
  sorted_families = site.data.families.sort_by do |f|
    f['position'] || 999
  end
%>

<% sorted_families.each do |family| %>
  <p><%= family['position'] %>: <%= family['name'] %></p>
<% end %>
```

## Schema Reference

### Family Object

```ruby
{
  'id' => 'family-id',           # String: unique identifier
  'name' => 'Display Name',      # String: shown in UI
  'position' => 1                # Integer: sort order
}
```

### Project Object (Family-Related Fields)

```ruby
{
  'name' => 'project-name',
  'theme' => 'family',           # String: "family" or other theme
  'family_id' => 'active-record', # String: references family['id']
  'family_position' => 1,        # Integer: sort within family
  'family_primary' => true,      # Boolean: marks primary project (optional)
  # ... other project fields ...
}
```

### Project Object (Complete Reference)

```ruby
{
  'name' => 'activerecord-tablefree',
  'description' => '...',
  'language' => 'Ruby',
  'ecosystem' => 'rubygems',
  'theme' => 'family',
  'family_id' => 'active-record',
  'family_position' => 3,
  'family_primary' => false,
  'minimum_version' => '2.2',
  'role' => 'author',
  'first_commit_on' => '2017/11/08',
  'first_commit' => 'https://...',
  'funding_sites' => [
    { 'type' => 'OpenCollective', 'url' => 'https://...' },
    { 'type' => 'Liberapay', 'url' => 'https://...' }
  ],
  'forges' => [
    { 'type' => 'GitHub', 'url' => 'https://...', 'owner' => 'user' },
    { 'type' => 'GitLab', 'url' => 'https://...' }
  ],
  'tags' => ['rails', 'activerecord', 'database'],
  'docs_site' => 'https://...',
  'github_stars' => 85,
  'gitlab_stars' => 5,
  'codeberg_stars' => 1,
  'total_downloads' => 250000,
  'daily_downloads' => 100,
  'release_downloads' => 25000,
  'release_date' => '2024/07/05',
  'last_commit_on' => '2026/01/22',
  'status' => 'active',
  'last_scrape_at' => '2026-02-23T04:34:59Z',
  'archive' => false,
  'archived' => false,
  'adoptable' => false
}
```

## Rendering a Project Card

The reusable partial `_project_card.erb` handles rendering:

```erb
<%= render "project_card", project: project %>
```

The partial automatically:
- Renders project name, description, and tag badges
- Derives the full tag set from family_id, org owner, project name, and explicit tags
- Displays forge links with star counts
- Links to project blog
- Handles optional fields gracefully

## Working with Tag Badges

### Render a Single Badge

```erb
<%= render "tag_badge", tag: "ruby" %>
```

### Get Full Derived Tags for a Project

```erb
<% all_tags = project_full_tags(project) %>
<% all_tags.each do |tag| %>
  <%= render "tag_badge", tag: tag %>
<% end %>
```

### Get Badge Info for a Tag

```erb
<% info = tag_badge_info("kettle-rb") %>
<!-- info[:type] => "org", info[:logo_url] => "https://...", info[:label] => "kettle-rb" -->
```

### Badge Types and CSS Classes

| Type | CSS Class | When Applied |
|------|-----------|-------------|
| org | `.tag-badge--org` | Tag matches an org id in orgs.yml |
| family | `.tag-badge--family` | Tag matches a family id in families.yml |
| project | `.tag-badge--project` | Tag matches a project name in projects.yml |
| language | `.tag-badge--language` | Tag matches a language SVG filename |
| generic | `.tag-badge--generic` | No specific match found |

## Filtering Patterns

### Filter by Status
```erb
<% active_projects = site.data.projects.select { |p| p['status'] == 'active' } %>
```

### Filter by Language
```erb
<% ruby_projects = site.data.projects.select { |p| p['language'] == 'Ruby' } %>
```

### Filter by Tag
```erb
<% rails_projects = site.data.projects.select { |p| p['tags']&.include?('rails') } %>
```

### Filter by Ecosystem
```erb
<% rubygems = site.data.projects.select { |p| p['ecosystem'] == 'rubygems' } %>
```

### Exclude Archived
```erb
<% active = site.data.projects.reject { |p| p['archive'] || p['archived'] } %>
```


## Sorting Patterns

### By Stars (Descending)
```erb
<% sorted = site.data.projects.sort_by { |p| p['github_stars'] || 0 }.reverse %>
```

### By Date (Most Recent First)
```erb
<% sorted = site.data.projects.sort_by { |p| p['last_commit_on'] || '' }.reverse %>
```

### By Family Position (Within Family)
```erb
<% sorted = site.data.projects
  .select { |p| p['family_id'] == 'active-record' }
  .sort_by { |p| p['family_position'] || 999 } %>
```

### By Family Name Then Position
```erb
<%
  sorted = site.data.projects
    .select { |p| p['theme'] == 'family' }
    .sort_by do |p|
      family = site.data.families.find { |f| f['id'] == p['family_id'] }
      [family['position'] || 999, p['family_position'] || 999]
    end
%>
```

## Working with Forges

### Access Forge URLs
```erb
<% project['forges'].each do |forge| %>
  <%= forge['type'] %>: <%= forge['url'] %>
<% end %>
```

### Get Star Count for Forge
```erb
<%
  star_key = case forge['type'].downcase
             when 'github' then 'github_stars'
             when 'gitlab' then 'gitlab_stars'
             when 'codeberg' then 'codeberg_stars'
             else nil
             end
  star_count = star_key ? project[star_key] : nil
%>

<% if star_count %>
  ⭐ <%= star_count %>
<% end %>
```

### List Primary Forge
```erb
<% primary_forge = project['forges'].first %>
<a href="<%= primary_forge['url'] %>"><%= primary_forge['type'] %></a>
```

## Performance Tips

1. **Cache grouped data** if accessing frequently:
   ```erb
   <% @projects_by_family ||= site.data.projects
     .select { |p| p['theme'] == 'family' }
     .group_by { |p| p['family_id'] } %>
   ```

2. **Use early exit** to avoid processing unnecessary items:
   ```erb
   <% site.data.projects.find { |p| p['name'] == 'specific-project' } %>
   ```

3. **Select before looping** to reduce iterations:
   ```erb
   <% active = site.data.projects.select { |p| p['status'] == 'active' } %>
   <% active.each { ... } %>
   ```

## Paginated Tech Posts Index

The tech posts index at `/posts/` uses `bridgetown-paginate` to paginate all tech
posts across every project collection. Personal blog posts and non-content
collections are excluded automatically.

### How It Works

1. **`src/posts.erb`** — The pagination template. Front matter drives the paginator:
   ```yaml
   pagination:
     enabled: true
     collection: all    # Aggregates all collections
     per_page: 25
     sort_field: date
     sort_reverse: true
     trail:
       before: 3
       after: 3
   ```

2. **`plugins/builders/pagination_defaults_builder.rb`** — Marks `pages`, `blog`, and
   `data` collections as `exclude_from_pagination: true` so they are excluded from
   the `all` aggregation.

3. The `paginator` object is available in the ERB template with these key methods:
   - `paginator.documents` / `paginator.each` — posts for the current page
   - `paginator.page` — current page number
   - `paginator.total_pages` — total number of pages
   - `paginator.total_documents` — total number of posts
   - `paginator.previous_page_path` / `paginator.next_page_path` — navigation links
   - `paginator.page_trail` — array of `PageTrail` objects for page number navigation

### Excluding Additional Collections

To exclude a new collection from the paginated tech posts index, add its label to
`EXCLUDED_COLLECTIONS` in `plugins/builders/pagination_defaults_builder.rb`:

```ruby
EXCLUDED_COLLECTIONS = %w[pages blog data my_new_collection].freeze
```

## Common Errors and Fixes

### Error: No method 'any?' for nil
**Cause:** `projects_by_family[family_id]` returned nil
**Fix:** Use `&.` safe navigation or check explicitly
```erb
<% projects = projects_by_family[family_id] %>
<% next unless projects %>
```

### Error: "Could not find file '_project_card.erb'"
**Cause:** Partial file not in correct location
**Fix:** Ensure `src/_partials/_project_card.erb` exists
```bash
# Check file exists
ls -la src/_partials/_project_card.erb
```

### Error: `project['tags']` returns nil in loop
**Cause:** Not all projects have tags
**Fix:** Use safe navigation or default value
```erb
<% (project['tags'] || []).each { |tag| ... } %>
```

### Error: Family not found
**Cause:** `family_id` doesn't match any family in `families.yml`
**Fix:** Verify the id exists and matches exactly (case-sensitive)
```erb
<% family = site.data.families.find { |f| f['id'] == project['family_id'] } %>
<% if family %>
  Found: <%= family['name'] %>
<% else %>
  Missing family for: <%= project['family_id'] %>
<% end %>
```

## Testing Your Code

### Print Debug Info
```erb
<!-- Debug: Show all families -->
<% site.data.families.each { |f| %>
  <%= "#{f['id']}: #{f['name']} (pos #{f['position']})" %>
<% } %>

<!-- Debug: Show projects in a family -->
<% projects = site.data.projects.select { |p| p['family_id'] == 'active-record' } %>
<p>Found <%= projects.length %> projects in active-record family</p>
```

### Validate Data
```ruby
# In a Ruby script or initializer
families = YAML.safe_load(File.read('src/_data/families.yml'))
projects = YAML.safe_load(File.read('src/_data/projects.yml'))

# Check all family references are valid
projects.select { |p| p['theme'] == 'family' }.each do |project|
  family = families.find { |f| f['id'] == project['family_id'] }
  puts "Missing family: #{project['family_id']}" unless family
end
```

## Additional Resources

- [DATA_MODEL.md](DATA_MODEL.md) - Complete schema documentation
- [UPDATES_SUMMARY.md](UPDATES_SUMMARY.md) - Summary of recent changes
- [README.md](README.md) - Project overview and setup
- [Bridgetown Docs](https://www.bridgetownrb.com/docs/)
