#!/bin/bash -l

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
set -euxo pipefail

# This script is to publish the cluster-agent bosh release from Datadog's internal infrastructure to public repositories.
if [[ -z ${VERSION+x} ]]; then
  echo "You must set a version"
  exit 1
fi

# Make sure variables are set
if [ -z ${RELEASE_BUCKET+x} ]; then
  RELEASE_BUCKET="false"
fi
if [ -z ${REPO_BRANCH+x} ]; then
  REPO_BRANCH="master"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR="$DIR/.."
RELEASE_ARCHIVE_NAME="datadog-cluster-agent-boshrelease"

mkdir -p $WORKING_DIR/blobstore

# if bosh isn't on the docker image, download it
if [ ! -f "/usr/local/bin/bosh" ]; then
  mkdir -p $WORKING_DIR/bin
  curl -sSL -o $WORKING_DIR/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v6.2.1/bosh-cli-6.2.1-linux-amd64
  chmod +x $WORKING_DIR/bin/bosh
  export PATH="$WORKING_DIR/bin:$PATH"
fi

# get github credentials
mkdir -p ~/.ssh
aws ssm get-parameter --name ci.datadog-cluster-agent-boshrelease.ssh_private_key --with-decryption --query "Parameter.Value" --out text --region us-east-1 > ~/.ssh/id_rsa_github
chmod 400 ~/.ssh/id_rsa_github

# setup ssh key
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_github
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# config git
git config --global user.email "Robot-Github-IntegrationToolsandLibraries@datadoghq.com"
git config --global user.name "robot-github-intg-tools"
git remote set-url origin git@github.com:DataDog/datadog-cluster-agent-boshrelease.git
git config --global push.default simple
git fetch
git checkout $REPO_BRANCH

cp $WORKING_DIR/config/final.yml.s3 $WORKING_DIR/config/final.yml
BUCKET_NAME="public-datadog-agent-boshrelease"
echo '{"blobstore": {"options": {"credentials_source": "env_or_profile"}}}' > $WORKING_DIR/config/private.yml

# make sure we're in the right directory
cd $WORKING_DIR

# run the prepare script
./scripts/prepare.sh

# sync blobs
bosh sync-blobs

# release a dev version firstto ensure the cache is warm
# (it's better to fail here than to fail when really attempting to release it)
bosh create-release --force --name "datadog-cluster-agent"

# if it's a dry run, then set the bucket to a local bucket
# we have to make sure the cache is warm first
if [ "$DRY_RUN" = "true" ]; then
  cp $WORKING_DIR/config/final.yml.local $WORKING_DIR/config/final.yml
  echo '{}' > $WORKING_DIR/config/private.yml
  BUCKET_NAME=""
fi

# create the final release
./scripts/release.sh

if [ "$DRY_RUN" = "true" ]; then
  exit 0
fi

# upload the blobs
bosh upload-blobs

# git commit it and then push it to the repo
git add .final_builds/ releases/ config/blobs.yml
git commit -m "Release datadog cluster agent $VERSION"
git push

# cache the blobs
mkdir -p ./archive
cp -R $WORKING_DIR/blobstore archive/blobstore
cp $WORKING_DIR/$RELEASE_ARCHIVE_NAME.tgz archive/$RELEASE_ARCHIVE_NAME.tgz

if [ "$RELEASE_BUCKET" -a "$RELEASE_BUCKET" != "false" ]; then
    # the production release bucket is cloudfoundry.datadoghq.com/datadog-cluster-agent
    aws s3 cp $RELEASE_ARCHIVE_NAME.tgz s3://$RELEASE_BUCKET/$RELEASE_ARCHIVE_NAME-$VERSION.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
    aws s3 cp $RELEASE_ARCHIVE_NAME.tgz s3://$RELEASE_BUCKET/$RELEASE_ARCHIVE_NAME-latest.tgz --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=id=3a6e02b08553fd157ae3fb918945dd1eaae5a1aa818940381ef07a430cf25732
fi
