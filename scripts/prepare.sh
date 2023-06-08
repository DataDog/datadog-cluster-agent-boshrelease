#!/usr/bin/env bash
set -e

BLOBS_D="$(pwd)/blobs"
BLOB="datadog-cluster-agent/datadog-cluster-agent-cloudfoundry.tar.xz"
DEFAULT_CLUSTER_AGENT_VERSION="7.41.1"
CLUSTER_AGENT_VERSION=${1:-$DEFAULT_CLUSTER_AGENT_VERSION}
DOWNLOAD_URL="http://s3.amazonaws.com/dsd6-staging/linux/cluster-agent-cloudfoundry/datadog-cluster-agent-cloudfoundry-${CLUSTER_AGENT_VERSION}-amd64.tar.xz"

main() {
    mkdir -p "$(dirname ${BLOBS_D}/${BLOB})"

    echo "Downloading ${DOWNLOAD_URL} ..."
    curl -L --fail "${DOWNLOAD_URL}" -o "${BLOBS_D}/${BLOB}"
    
    # setting up the local blobstore
    cp config/final.yml config/final.yml.bk
    cp config/final.yml.local config/final.yml

    bosh add-blob "${BLOBS_D}/${BLOB}" "$BLOB"
}

main "$@"