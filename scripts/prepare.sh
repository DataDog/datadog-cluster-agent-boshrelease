#!/usr/bin/env bash
set -e

BLOBS_D="$(pwd)/blobs"
BLOB="datadog-cluster-agent/datadog-cluster-agent-cloudfoundry.tar.xz"
DEFAULT_CLUSTER_AGENT_VERSION="7.30.0"
CLUSTER_AGENT_VERSION=${1:-$DEFAULT_CLUSTER_AGENT_VERSION}
if echo "$CLUSTER_AGENT_VERSION" | grep -E "devel\.git\.|rc\."; then
    DOWNLOAD_URL="http://s3.amazonaws.com/dsd6-staging/linux/cluster-agent-cloudfoundry/datadog-cluster-agent-cloudfoundry-${CLUSTER_AGENT_VERSION}-amd64.tar.xz"
else
    DOWNLOAD_URL="http://s3.amazonaws.com/dd-agent/agent7/cluster-agent-cloudfoundry/linux/datadog-cluster-agent-cloudfoundry-${CLUSTER_AGENT_VERSION}-amd64.tar.xz"
fi

echo "Downloading ${DOWNLOAD_URL} ..."
mkdir -p "$(dirname ${BLOBS_D}/${BLOB})"
curl -L --fail "${DOWNLOAD_URL}" -o "${BLOBS_D}/${BLOB}"
bosh add-blob "${BLOBS_D}/${BLOB}" "$BLOB"
