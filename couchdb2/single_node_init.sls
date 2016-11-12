
couchdb_install_curl:
  pkg.installed:
    - name: curl

{% for db in ('_users', '_replicator', '_global_changes') %}
couchdb_db_init_create{{db}}:
  cmd.run:
    - name: curl -X PUT http://127.0.0.1:5984/{{ db }}
    - unless: curl -X GET http://127.0.0.1:5984/{{ db }} --fail
    - require:
      - pkg: curl
{% endfor %}
