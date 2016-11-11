include:
  - .configure

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_rm_man:
  # Hack to fix failing `make release`
  cmd.run:
    - name:  rm -rf /usr/lib/erlang/man/*

couchdb_make:
  cmd.run:
    - name: make && make release
    - unless: test -f /usr/local/lib/couchdb/bin/couchdb
    - cwd: {{couchdb.tmp_dir}}/apache-couchdb-{{couchdb.version}}
    - require:
      - cmd: couchdb_rm_man
      - cmd: couchdb_configure

couchdb_install:
  cmd.run:
    - name: cp -r rel/couchdb /usr/local/lib
    - unless: test -f /usr/local/lib/couchdb/bin/couchdb
    - cwd: {{couchdb.tmp_dir}}/apache-couchdb-{{couchdb.version}}
    - require:
      - cmd: couchdb_make
