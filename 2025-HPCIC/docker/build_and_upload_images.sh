#!/usr/bin/env bash

set -e

function usage {
    echo "Usage: ./build_and_upload_images.sh <tag> [image_to_build]"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

if [ $1 == "-h" ] || [ $1 == "--help" ]; then
    usage
    exit 0
fi

TAG="$1"

DOCKER_PLATFORMS="linux/amd64,linux/arm64"

TO_BUILD_IDS=( "caliper" "thicket" "benchpark" "init" "spawn" )

if [ $# -ge 2 ]; then
    TO_BUILD_IDS=( "$2" )
fi

caliper_IMAGE="ghcr.io/ilumsden/hpcic-caliper"
thicket_IMAGE="ghcr.io/ilumsden/hpcic-thicket"
benchpark_IMAGE="ghcr.io/ilumsden/hpcic-benchpark"
init_IMAGE="ghcr.io/ilumsden/hpcic-test-init"
spawn_IMAGE="ghcr.io/ilumsden/hpcic-test-spawn"

if ! command -v gh >/dev/null 2>&1; then
    echo "This script requires the GitHub CLI (i.e., the gh command)."
    echo "Install the CLI and rerun this script."
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "This script requires Docker."
    echo "Install Docker and rerun this script."
    exit 1
fi

echo $(gh auth token) | docker login ghcr.io -u $(gh api user --jq .login) --password-stdin

for bid in ${TO_BUILD_IDS[@]}; do
    CURR_IMAGE_NAME="${bid}_IMAGE"
    docker build --platform $DOCKER_PLATFORMS -f Dockerfile.$bid -t ${!CURR_IMAGE_NAME}:$TAG .
    docker push ${!CURR_IMAGE_NAME}:$TAG
done

# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.benchpark -t hpcic-benchpark:latest .
# docker tag hpcic-benchpark:latest $BENCHPARK_IMAGE:$TAG
# docker push $BENCHPARK_IMAGE:$TAG
#
# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.init -t hpcic-init:latest .
# docker tag hpcic-init:latest $INIT_IMAGE:$TAG
# docker push $INIT_IMAGE:$TAG
#
# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.spawn -t hpcic-spawn:latest .
# docker tag hpcic-spawn:latest $SPAWN_IMAGE:$TAG
# docker push $SPAWN_IMAGE:$TAG
