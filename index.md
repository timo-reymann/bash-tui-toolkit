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

{% assign padded_versions = "" | split: "" %}
{% for v in unique_versions %}
  {% assign parts = v | split: "." %}
  {% assign padded = parts[0] | plus: 0 | prepend: "000" | slice: -3, 3 %}
  {% assign padded = padded | append: "." | append: parts[1] | plus: 0 | prepend: "000" | slice: -3, 3 %}
  {% assign padded = padded | append: "." | append: parts[2] | plus: 0 | prepend: "000" | slice: -3, 3 %}
  {% assign padded_versions = padded_versions | push: padded %}
{% endfor %}

{% assign sorted_versions = padded_versions | sort %}

Toolkit to create simple Terminal UIs using plain bash builtins

<h1>Available Versions</h1>
<ul>
  {% for version in sorted_versions %}
    {% if version %}
         {% assign parts = p | split: "." %}
        <li><a class="index-link" href="{{ site.baseurl }}/{{ parts[0] | plus: 0 }}.{{ parts[1] | plus: 0 }}.{{ parts[2] | plus: 0 }}/docs">{{ parts[0] | plus: 0 }}.{{ parts[1] | plus: 0 }}.{{ parts[2] | plus: 0 }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
