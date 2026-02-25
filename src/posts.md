---
layout: page
title: Tech Posts
---

<%
  # Aggregate all posts from 'posts' collection and all project collections
  # Exclude 'blog' (personal) and standard Bridgetown collections like 'pages' or 'data' if they appear
  tech_posts = []
  collections.each do |label, collection|
    next if label == "blog" || label == "pages" || label == "data"
    tech_posts.concat(collection.resources)
  end
  # Sort by date descending
  tech_posts = tech_posts.sort_by(&:date).reverse
%>

<div class="posts-list">
  <% tech_posts.each do |post| %>
    <article class="post-item">
      <h2><a href="<%= post.relative_url %>"><%= post.data.title %></a></h2>
      <div class="post-meta">
        <time datetime="<%= post.date.strftime('%Y-%m-%d') %>">
          <%= post.date.strftime('%B %d, %Y') %>
        </time>
        <% if post.collection.label != 'posts' %>
          <span class="post-collection">
            in <a href="/<%= post.collection.label.tr('_', '-') %>"><%= post.collection.label.tr('_', ' ').split.map(&:capitalize).join(' ') %></a>
          </span>
        <% end %>
      </div>
      <% if post.data.excerpt %>
        <p><%= post.data.excerpt %></p>
      <% end %>
    </article>
  <% end %>
</div>

<style>
  .post-item {
    margin-bottom: 2rem;
  }
  .post-meta {
    font-size: 0.9rem;
    color: #666;
    margin-bottom: 0.5rem;
  }
  .post-collection {
    margin-left: 0.5rem;
  }
</style>
