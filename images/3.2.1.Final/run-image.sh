#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CERTS_DIR=${CERTS_DIR:-"${SCRIPT_DIR}/certs"}

IMAGE_TAG="${1:?Image tag is not specified}"
IMAGE="mnasyrov/keycloak-postgres-ssl:${IMAGE_TAG}"

docker run --rm --name keycloak-postgres-ssl -d -p 9080:8080 \
  --link postgres-ssl:postgres \
  -e KEYCLOAK_POSTGRES_HOST=postgres \
  -e KEYCLOAK_POSTGRES_DATABASE=keycloak-db \
  -e KEYCLOAK_POSTGRES_USER=keycloak-user \
  -e KEYCLOAK_POSTGRES_PASSWORD=keycloak \
  -e KEYCLOAK_JDBC_PARAMS='sslmode=verify-ca' \
  -v ${CERTS_DIR}/keycloak-certs.jks:/opt/jboss/keycloak-certs.jks \
  ${IMAGE} \
  -b=0.0.0.0 \
  -Djavax.net.ssl.trustStore=/opt/jboss/keycloak-certs.jks \
  -Djavax.net.ssl.trustStorePassword=password
