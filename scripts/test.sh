#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IMAGE_NAME="${1:-keycloak-postgres-ssl}"
TIMEOUT=60

echo
echo "Testing ${IMAGE_NAME} ..."

"${SCRIPT_DIR}/run-postgres.sh" &
sleep 5

"${SCRIPT_DIR}/run-keycloak.sh" "$IMAGE_NAME" &

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

echo "Stopping..."
docker stop postgres-ssl
docker stop keycloak-postgres-ssl

echo "$RESULT ($STATUS)"
if [[ "$RESULT" != "SUCCESS" ]]; then
  exit 1
fi
