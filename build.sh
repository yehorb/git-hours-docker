#!/usr/bin/env sh
set -eux

TAG=${1:-latest}
IMAGE_NAME='yehorb/git-hours'
COMMIT_HASH=$(git rev-parse --short HEAD)
IMAGE_COMMIT="$IMAGE_NAME:$COMMIT_HASH"
IMAGE_TAG="$IMAGE_NAME:$TAG"

docker build \
    --file Dockerfile \
    --build-arg IMAGE_NAME=$IMAGE_NAME \
    --build-arg COMMIT_HASH=$COMMIT_HASH \
    --compress \
    --memory 4096g \
    --tag $IMAGE_COMMIT \
    .

docker tag \
    $IMAGE_COMMIT \
    $IMAGE_TAG
