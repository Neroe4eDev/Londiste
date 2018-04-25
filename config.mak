
prefix = /opt/skytools2
datarootdir = ${prefix}/share
mandir = ${datarootdir}/man

override PYTHON = /usr/bin/python
override PG_CONFIG = /usr/lib/postgresql/9.6/bin/pg_config

# additional CPPFLAGS to pgxs modules
PG_CPPFLAGS = $(filter -DHAVE%, -DPACKAGE_NAME=\"skytools\" -DPACKAGE_TARNAME=\"skytools\" -DPACKAGE_VERSION=\"2.1.13\" -DPACKAGE_STRING=\"skytools\ 2.1.13\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DHAVE_UNSETENV=1)

SQLDIR = $(prefix)/share/skytools

PGXS = $(shell $(PG_CONFIG) --pgxs)

DESTDIR = /

ASCIIDOC = no
XMLTO = no

PACKAGE_NAME = skytools
PACKAGE_TARNAME = skytools
PACKAGE_VERSION = 2.1.13
PACKAGE_STRING = skytools 2.1.13

