include:
  - .deps
  - .source
  - .configure

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_make:
  cmd.run:
    - name: make && make release
    - unless: test -f {{ couchdb.install_dir }}/bin/couchdb
    - cwd: {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}
    - require:
      - cmd: couchdb_configure

couchdb_install:
  cmd.run:
    - name: cp -r rel/couchdb {{ couchdb.install_dir }}
    - unless: test -f {{ couchdb.install_dir }}/bin/couchdb
    - cwd: {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}
    - require:
      - cmd: couchdb_make

couchdb_post_install:
  # Remove temporary directory after installation
  file.absent:
    - name: {{ couchdb.tmp_dir }}
    - require:
      - cmd: couchdb_install
