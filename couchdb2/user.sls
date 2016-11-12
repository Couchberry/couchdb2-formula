include:
  - .install

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_user:
  user.present:
    - name: {{ couchdb.user }}
    - fullname: CouchDB Administrator
    - createhome: False
    - home: /usr/local/lib/couchdb
    - shell: /bin/bash
    - system: True
    - require:
      - cmd: couchdb_install


{% set dirs = [
    '/usr/local/lib/couchdb'
  ]
%}

{% for dir in dirs %}
{{ dir }}:
  file.directory:
    - user: {{ couchdb.user }}
    - group: {{ couchdb.user }}
    - mode: 770
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: couchdb_user
{% endfor %}


{% set config_dirs = [
    '/usr/local/lib/couchdb/etc'
  ]
%}

{% for dir in config_dirs %}
{{ dir }}:
  file.directory:
    - mode: 644
    - user: {{ couchdb.user }}
    - group: {{ couchdb.user }}
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: couchdb_user
{% endfor %}
