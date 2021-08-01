#!/usr/bin/env bash
sudo dnf update -y
sudo dnf install -y podman podman-docker podman-compose

systemctl --user enable --now podman.socket
