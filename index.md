---
title: Index
---
{% assign static_files = site.static_files | sort: 'path'  %}

{% assign unique_versions = '' | split: ',' %} <!-- Initialize an empty array -->
{% for file in static_files %}
{% assign folder = file.path | split: '/' | slice: 1  %}
{% unless folder contains 'CNAME' %}
{% unless unique_versions contains folder %}
{% assign unique_versions = unique_versions | push: folder %}
{% endunless %}

{% endunless %}
{% endfor %}

<h2>Versions</h2>
<ul>
  {% for version in unique_versions %}
    {% if version %}
        <li><a class="index-link" href="{{ site.baseurl }}/{{version}}/docs">{{ version }}</a></li>
    {% endif %}
  {% endfor %}
</ul>