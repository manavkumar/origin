#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

OS_ROOT=$(dirname "${BASH_SOURCE}")/..
source "${OS_ROOT}/hack/common.sh"

os::build::get_version_vars
# OS_GIT_VERSION is like 'v0.3.1-4-g2c853ed-dirty'
IMAGE_VERSION=`echo ${OS_GIT_VERSION} | cut -d '-' -f 1`

docker build --no-cache=true -t openshift3/ose-base ./base && \
docker build --no-cache=true -t openshift3/ose ./ose/ && \
docker build --no-cache=true -t openshift3/ose-haproxy-router-base ./router/haproxy-base/ && \
docker build --no-cache=true -t openshift3/ose-haproxy-router ./router/haproxy/ && \
docker build --no-cache=true -t openshift3/ose-deployer ./deployer/ && \
docker build --no-cache=true -t openshift3/ose-docker-builder ./builder/docker/docker-builder/ && \
docker build --no-cache=true -t openshift3/ose-sti-builder ./builder/docker/sti-builder/ && \
docker build --no-cache=true -t openshift3/ose-sti-image-builder ./builder/docker/sti-image-builder/ && \
docker build --no-cache=true -t openshift3/ose-pod ./pod/
docker build --no-cache=true -t openshift3/ose-docker-registry ./dockerregistry
docker build --no-cache=true -t openshift3/ose-keepalived-ipfailover ./ipfailover/keepalived

docker tag -f openshift3/ose-docker-builder localhost:5000/openshift3/ose-docker-builder
docker tag -f openshift3/ose-docker-builder localhost:5000/openshift3/ose-docker-builder:${IMAGE_VERSION}

docker tag -f openshift3/ose-sti-builder localhost:5000/openshift3/ose-sti-builder
docker tag -f openshift3/ose-sti-builder localhost:5000/openshift3/ose-sti-builder:${IMAGE_VERSION}

docker tag -f openshift3/ose-sti-image-builder localhost:5000/openshift3/ose-sti-image-builder
docker tag -f openshift3/ose-sti-image-builder localhost:5000/openshift3/ose-sti-image-builder:${IMAGE_VERSION}

docker tag -f openshift3/ose-deployer localhost:5000/openshift3/ose-deployer
docker tag -f openshift3/ose-deployer localhost:5000/openshift3/ose-deployer:${IMAGE_VERSION}

docker tag -f openshift3/ose-haproxy-router localhost:5000/openshift3/ose-haproxy-router
docker tag -f openshift3/ose-haproxy-router localhost:5000/openshift3/ose-haproxy-router:${IMAGE_VERSION}

docker tag -f openshift3/ose-pod localhost:5000/openshift3/ose-pod
docker tag -f openshift3/ose-pod localhost:5000/openshift3/ose-pod:${IMAGE_VERSION}

docker tag -f openshift3/ose-docker-registry localhost:5000/openshift3/ose-docker-registry
docker tag -f openshift3/ose-docker-registry localhost:5000/openshift3/ose-docker-registry:${IMAGE_VERSION}

docker tag -f openshift3/ose-keepalived-ipfailover localhost:5000/openshift3/ose-keepalived-ipfailover
docker tag -f openshift3/ose-keepalived-ipfailover localhost:5000/openshift3/ose-keepalived-ipfailover:${IMAGE_VERSION}

docker push localhost:5000/openshift3/ose-docker-builder:latest &&
docker push localhost:5000/openshift3/ose-docker-builder:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-sti-builder:latest &&
docker push localhost:5000/openshift3/ose-sti-builder:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-sti-image-builder:latest &&
docker push localhost:5000/openshift3/ose-sti-image-builder:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-deployer:latest &&
docker push localhost:5000/openshift3/ose-deployer:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-haproxy-router:latest &&
docker push localhost:5000/openshift3/ose-haproxy-router:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-pod:latest &&
docker push localhost:5000/openshift3/ose-pod:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-docker-registry:latest &&
docker push localhost:5000/openshift3/ose-docker-registry:${IMAGE_VERSION} &&
docker push localhost:5000/openshift3/ose-keepalived-ipfailover:latest &&
docker push localhost:5000/openshift3/ose-keepalived-ipfailover:${IMAGE_VERSION}

docker rmi $(docker images -q --filter "dangling=true")
