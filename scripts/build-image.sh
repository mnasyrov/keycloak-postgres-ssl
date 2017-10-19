#!/usr/bin/env bash

IMAGE_TAG="${1:?Image tag is not specified}"
IMAGE="mnasyrov/keycloak-postgres-ssl:${IMAGE_TAG}"

docker build --pull -t "${IMAGE}" "./images/${IMAGE_TAG}"
