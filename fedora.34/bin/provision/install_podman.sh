#!/usr/bin/env bash
sudo dnf update -y
sudo dnf install -y podman podman-compose

systemctl --user enable --now podman.socket
