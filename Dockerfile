FROM quay.io/ibmz/maven:3.6.3
RUN apt-get update && apt-get install -y curl wget vim git gnupg unzip software-properties-common

# Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg > Docker.key
RUN apt-key --keyring /etc/apt/trusted.gpg.d/Docker.gpg add Docker.key
RUN rm Docker.key
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=s390x] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

ENV DOCKER_VERSION=18.06.0
ENV ARTIFACTORY_VERSION=6.23.3
RUN apt-get --assume-yes install docker-ce=${DOCKER_VERSION}~ce~3-0~ubuntu

# Update settings as described by read me https://bintray.com/jfrog/artifactory/jfrog-artifactory-oss-zip/6.19.1#read
RUN mkdir /root/.m2 && curl -X GET https://bintray.com/repo/downloadMavenRepoSettingsFile/downloadSettings?repoPath=%2Fbintray%2Fjcenter > /root/.m2/settings.xml

# Get source
RUN wget -O jfrog.tar.gz https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-sources.tar.gz && \
    gunzip jfrog.tar.gz && \
    tar -xvf jfrog.tar && \
    mv jfrog-artifactory-${ARTIFACTORY_VERSION} jfrog/
WORKDIR /jfrog/distribution/docker/src/main/docker
RUN ls /jfrog/distribution/docker/src/main/docker
COPY build-on-z.patch build-on-z.patch
RUN patch < build-on-z.patch
WORKDIR /jfrog/distribution/docker/

# Entrypoint, use CMD so you can override to debug
CMD  mvn clean package -X -Pdocker
