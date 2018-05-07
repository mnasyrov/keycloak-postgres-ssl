#!/usr/bin/env bash

IMAGE_NAME="${1:-keycloak-postgres-ssl}"

docker build --pull -t "${IMAGE_NAME}" ./src
