# echo "preparing anaconda"
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /tmp/conda.sh
sudo chmod +x /tmp/conda.sh
/tmp/conda.sh -b -u -p $HOME/anaconda3
$HOME/anaconda3/bin/conda init
$HOME/anaconda3/bin/conda config --set auto_activate_base false
$HOME/anaconda3/bin/conda update conda
$HOME/anaconda3/bin/conda update --all
