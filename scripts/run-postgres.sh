#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="${SCRIPT_DIR}/certs"
PG_DIR="${SCRIPT_DIR}/postgres"

docker run --rm --name postgres-ssl -d -p 54320:5432 \
  -e POSTGRES_PASSWORD=password \
  -v ${CERTS_DIR}/postgres.crt:/srv/server.crt \
  -v ${CERTS_DIR}/postgres.key:/srv/server.key \
  -v ${PG_DIR}/postgresql.conf:/srv/postgresql.conf \
  -v ${PG_DIR}/reconfigure_postgres.sh:/docker-entrypoint-initdb.d/reconfigure_postgres.sh \
  -v ${PG_DIR}/init-keycloak-db.sql:/docker-entrypoint-initdb.d/init-keycloak-db.sql \
  postgres:9.6
