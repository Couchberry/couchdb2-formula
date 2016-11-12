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

couchdb_systemd_unit:
  file.managed:
    - name: /etc/systemd/system/couchdb.service
    - source: salt://couchdb2/files/couchdb.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      binary: {{ couchdb.install_dir }}/bin/couchdb
    - require:
      - cmd: couchdb_install

  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: couchdb_systemd_unit
