#!/usr/bin/env sh
set -eux

TAG=${1:-latest}

IMAGE_NAME=yehorb/git-hours:$TAG
COMMIT_HASH=`git rev-parse --short HEAD`
IMAGE_COMMIT=yehorb/git-hours:$TAG-$COMMIT_HASH

docker build \
    --file Dockerfile \
    --build-arg IMAGE_NAME=$IMAGE_NAME \
    --build-arg VCS_REF=$COMMIT_HASH \
    --compress \
    --force-rm \
    --no-cache \
    --rm \
    --tag $IMAGE_NAME \
    .
