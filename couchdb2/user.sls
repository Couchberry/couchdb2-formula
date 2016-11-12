{% from "couchdb2/map.jinja" import couchdb with context %}

couchdb_user:
  user.present:
    - name: {{ couchdb.user }}
    - fullname: CouchDB Administrator
    - createhome: False
    - home: /usr/local/lib/couchdb
    - shell: /usr/sbin/nologin
    - system: True
