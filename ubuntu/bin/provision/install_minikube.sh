#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y ca-certificates curl

arch="$(dpkg --print-architecture)"
case "$arch" in
  amd64|arm64|s390x)
    minikube_arch="$arch"
    ;;
  ppc64el)
    minikube_arch="ppc64le"
    ;;
  *)
    echo "Unsupported architecture for minikube Debian package: $arch" >&2
    exit 1
    ;;
esac

deb="/tmp/minikube_latest_${minikube_arch}.deb"
curl -fsSLo "$deb" "https://storage.googleapis.com/minikube/releases/latest/minikube_latest_${minikube_arch}.deb"
sudo dpkg -i "$deb"
rm -f "$deb"
