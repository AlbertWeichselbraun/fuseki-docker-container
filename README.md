# Fuseki Docker Container

Docker container and datasets used in the `Semantic Technologies` and `Knowledge Engineering and Extraction` lectures.

Build and publish multi-architecture images with Podman:

```sh
./build.sh
```

The default image is `ghcr.io/albertweichselbraun/fuseki-docker-container:current` for `linux/amd64` and `linux/arm64`. Set `IMAGE` or `PLATFORMS` to override either value. Authenticate with GitHub Container Registry before building:

```sh
echo "$GITHUB_TOKEN" | podman login ghcr.io -u ALBERTWEICHSELBRAUN --password-stdin
```

Cross-building `linux/arm64` on an `amd64` host also requires QEMU/binfmt emulation. Register it once before running the build:

```sh
podman run --rm --privileged docker.io/tonistiigi/binfmt --install arm64
```

If rootless Podman reports `Exec format error`, run the build rootfully. Rootful Podman uses separate root-owned image storage and registry credentials:

```sh
sudo podman login ghcr.io -u ALBERTWEICHSELBRAUN
ROOTFUL=1 ./build.sh
```

The `ROOTFUL=1` mode prefixes Podman commands with `sudo`; it does not change the target platforms or registry.


