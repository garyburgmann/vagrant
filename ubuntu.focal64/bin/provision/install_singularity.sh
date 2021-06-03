echo "preparing singularity"
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    pkg-config
export VERSION=1.16.4 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export GOPATH=${HOME}/go' >> $HOME/.profile && \
    echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> $HOME/.profile && \
    source $HOME/.profile
go get -u github.com/golang/dep/cmd/dep
