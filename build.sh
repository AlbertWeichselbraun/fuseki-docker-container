#!/bin/bash

set -e

IMAGE="${IMAGE:-albert/fuseki:current}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"

docker buildx build \
	--platform "$PLATFORMS" \
	--tag "$IMAGE" \
	--push \
	jena-fuseki

