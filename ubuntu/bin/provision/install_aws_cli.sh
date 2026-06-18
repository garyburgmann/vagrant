#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl unzip

case "$(uname -m)" in
  x86_64)
    aws_arch="x86_64"
    ;;
  aarch64|arm64)
    aws_arch="aarch64"
    ;;
  *)
    echo "Unsupported architecture for AWS CLI v2 installer: $(uname -m)" >&2
    exit 1
    ;;
esac

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl -fsSLo "$tmp_dir/awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip"
unzip -q "$tmp_dir/awscliv2.zip" -d "$tmp_dir"
"$tmp_dir/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

aws --version
