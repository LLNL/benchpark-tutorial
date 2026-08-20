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

TO_BUILD_IDS=( "caliper" "thicket" "treescape" "benchpark" "init" "spawn" )

if [ $# -ge 2 ]; then
    TO_BUILD_IDS=( "$2" )
fi

caliper_IMAGE="ghcr.io/ilumsden/latest-caliper"
thicket_IMAGE="ghcr.io/ilumsden/latest-thicket"
treescape_IMAGE="ghcr.io/ilumsden/latest-treescape"
benchpark_IMAGE="ghcr.io/ilumsden/latest-benchpark"
init_IMAGE="ghcr.io/ilumsden/latest-test-init"
spawn_IMAGE="ghcr.io/ilumsden/latest-test-spawn"

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

# Extract Caliper and Adiak versions from caliper-tutorial submodule
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -x "${SCRIPT_DIR}/get_caliper_version.sh" ]; then
    echo "Extracting Caliper and Adiak versions from caliper-tutorial submodule..."
    CALIPER_VERSION=$(${SCRIPT_DIR}/get_caliper_version.sh caliper)
    ADIAK_VERSION=$(${SCRIPT_DIR}/get_caliper_version.sh adiak)
    echo "Using Caliper version: ${CALIPER_VERSION}"
    echo "Using Adiak version: ${ADIAK_VERSION}"
    CALIPER_BUILD_ARGS="--build-arg CALIPER_VERSION=${CALIPER_VERSION} --build-arg ADIAK_VERSION=${ADIAK_VERSION}"
else
    echo "Warning: get_caliper_version.sh not found, using default versions"
    CALIPER_BUILD_ARGS=""
fi

for bid in ${TO_BUILD_IDS[@]}; do
    CURR_IMAGE_NAME="${bid}_IMAGE"
    # Add build args for caliper image
    if [ "$bid" = "caliper" ]; then
        docker build --platform $DOCKER_PLATFORMS ${CALIPER_BUILD_ARGS} -f Dockerfile.$bid -t ${!CURR_IMAGE_NAME}:$TAG .
    else
        docker build --platform $DOCKER_PLATFORMS -f Dockerfile.$bid -t ${!CURR_IMAGE_NAME}:$TAG .
    fi
    docker push ${!CURR_IMAGE_NAME}:$TAG
done

# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.benchpark -t latest-benchpark:latest .
# docker tag latest-benchpark:latest $BENCHPARK_IMAGE:$TAG
# docker push $BENCHPARK_IMAGE:$TAG
#
# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.init -t latest-init:latest .
# docker tag latest-init:latest $INIT_IMAGE:$TAG
# docker push $INIT_IMAGE:$TAG
#
# docker build --platform $DOCKER_PLATFORMS -f Dockerfile.spawn -t latest-spawn:latest .
# docker tag latest-spawn:latest $SPAWN_IMAGE:$TAG
# docker push $SPAWN_IMAGE:$TAG
