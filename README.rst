
================
CouchDB2-Formula
================

Installs (from source) and setup `CouchDB 2.X <http://couchdb.apache.org/>`_.


.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
================

.. contents::
    :local:


couchdb.deps
------------

Installs compilation and runtime (OS Specific) dependencies.


couchdb.source
--------------

Retrieves source tarball and extracts it to the ``couchdb.tmp_dir``. The
version can be set with ``couchdb.version``.


couchdb.configure
-----------------

Calls the ``./configure`` command unless it has already previously been run for
that version.


couchdb.install
---------------

couchdb.user
------------

couchdb.service
---------------


Limitations
===========

* packages defined only for Debian

* does not include states for cluster setup


Credits
=======

\(c) 2016  Couchberries


This formula is based on the `couchdb-formula
<https://github.com/saltstack-formulas/couchdb-formula>`_ by AISLER, 2014,
http://www.aisler.net.
