#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CERTS_DIR=${CERTS_DIR:-"${SCRIPT_DIR}/certs"}

IMAGE_TAG="${1:?Image tag is not specified}"
IMAGE="mnasyrov/keycloak-postgres-ssl:${IMAGE_TAG}"

if [ -f "$SCRIPT_DIR/../images/$IMAGE_TAG/run-image.sh" ] ; then
  "$SCRIPT_DIR/../images/$IMAGE_TAG/run-image.sh" "$IMAGE_TAG"
  exit
fi


docker run --rm --name keycloak-postgres-ssl -d -p 9080:8080 \
  --link postgres-ssl:postgres \
  -e KEYCLOAK_POSTGRES_HOST=postgres \
  -e KEYCLOAK_POSTGRES_DATABASE=keycloak-db \
  -e KEYCLOAK_POSTGRES_USER=keycloak-user \
  -e KEYCLOAK_POSTGRES_PASSWORD=keycloak \
  -e KEYCLOAK_JDBC_PARAMS='sslmode=verify-ca&sslrootcert=/opt/jboss/postgres.crt.der' \
  -v ${CERTS_DIR}/postgres.crt.der:/opt/jboss/postgres.crt.der \
  ${IMAGE}
