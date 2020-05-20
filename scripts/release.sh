#!/usr/bin/env bash

RELEASE="datadog-cluster-agent"

VERSION_STRING=""
if [[ ! -z $VERSION ]]; then
  VERSION_STRING="--version=$VERSION"
fi

# Create the release
bosh create-release --force --final --tarball=datadog-agent-cluster-boshrelease.tgz --name $RELEASE $VERSION_STRING
