---
# Feel free to add content and custom Front Matter to this file.

layout: default
---

Welcome to my corner of the internet! This is the main index page of my website.
Here, you'll find a collection of my projects, blog posts, and other content that I have created.

My open source projects live on the [Projects](./projects) page, ranked by lifetime downloads and
filterable by role, ownership, language version, year and tag. Each card opens that project's posts
(an introduction, release notes and tips), with the post count and the date of the latest one on the card.
StructuredMerge and RuboCop-LTS each share one blog for the whole family. RSS feeds are available for every
project. For the full catalogue, with forges and licenses, see <a href="https://galtzo.com">galtzo.com</a>.

I am a core maintainer of projects within the following OSS organizations:

<ul>
<% orgs = org_project_counts %>
<% orgs[:multi].each do |o| %>
  <li><a href="https://github.com/<%= o[:owner] %>"><%= o[:owner] %></a> (<%= o[:count] %> projects)</li>
<% end %>
</ul>

<% if orgs[:single_projects].positive? %>
<p>...plus <%= orgs[:single_projects] %> more projects, each under its own organization or account.</p>
<% end %>

*Counts come from the same project data as the [Projects](./projects) page (mine and maintained, not archived or up for adoption), one project per repository, and update automatically.*

My latest technical, or project-specific, posts can be found on the [Tech Posts](./posts).
My latest general audience, or at least non-tech-specific, personal (and obviously public), blog posts can be found on the [Personal Blog](./blog).

----

**Follow me on [GitHub](https://github.com/pboling)**
{:style="text-align:center"}
