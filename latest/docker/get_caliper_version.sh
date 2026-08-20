#!/usr/bin/env bash

# Script to extract Caliper and Adiak versions from the caliper-tutorial submodule
# Usage: ./get_caliper_version.sh [caliper|adiak]

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CALIPER_TUTORIAL_PATH="${REPO_ROOT}/latest/tutorial-code/caliper-tutorial"

# Ensure the caliper-tutorial submodule is initialized
if [ ! -d "${CALIPER_TUTORIAL_PATH}/.git" ]; then
    echo "Error: caliper-tutorial submodule not initialized at ${CALIPER_TUTORIAL_PATH}" >&2
    echo "Please run: git submodule update --init --recursive latest/tutorial-code/caliper-tutorial" >&2
    exit 1
fi

cd "${CALIPER_TUTORIAL_PATH}"

# Get the caliper submodule commit hash
CALIPER_COMMIT=$(git submodule status | grep caliper | awk '{print $1}' | sed 's/^[-+]//')

if [ -z "${CALIPER_COMMIT}" ]; then
    echo "Error: Could not find caliper submodule in caliper-tutorial" >&2
    exit 1
fi

# Initialize the caliper submodule to get version information
git submodule update --init caliper 2>/dev/null || true

cd caliper

# Try to get a tag for this commit
CALIPER_TAG=$(git describe --tags --exact-match "${CALIPER_COMMIT}" 2>/dev/null || echo "")

if [ -z "${CALIPER_TAG}" ]; then
    # No exact tag match, use the commit hash
    CALIPER_VERSION="${CALIPER_COMMIT}"
else
    CALIPER_VERSION="${CALIPER_TAG}"
fi

# Get Adiak version from Caliper's submodules or default
if [ -f .gitmodules ] && grep -q "path = ext/adiak" .gitmodules; then
    git submodule update --init ext/adiak 2>/dev/null || true
    ADIAK_COMMIT=$(git submodule status ext/adiak | awk '{print $1}' | sed 's/^[-+]//')

    cd ext/adiak
    ADIAK_TAG=$(git describe --tags --exact-match "${ADIAK_COMMIT}" 2>/dev/null || echo "")

    if [ -z "${ADIAK_TAG}" ]; then
        ADIAK_VERSION="${ADIAK_COMMIT}"
    else
        ADIAK_VERSION="${ADIAK_TAG}"
    fi
else
    # Default version if Adiak is not a submodule
    ADIAK_VERSION="v0.5.0"
fi

# Output based on requested component
if [ $# -eq 0 ]; then
    echo "CALIPER_VERSION=${CALIPER_VERSION}"
    echo "ADIAK_VERSION=${ADIAK_VERSION}"
elif [ "$1" = "caliper" ]; then
    echo "${CALIPER_VERSION}"
elif [ "$1" = "adiak" ]; then
    echo "${ADIAK_VERSION}"
else
    echo "Error: Unknown component '$1'. Use 'caliper' or 'adiak'" >&2
    exit 1
fi
