#!/bin/bash 

# https://semanticlab.net/virtualization/Cross-Platform_Docker_HOWTO/

docker-machine create fuseki
eval "$(docker-machine env fuseki)"

docker build --rm --tag albert/fuseki:current jena-fuseki

