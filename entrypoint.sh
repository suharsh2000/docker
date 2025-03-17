#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo "Error: Azure DevOps organization URL is required."
  exit 1
fi

echo "1. Configuring Azure DevOps Agent..."

./config.sh --unattended \
            --url $AZP_URL \
            --auth pat \
            --token $AZP_TOKEN \
            --pool Default \
            --agent $(hostname) \
            --replace \
            --acceptTeeEula

echo "2. Starting Agent..."
./run.sh
