#!/usr/bin/env bash
set -euo pipefail

arch="$(dpkg --print-architecture)"
case "$arch" in
  amd64)
    miniconda_installer="Miniconda3-py313_26.3.2-2-Linux-x86_64.sh"
    miniconda_sha256="2284bafb7863a23411b19874d216e237964d4b32dd9beb6807fa8b2d84570961"
    ;;
  arm64)
    miniconda_installer="Miniconda3-py313_26.3.2-2-Linux-aarch64.sh"
    miniconda_sha256="81a5e828724478a7a036027a74356ceff0206147d3b1243c8ba32e0cfa187967"
    ;;
  ppc64el)
    miniconda_installer="Miniconda3-latest-Linux-ppc64le.sh"
    miniconda_sha256="1a2eda0a9a52a4bd058abbe9de5bb2bc751fcd7904c4755deffdf938d6f4436e"
    ;;
  s390x)
    miniconda_installer="Miniconda3-latest-Linux-s390x.sh"
    miniconda_sha256="55c681937c27e13a8ed818d1fec182e623e0308fffc1b10605896dac15f90077"
    ;;
  *)
    echo "Unsupported architecture for Miniconda installer: $arch" >&2
    exit 1
    ;;
esac

installer="/tmp/miniconda.sh"
curl -fsSLo "$installer" "https://repo.anaconda.com/miniconda/${miniconda_installer}"
echo "${miniconda_sha256}  ${installer}" | sha256sum --check
chmod +x "$installer"
"$installer" -b -u -p "$HOME/miniconda3"
"$HOME/miniconda3/bin/conda" init
"$HOME/miniconda3/bin/conda" config --set auto_activate_base false
"$HOME/miniconda3/bin/conda" update conda -y
"$HOME/miniconda3/bin/conda" update --all -y
