include:
  - .deps
  - .source

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_configure:
  cmd.run:
    - name: ./configure
    - unless: test -f rel/couchdb.config
    - cwd: {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}
    - require:
      - pkg: couchdb_install_deps
      - archive: couchdb_extract_source
