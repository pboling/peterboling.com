# Person Data Field Reference

This document provides a complete field-by-field reference for the consolidated person.yml data structure.

## Complete Field List

### Identity Fields
```yaml
full_name: "Peter Boling, team leader, web architect, security researcher, and rubyist. Building for web since 2004. 🧐"
  # Long form name with professional title/description
  # Type: String
  # Usage: Page titles, full bios

name: "Peter Boling"
  # Standard display name
  # Type: String
  # Usage: Templates, headers, general display

nickname: "Peter"
  # Short familiar name
  # Type: String
  # Usage: Casual contexts, greetings
```

### Personalization Fields
```yaml
greeting: "Hi, I am"
  # Greeting prefix (typically followed by name)
  # Type: String
  # Example usage: "Hi, I am Peter"
  # Usage: Welcome messages, about sections

image: "images/avatar.png"
  # Path to profile image
  # Type: String (relative path)
  # Size recommendation: Square image (e.g., 200x200px)
  # Usage: Avatar display, profile pictures
```

### Contact Information
```yaml
contact_info:
  email:
    handle: "peter.boling"
      # Email username/local part
      # Type: String
      # Usage: Building email display, contact forms
      
    domain: "gmail.com"
      # Email domain
      # Type: String
      # Usage: Building email display, contact forms
      
    full: "peter.boling@gmail.com"
      # Complete email address
      # Type: String
      # Usage: mailto: links, direct contact
      
  phone: "+1-925-252-5351"
    # Phone number with country code
    # Type: String (E.164 format recommended)
    # Usage: tel: links, contact information
```

### Biography
```yaml
summary:
  - I am a computer programmer
  - I build web applications
  - I am a father, son, husband, brother
  - I work on free and open-source projects
  - I tenaciously study reality
  - I am a humanist
  - I took this picture of jellyfish
  # Array of personal summary points
  # Type: Array[String]
  # Usage: "About me" lists, personal statements
  # Rendered as bulleted list or similar
```

### Description
```yaml
description: |
  <span class="intro">
  Hi! I love to solve problems with code.
  Maintaining these projects, with a focus on improving developer experience,
  requires a great deal of time and energy.
  I would appreciate your <a href="https://github.com/sponsors/pboling" class="text-link" target="_blank" rel="noopener">financial support</a>.
  Use the switches to filter projects by role, year, tags, and minimum language versions.
  Join the <a href="https://discord.gg/3qme4XHNKN" target="_blank" rel="noopener" class="text-link">Discord</a>
  if you need support, or would like to chat, about any of these projects.
  If you need an expert, <a href="https://docs.google.com/document/d/1H9fYtkMFmnkQO1sucrFPt5E3dvhozgVtI31LgpNLmJ4/pub" target="_blank" rel="noopener" class="text-link">hire me</a>.
  </span>
  # Long-form HTML/markdown description
  # Type: String (may contain HTML)
  # Usage: Projects page, about section
  # Use `<%== %>` in templates to render HTML
```

### Professional Information
```yaml
language: Ruby
  # Primary programming language
  # Type: String
  # Usage: Skill display, filtering, categorization

role: author
  # Professional role
  # Type: String
  # Values: author, maintainer, contributor, etc.
  # Usage: Role display, permissions, categorization

aspect: wide
  # Display aspect/layout preference
  # Type: String
  # Values: wide, narrow, etc.
  # Usage: Template layout selection

ecosystem: ""
  # Ecosystem classification (often empty for person entries)
  # Type: String
  # Usage: Categorization

minimum_version: '1.8'
  # Minimum supported version
  # Type: String (semantic version)
  # Usage: Compatibility information

first_commit_by_person_on: 2004/01/01
  # Date of first contribution
  # Type: String (YYYY/MM/DD format)
  # Usage: Timeline, history display

first_commit_by_person: https://github.com/galtzo-floss/galtzo.com/commit/23b15c81cfe20eb53117efbcba8d76d7c2959290
  # Link to first commit
  # Type: String (URL)
  # Usage: Historical reference, verification
```

### Social & Hosting Links
```yaml
forges:
  - type: GitHub
    url: https://github.com/pboling
    owner: pboling
      # Type: String (unique identifier on platform)
      
  - type: GitLab
    url: https://gitlab.com/pboling
    
  - type: Codeberg
    url: https://codeberg.org/pboling
    
  - type: SourceHut
    url: https://sr.ht/~galtzo/
    
# Array of code hosting/social platform links
# Type: Array[Object]
# Required fields per entry: type, url
# Optional fields: owner
# Usage: Social links, repository discovery
# Each entry is rendered as a link button
```

