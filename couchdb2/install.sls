include:
  - .deps
  - .source
  - .configure

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_make:
  cmd.run:
    - name: make && make release
    - unless: test -f {{couchdb.install_dir}}/bin/couchdb
    - cwd: {{couchdb.tmp_dir}}/apache-couchdb-{{couchdb.version}}
    - require:
      - cmd: couchdb_configure

couchdb_install:
  cmd.run:
    - name: cp -r rel/couchdb /usr/local/lib
    - unless: test -f /usr/local/lib/couchdb/bin/couchdb
    - cwd: {{couchdb.tmp_dir}}/apache-couchdb-{{couchdb.version}}
    - require:
      - cmd: couchdb_make
