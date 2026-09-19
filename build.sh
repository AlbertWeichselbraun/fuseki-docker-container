#!/bin/bash

set -e

IMAGE="${IMAGE:-ghcr.io/albertweichselbraun/fuseki-docker-container:current}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
PODMAN=(podman)
if [[ "${ROOTFUL:-0}" == "1" ]]; then
	PODMAN=(sudo podman)
fi

host_arch=$("${PODMAN[@]}" info --format '{{.Host.Arch}}')
IFS=',' read -r -a platform_list <<< "$PLATFORMS"
for platform in "${platform_list[@]}"; do
	target_arch=${platform##*/}
	if [[ "$target_arch" != "$host_arch" && "$target_arch" == "arm64" && ! -e /proc/sys/fs/binfmt_misc/qemu-aarch64 ]]; then
		cat >&2 <<'EOF'
arm64 builds require registered QEMU/binfmt emulation on this amd64 host.
Run this once with a Podman setup that permits privileged containers:

  podman run --rm --privileged docker.io/tonistiigi/binfmt --install arm64

Then run ./build.sh again.
EOF
		exit 1
	fi
done

if "${PODMAN[@]}" manifest exists "$IMAGE"; then
	"${PODMAN[@]}" manifest rm "$IMAGE"
fi

for platform in "${platform_list[@]}"; do
	"${PODMAN[@]}" build \
		--platform "$platform" \
		--manifest "$IMAGE" \
		jena-fuseki
done

"${PODMAN[@]}" manifest push --all "$IMAGE" "docker://$IMAGE"

