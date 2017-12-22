#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR=${CERTS_DIR:-"${SCRIPT_DIR}/certs"}

IMAGE_NAME="${1:-keycloak-postgres-ssl}"

docker run --rm --name keycloak-postgres-ssl -d -p 9080:8080 \
  --link postgres-ssl:postgres \
  -e KEYCLOAK_POSTGRES_HOST=postgres \
  -e KEYCLOAK_POSTGRES_DATABASE=keycloak-db \
  -e KEYCLOAK_POSTGRES_USER=keycloak-user \
  -e KEYCLOAK_POSTGRES_PASSWORD=keycloak \
  -e KEYCLOAK_JDBC_PARAMS='sslmode=verify-ca' \
  -v ${CERTS_DIR}/keycloak-certs.jks:/opt/jboss/keycloak-certs.jks \
  ${IMAGE_NAME} \
  -b=0.0.0.0 \
  -Djavax.net.ssl.trustStore=/opt/jboss/keycloak-certs.jks \
  -Djavax.net.ssl.trustStorePassword=password
