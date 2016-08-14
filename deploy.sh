#!/bin/bash
set -e

AWS_REGION=${AWS_REGION:-ap-southeast-2}
BRANCH=${TRAVIS_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}

if [[ $BRANCH == 'master' ]]; then
  STAGE="prod"
elif [[ $BRANCH == 'develop' ]]; then
  STAGE="dev"
fi

if [ -z ${STAGE+x} ]; then
  echo "Not deploying changes";
  exit 0;
fi

echo "Deploying from branch $BRANCH to stage $STAGE"

if [ ! -f secrets.json ]; then
  echo "Cannot find secrets.json"
  exit 0;
fi

npm prune --production

sls-test deploy --stage $STAGE --region $AWS_REGION
