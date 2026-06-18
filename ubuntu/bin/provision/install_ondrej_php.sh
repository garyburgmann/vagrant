#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C.UTF-8

apt-get update
apt-get install -y ca-certificates curl gpg software-properties-common

add-apt-repository -y ppa:ondrej/php
apt-get update

apt-cache policy php | sed -n '1,20p'
