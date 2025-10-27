---
layout: page
title: Personal Blog
---

<ul>
  <% collections.blog.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>
    </li>
  <% end %>
</ul>
