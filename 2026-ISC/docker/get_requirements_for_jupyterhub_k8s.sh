#!/usr/bin/env bash

function usage {
    echo "Usage: ./get_requirements_for_jupyterhub_k8s.sh <jupyterhub_k8s_version>"
}

if [[ $# -ne 1 ]]; then
    usage
    exit 1
fi

jh_k8s_version="$1"

if [[ "$jh_k8s_version" == "--help" ]] || [[ "$jh_k8s_version" == "-h" ]]; then
    usage
    exit 0
fi

if ! command -v gh >/dev/null; then
    echo "This script requires the GitHub CLI (i.e., the 'gh' command)!"
    echo "Install and try again"
    exit 1
fi

if ! command -v curl >/dev/null; then
    echo "This script requires the 'curl' command!"
    echo "Install and try again"
    exit 1
fi

if ! command -v jq >/dev/null; then
    echo "This script requires the 'jq' command!"
    echo "Install and try again"
    exit 1
fi

if ! command -v jq >/dev/null; then
    echo "This script requires the 'wget' command!"
    echo "Install and try again"
    exit 1
fi

if ! command -v sed >/dev/null; then
    echo "This script requires the 'sed' command!"
    echo "Install and try again"
    exit 1
fi

github_url="https://api.github.com/repos/jupyterhub/zero-to-jupyterhub-k8s/contents/images/hub/requirements.txt?ref=$jh_k8s_version"

file_lookup_json=$(curl -JL \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(gh auth token)" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$github_url")

wget_url=$(echo "$file_lookup_json" | jq -r '.download_url')

wget -O $(pwd)/requirements.txt $wget_url

sed -i '' '/psycopg2/d' $(pwd)/requirements.txt
