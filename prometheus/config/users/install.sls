# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

  {%- for name in prometheus.wanted %}

prometheus-config-user-install-{{ name }}-user-present:
  group.present:
    - name: {{ name }}
    - require_in:
      - user: prometheus-config-user-install-{{ name }}-user-present
  user.present:
    - name: {{ name }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ name }}
      {%- if grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
      {%- endif %}

  {%- endfor %}

# only exporters workaround
{%- if 'prometheus' not in pillar['prometheus']['wanted'] %}
{%- set name = 'prometheus' %}
prometheus-config-user-install-{{ name }}-user-present:
  group.present:
    - name: {{ name }}
    - require_in:
      - user: prometheus-config-user-install-{{ name }}-user-present
  user.present:
    - name: {{ name }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ name }}
      {%- if grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
      {%- endif %}
{% endif %}
