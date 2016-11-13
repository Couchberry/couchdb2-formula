include:
  - .deps
  - .source
  - .configure
  - .user

{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_make:
  # build the Couchdb from sources
  cmd.run:
    - name: make && make release
    - unless: test -f {{ couchdb.install_dir }}/bin/couchdb
    - cwd: {{ couchdb.tmp_dir }}/apache-couchdb-{{ couchdb.version }}
    - require:
      - cmd: couchdb_configure

couchdb_install:
  # "install" the release of Couchdb after build
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
  # install systemd unit file for Couchdb, so that the service can be started
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

  # In case the unit file changed, systemd needs to reload unit files
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: couchdb_systemd_unit


# List of directories on which we need to adjust permissions
# The list is (<path>, <dir_permissions>, <file_permissions>)
{% set dirs = [
    (couchdb.install_dir, 750, 640),
    (couchdb.install_dir + '/etc/default.d', 750, 640),
    (couchdb.install_dir + '/etc/local.d', 750, 640),
    (couchdb.install_dir + '/lib', 750, 750),
    (couchdb.install_dir + '/bin', 750, 750),
    (couchdb.install_dir + '/erts-6.2', 750, 750),
] %}

{% for path, dir_perm, file_perm in dirs %}
{{ path }}:
  file.directory:
    - user: {{ couchdb.user }}
    - group: {{ couchdb.user }}
    - dir_mode: {{ dir_perm }}
    - file_mode: {{ file_perm }}
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: couchdb_user
      - cmd: couchdb_install
{% endfor %}
