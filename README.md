# aaps-builder
Builds AndroidAPS from source.

[Docker Hub](https://hub.docker.com/r/avalitan/aaps-builder)

## How To
### Linux
> docker run --network host --mount type=bind,source="$(pwd)",target=/aaps -it --rm -p 8080:8080 avalitan/aaps-builder:v1.0.6 --version 3.3.0.0 all
### Windows
- Still need to figure this out
