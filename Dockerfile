# Install Docker
FROM quay.io/ibmz/ubuntu:18.04 AS docker-cli
ENV DOCKER_VERSION=18.06.0
RUN apt-get update && apt-get install -y \
                                curl \
                                gnupg \
                                software-properties-common; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg > Docker.key; \
    apt-key --keyring /etc/apt/trusted.gpg.d/Docker.gpg add Docker.key; \
    rm Docker.key; \
    apt-key fingerprint 0EBFCD88; \
    add-apt-repository \
       "deb [arch=s390x] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"; \
    apt-get --assume-yes install docker-ce=${DOCKER_VERSION}~ce~3-0~ubuntu

# Build Artifactory
FROM quay.io/ibmz/maven:3.6.3
ENV ARTIFACTORY_VERSION=6.23.3
COPY --from=docker-cli /usr/bin/docker /usr/bin/docker
RUN apt-get update && apt-get install -y \
                                wget \
                                unzip \
                                patch \
                                libltdl7; \
    # Update settings as described by read me https://bintray.com/jfrog/artifactory/jfrog-artifactory-oss-zip/6.23.3#read
    mkdir /root/.m2 && curl -X GET https://bintray.com/repo/downloadMavenRepoSettingsFile/downloadSettings?repoPath=%2Fbintray%2Fjcenter > /root/.m2/settings.xml; \
    # Get source
    wget -O jfrog.tar.gz https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-sources.tar.gz; \
    gunzip jfrog.tar.gz; \
    tar -xvf jfrog.tar; \
    mv jfrog-artifactory-${ARTIFACTORY_VERSION} jfrog/
# Apply zCX patch to Artifactory's Dockerfile
WORKDIR /jfrog/distribution/docker/src/main/docker
COPY build-on-z.patch build-on-z.patch
RUN patch < build-on-z.patch
WORKDIR /jfrog/distribution/docker/
# Build Aritfactory image for zCX.
CMD  mvn clean package -Pdocker
