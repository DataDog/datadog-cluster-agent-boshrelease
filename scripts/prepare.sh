#!/usr/bin/env bash
set -e

BLOBS_D="$(pwd)/blobs"
BLOB="datadog-cluster-agent/datadog-cluster-agent-cloudfoundry.tar.xz"
DEFAULT_CLUSTER_AGENT_VERSION="7.20.1"
CLUSTER_AGENT_VERSION=${1:-$DEFAULT_CLUSTER_AGENT_VERSION}
DOWNLOAD_URL="http://s3.amazonaws.com/dd-agent/agent7/cluster-agent-cloudfoundry/linux/datadog-cluster-agent-cloudfoundry-${CLUSTER_AGENT_VERSION}-amd64.tar.xz"

echo "Downloading ${DOWNLOAD_URL} ..."
mkdir -p "$(dirname ${BLOBS_D}/${BLOB})"
curl -L --fail "${DOWNLOAD_URL}" -o "${BLOBS_D}/${BLOB}"
bosh add-blob "${BLOBS_D}/${BLOB}" "$BLOB"
