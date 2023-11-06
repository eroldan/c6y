#!/bin/bash

REGISTRY="${REGISTRY:-docker.io/eroldan}"
SERVICE=c6y-helloworld

set -x


DATE=$(date "+%Y%m%d")
COMMIT=$(git rev-parse --short HEAD)
BRANCH="${GIT_BRANCH:-$(git branch --show-current)}"
REPO_NAME=${REGISTRY}/${SERVICE}


if [ -n "${BUILD_NUMBER}" ]; then # BUILD_NUMBER should be set as "environment" in the workflow, from {{github.run_number}}
    BUILD_TAG="${REPO_NAME}:${BRANCH}-${BUILD_NUMBER}"
else
    BUILD_TAG="${REPO_NAME}:${BRANCH}.${DATE}-$(echo $(date '+%s') - 1699239687 |  bc)"
fi

#podman login docker.io
pushd app
pipenv requirements > requirements.txt
podman build -f Containerfile -t ${REPO_NAME}:latest -t ${BUILD_TAG}
podman push ${BUILD_TAG}
podman push ${REPO_NAME}:latest
popd
