---
title: bash-tui-toolkit
---
{% assign static_files = site.static_files | sort: 'path' | reverse  %}

{% assign unique_versions = '' | split: ',' %} <!-- Initialize an empty array -->
{% for file in static_files %}
{% assign folder = file.path | split: '/' | slice: 1  %}
{% unless folder contains 'CNAME' %}
{% unless unique_versions contains folder %}
{% assign unique_versions = unique_versions | push: folder %}
{% endunless %}

{% endunless %}
{% endfor %}

Toolkit to create simple Terminal UIs using plain bash builtins

<h1>Available Versions</h1>
<ul>
  {% for version in unique_versions %}
    {% if version %}
        <li><a class="index-link" href="{{ site.baseurl }}/{{version}}/docs">{{ version }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
