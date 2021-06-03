echo "preparing python"
# apt-get update
# apt-get install -y software-properties-common
# add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install -y python3-pip python3-venv
# apt-get install -y python3.7 python3.7-venv python3.7-doc
# apt-get install -y python3.8 python3.8-venv python3.8-doc
# apt-get install -y python3.9 python3.9-venv python3.9-doc
# ln -s $(which python3.9) /usr/local/bin/python
ln -s $(which python3) /usr/local/bin/python
ln -s $(which pip3) /usr/local/bin/pip
