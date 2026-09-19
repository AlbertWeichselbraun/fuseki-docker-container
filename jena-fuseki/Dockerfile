#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


FROM docker.io/library/eclipse-temurin:21-jre-jammy
RUN apt-get update && \
        apt-get install --no-install-recommends --yes bash ca-certificates pwgen wget && \
        rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.authors="Stian Soiland-Reyes <stain@apache.org>"

# Update below according to https://jena.apache.org/download/
ENV FUSEKI_SHA512 ba65f5867d2d4741b2ed9e2af5a0d4fbb447909894ab2a0c6bc4dac8997f4fe339c87b13c48d45d054977769f0f8bf763ea346b1f7792d5cdc458041bd43a132
ENV FUSEKI_VERSION 6.2.0
ENV FUSEKI_MIRROR https://dlcdn.apache.org/
ENV FUSEKI_ARCHIVE https://archive.apache.org/dist/
#

# Config and data
ENV FUSEKI_BASE /fuseki


# Installation folder
ENV FUSEKI_HOME /jena-fuseki

WORKDIR /tmp
# Download/check/unpack/move in one go (to reduce image size)
RUN     wget -O fuseki.tar.gz $FUSEKI_MIRROR/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
        wget -O fuseki.tar.gz $FUSEKI_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz && \
        echo "$FUSEKI_SHA512  fuseki.tar.gz" | sha512sum -c - && \
        tar zxf fuseki.tar.gz && \
        mv apache-jena-fuseki* $FUSEKI_HOME && \
        rm fuseki.tar.gz* && \
        cd $FUSEKI_HOME && rm -rf fuseki.war


# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY shiro.ini /jena-fuseki/shiro.ini
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

COPY load.sh /jena-fuseki/
COPY tdbloader /jena-fuseki/
RUN chmod 755 /jena-fuseki/load.sh /jena-fuseki/tdbloader

# setup repositories
COPY configuration/*.ttl /fuseki/configuration/
RUN mkdir -v -p /fuseki/databases/cafe /fuseki/databases/foaf /fuseki/databases/nal-thesaurus /fuseki/databases/sonnensystem /fuseki/databases/tims-foaf-file
RUN chmod 755 /fuseki/databases/cafe /fuseki/databases/foaf /fuseki/databases/nal-thesaurus /fuseki/databases/sonnensystem /fuseki/databases/tims-foaf-file

# copy data files
COPY ./datasets/*.ttl /staging/
COPY ./datasets/*.xml.gz /staging/
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

# install data files
WORKDIR /jena-fuseki
RUN ./load.sh sonnensystem sonnensystem.ttl
RUN ./load.sh foaf foaf.ttl
RUN ./load.sh cafe cafes.ttl
RUN ./load.sh nal-thesaurus NAL_Thesaurus_2016_SKOS.xml.gz

# delete data files
RUN rm -rf /staging/*.ttl /staging/*.xml.gz

WORKDIR /jena-fuseki
EXPOSE 3030
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/jena-fuseki/fuseki-server"]
