#!/usr/bin/env bash

RELEASE="datadog-cluster-agent"

# Create the release
bosh create-release --force --final --tarball=datadog-cluster-agent-boshrelease.tgz --name $RELEASE --version $VERSION
