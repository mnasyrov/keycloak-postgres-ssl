#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IMAGE_TAG="${1:?Image tag is not specified}"
IMAGE="mnasyrov/keycloak-postgres-ssl:${IMAGE_TAG}"
TIMEOUT=60

echo "Testing ${IMAGE} ..."

"${SCRIPT_DIR}/run-postgres.sh"
set -e
"${SCRIPT_DIR}/run-image.sh" "$IMAGE_TAG"
set +e

STATUS=""
ATTEMPT=0
RESULT="FAIL"
while [[ "$ATTEMPT" -lt "$TIMEOUT" && "$RESULT" == "FAIL" ]]; do
  printf '.'
  ATTEMPT=$((ATTEMPT+1))

  STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" http://localhost:9080/auth/)
  if [[ "$STATUS" == "200" ]]; then
    RESULT="SUCCESS"
  fi
  if [[ "$ATTEMPT" -gt "5" ]]; then
    if ! docker top postgres-ssl &>/dev/null; then
      RESULT="CRASH"
      STATUS="postgres container was stopped"
    fi
    if ! docker top keycloak-postgres-ssl &>/dev/null; then
      RESULT="CRASH"
      STATUS="keycloak container was stopped"
    fi
  fi

  if [[ "$RESULT" == "FAIL" ]]; then
    sleep 1
  fi
done
echo

if [[ "$RESULT" == "FAIL" ]]; then
  echo "Getting logs..."
  docker logs postgres-ssl
  docker logs keycloak-postgres-ssl
fi

echo "$RESULT ($STATUS)"

echo "Stopping..."
docker stop postgres-ssl
docker stop keycloak-postgres-ssl
