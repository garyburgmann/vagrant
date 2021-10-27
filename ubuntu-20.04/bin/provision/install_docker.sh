echo "preparing docker"
apt-get update && apt-get install -y curl
curl -fsSL https://get.docker.com | bash
usermod -aG docker vagrant
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