### Funding & Support
```yaml
funding_sites:
  - type: OpenCollective
    url: https://opencollective.com/appraisal-rb
    
  - type: OpenCollective
    url: https://opencollective.com/dynamoid
    
  - type: OpenCollective
    url: https://opencollective.com/kettle-rb
    
  - type: Liberapay
    url: https://liberapay.com/pboling
    
# Array of funding platform links
# Type: Array[Object]
# Required fields per entry: type, url
# Usage: Support/sponsorship discovery
# Can have multiple entries for different projects
```

### Skills & Interests
```yaml
tags:
  - api
  - bash
  - bridgetown
  - ci/cd
  - css
  - docker
  - go
  - graphql
  - hanami
  - html
  - javascript
  - jquery
  - k8s
  - markdown
  - minitest
  - mysql
  - oauth
  - openid
  - postgres
  - rails
  - react
  - resque
  - roda
  - sidekiq
  - sinatra
  - sqlite3
  - svelte
  - test
  - typescript
  - websockets
  
# Array of technology tags/skills
# Type: Array[String]
# Format: lowercase, hyphenated
# Usage: Skill display, filtering, categorization
```

### Documentation
```yaml
docs_site: https://galtzo.com
  # Primary documentation/portfolio site
  # Type: String (URL)
  # Usage: External link, portfolio reference
```

## Template Access Examples

### Basic Access
```erb
<%= site.data.person['name'] %>
<!-- Output: Peter Boling -->

<%= site.data.person['greeting'] %> <%= site.data.person['name'] %>
<!-- Output: Hi, I am Peter Boling -->
```

### Contact Information
```erb
<% person = site.data.person %>
<p>Email: <a href="mailto:<%= person['contact_info']['email']['full'] %>">
  <%= person['contact_info']['email']['full'] %>
</a></p>
<!-- Output: Email: <a href="mailto:peter.boling@gmail.com">peter.boling@gmail.com</a> -->

<p>Phone: <a href="tel:<%= person['contact_info']['phone'] %>">
  <%= person['contact_info']['phone'] %>
</a></p>
<!-- Output: Phone: <a href="tel:+1-925-252-5351">+1-925-252-5351</a> -->
```

### Summary List
```erb
<ul>
<% site.data.person['summary'].each do |item| %>
  <li><%= item %></li>
<% end %>
</ul>
<!-- Output: 
<ul>
  <li>I am a computer programmer</li>
  <li>I build web applications</li>
  ...
</ul>
-->
```

### Social Links
```erb
<% site.data.person['forges'].each do |forge| %>
  <a href="<%= forge['url'] %>" title="<%= forge['type'] %>">
    <%= forge['type'] %>
  </a>
<% end %>
<!-- Output: <a href="...">GitHub</a> <a href="...">GitLab</a> ... -->
```

### Long Description (with HTML)
```erb
<div class="bio">
  <%== site.data.person['description'] %>
</div>
<!-- Note: Use <%== %> to render HTML content -->
```

### Safe Access with Defaults
```erb
<% person = site.data.person %>
<p><%= person.dig('name') || 'Unknown' %></p>
<p><%= person.dig('contact_info', 'phone') || 'N/A' %></p>
<% (person['tags'] || []).each do |tag| %>
  <span><%= tag %></span>
<% end %>
```

## Ruby Access Examples

### Basic Access
```ruby
person = site.data.person
person['name']                              # => "Peter Boling"
person['contact_info']['email']['full']     # => "peter.boling@gmail.com"
person['forges'].first['url']               # => "https://github.com/pboling"
```

### Iteration
```ruby
person['summary'].each do |item|
  puts "- #{item}"
end

person['forges'].each do |forge|
  puts "#{forge['type']}: #{forge['url']}"
end

person['tags'].each do |tag|
  puts tag
end
```

### Safe Access
```ruby
person.dig('contact_info', 'phone')         # Safe nested access
(person['forges'] || []).map { |f| f['url'] }  # Safe iteration
```

## Data Validation

### Field Requirements
- **Required**: name, description, forges, funding_sites, tags
- **Recommended**: full_name, greeting, image, summary, contact_info, role, docs_site
- **Optional**: aspect, ecosystem, minimum_version

### Type Validation
- All top-level values should be properly typed
- Array fields should contain consistent types
- Nested objects should maintain structure
- URLs should be valid and absolute

### Format Validation
- **Dates**: YYYY/MM/DD format
- **Phone**: E.164 format (+country-areacode-number)
- **URLs**: Complete HTTP(S) URLs
- **Lowercase tags**: use hyphens for multi-word tags

## Backward Compatibility Notes

Fields that were in the original person.yml (project entry):
- `full_name` (from `name`)
- `description`
- `language`
- `role`
- `forges`
- `funding_sites`
- `tags`
- `docs_site`

Fields migrated from author.yaml:
- `name`
- `nickname`
- `greeting`
- `image`
- `contact_info` (from `contactInfo`)
- `summary`

All historical data is preserved and accessible via `site.data.person`.

---

**Last Updated**: February 24, 2026  
**Version**: 1.0 (Consolidated Structure)
