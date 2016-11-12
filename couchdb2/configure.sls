include:
  - .deps
  - .source

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_configure:
  cmd.run:
    - name: ./configure
    - cwd: {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}
    - unless: test -f {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}/Makefile
    - require:
      - pkg: couchdb_install_deps
      - archive: couchdb_extract_source
