#!/bin/bash

# Receives GitHub repository information and token as environment variables.
# These values are passed from the docker-compose.yml file.
GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN

# Configure GitHub Actions runner
./config.sh --url "https://github.com/${GH_OWNER}/${GH_REPOSITORY}" --token "${GH_TOKEN}" --unattended --replace --name "docker-runner-$(hostname)"

# Run the runner
./run.sh