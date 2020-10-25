#!/bin/bash

set -o errexit

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 1>&2
   exit 1
fi

#Get the checkout directory
GIT_DIR="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"

#Get the owner of the checkout directory
GIT_OWNER="$(ls -ld "$GIT_DIR" | awk 'NR==1 {print $3}')"

cd "$(dirname "${BASH_SOURCE[0]}")/.."
repo_path="$PWD"


for service in systemd/*.service; do
	sed "s:/home/__USER__/ngrok-service:${repo_path}:g;s:__USER__:${GIT_OWNER}:g" "$service" \
	 > "/lib/systemd/system/$(basename "$service")"
done
