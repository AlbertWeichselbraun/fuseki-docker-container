# Fuseki Docker Container

Docker container and datasets used in the `Semantic Technologies` and `Knowledge Engineering and Extraction` lectures.

Build and publish multi-architecture images with Docker Buildx:

```sh
./build.sh
```

The default image is `albert/fuseki:current` for `linux/amd64` and `linux/arm64`. Set `IMAGE` or `PLATFORMS` to override either value. Authenticate with the target registry before building.


