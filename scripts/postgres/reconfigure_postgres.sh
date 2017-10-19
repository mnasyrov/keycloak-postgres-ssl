#!/usr/bin/env bash

cp /srv/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /srv/server.crt /var/lib/postgresql/data/server.crt
cp /srv/server.key /var/lib/postgresql/data/server.key

chown -R postgres: /var/lib/postgresql/data/
chmod og-rwx /var/lib/postgresql/data/server.key
