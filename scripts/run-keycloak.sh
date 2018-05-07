#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="${SCRIPT_DIR}/certs"

IMAGE_NAME="${1:-keycloak-postgres-ssl}"

docker run --rm --name keycloak-postgres-ssl -p 9080:8080 \
  --link postgres-ssl:postgres \
  -e KEYCLOAK_USER=admin \
  -e KEYCLOAK_PASSWORD=admin \
  -e POSTGRES_PORT_5432_TCP_ADDR=postgres \
  -e POSTGRES_DATABASE=keycloak-db \
  -e POSTGRES_USER=keycloak-user \
  -e POSTGRES_PASSWORD=keycloak \
  -e KEYCLOAK_JDBC_PARAMS='sslmode=verify-ca' \
  -e POSTGRES_JDBC_PARAMS='sslrootcert=/opt/jboss/postgres.crt.der' \
  -v ${CERTS_DIR}/postgres.crt.der:/opt/jboss/postgres.crt.der \
  ${IMAGE_NAME}
