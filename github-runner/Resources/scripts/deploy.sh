#!/bin/bash -xeu

GH_RUNNER_NAME="$1"
GH_REPO_URL="$2"
GH_TOKEN="$3"
GH_LABELS="$4"
GH_REPLACE="$5"

if [ "$GH_REPLACE" == "True" ]; then
  REPLACE_FLAG="--replace"
else
  REPLACE_FLAG=""
fi

DEFAULT_USER="ubuntu"

# Change to default home directory
cd /home/"${DEFAULT_USER}"

# Wait for auto updates to finish
while true; do
  sudo apt-get install -y -qq jq docker.io > /dev/null && break || echo "Waiting 10s for apt..."; sleep 10
done

# Create a folder
sudo -u "${DEFAULT_USER}" mkdir actions-runner && cd actions-runner

# Get latest github linux-x64 runner version tag
GH_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases | jq -r '.[] | .name' | sort -r | head -1 | cut -d 'v' -f 2)
GH_FILE="actions-runner-linux-x64-${GH_VERSION}.tar.gz"

# Download the latest runner package
sudo -u "${DEFAULT_USER}" curl -o "${GH_FILE}" -L "https://github.com/actions/runner/releases/download/v${GH_VERSION}/${GH_FILE}"

# Extract the installer
sudo -u "${DEFAULT_USER}" tar xzf ./"${GH_FILE}"

# Install and start service
sudo -u "${DEFAULT_USER}" ./config.sh \
  --unattended ${REPLACE_FLAG} \
  --name "${GH_RUNNER_NAME}" \
  --url "${GH_REPO_URL}" \
  --token "${GH_TOKEN}" \
  --labels "${GH_LABELS}"

sudo ./svc.sh install
sudo ./svc.sh start
