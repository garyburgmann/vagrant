export DEBIAN_FRONTEND=noninteractive
apt-get update
echo "upgrading system"
apt-get upgrade -y
apt-get autoremove -y
