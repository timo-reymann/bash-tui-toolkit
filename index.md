---
title: bash-tui-toolkit
---
{% assign static_files = site.static_files | sort: 'path' | reverse  %}
{% assign unique_versions = '' | split: ',' %} 

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
    {% assign parts = v  | split: "." %}
    {% assign paddedMajor = parts[0] | remove: '["' | plus: 0 | prepend: "0000" | slice: -4, 4 %}
    {% assign paddedMinor = parts[1] | plus: 0 | prepend: "0000" | slice: -4, 4 %}
    {% assign paddedPatch = parts[2] | remove: '"]' | plus: 0 | prepend: "0000" | slice: -4, 4 %}
    {% assign padded = paddedMajor | append: "." | append: paddedMinor | append: "." | append: paddedPatch %}

    {% if padded != '0000.0000.0000' %}
      {% assign padded_versions = padded_versions | push: padded %}
    {% endif %}
{% endfor %}

{% assign sorted_versions = padded_versions | sort | reverse  %}

Toolkit to create simple Terminal UIs using plain bash builtins

<h1>Available Versions</h1>
<ul>
<li>
    <a class="index-link" href="{{ site.baseurl }}/latest/docs">latest</a>
  </li>
{% for version in sorted_versions %}
   {% assign version_parts = version | split: "." %}
   {% assign major = version_parts[0] | remove: '["' | plus: 0  %}
   {% assign minor = version_parts[1] | plus: 0  %}
   {% assign patch = version_parts[2] | remove: '"]' | plus: 0  %}
   {% assign version_str = major | append: "." | append: minor | append: "." | append: patch %}
  <li>
    <a class="index-link" href="{{ site.baseurl }}/{{ version_str }}/docs">{{ version_str }}</a>
  </li>
{% endfor %}
</ul>
