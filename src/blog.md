---
layout: page
title: Personal Blog
feed_url: /feed/blog.xml
---

<ul>
  <% collections.blog.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>
    </li>
  <% end %>
</ul>
