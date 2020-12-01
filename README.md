# Tags
> _Built from [`quay.io/ibmz/openjdk:11.0.8`](https://quay.io/repository/ibmz/openjdk?tab=info)_
-	[`6.23.3`](https://github.com/lcarcaramo/jfrog-artifactory-oss/blob/main/Dockerfile) - [![Build Status](https://travis-ci.com/lcarcaramo/jfrog-artifactory-oss.svg?branch=main)](https://travis-ci.com/lcarcaramo/jfrog-artifactory-oss)

# What is JFrog Artifactory OSS?

![JFrog Logo](https://media.jfrog.com/wp-content/uploads/2019/11/20130211/artifactory-product-logo-1.png.webp)

JFrog Artifactory OSS is an open source variant JFrog Artifactory. JFrog Artifactory is binary repository, and as a binary repository, Artifactory is optimized for storing binaries and large objects. Artifactory is useful for a number of DevOps use cases including, but not limited to being used as a place to store build artfacts, and being used to store binaries that are frequently accessed.

# How to use this image

* Start a `quay.io/ibmz/jfrog-artifactory-oss:6.23.3` container with port 8081 exposed so that you can interact with Artifactory.
```console
$ docker run --name artifactory -p 8081:8081 -d quay.io/ibmz/jfrog-artifactory-oss:6.23.3
```
* After waiting a minute for Artifactory to be ready, open the Artifactory UI from a web browser. If you are able to access the Artifactory web UI, that is an indication that Artifactory is working properly.
  * `http://<host/ip where artifactory is running>:8081/artifactory/webapp/#/home`
  
* More information about using [Artifactory on zCX]() _(Currently unavailable)_

# License

JFrog Artifactory is licensed under [AGPL 3.0](https://www.gnu.org/licenses/agpl-3.0.html)

[Source Code](https://bintray.com/jfrog/artifactory/jfrog-artifactory-oss-zip)
