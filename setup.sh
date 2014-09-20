echo "==============================="
echo "Start setup"

echo "--------------------"
echo "setup git"
sudo apt-get install git
sudo apt-get install tig

echo "--------------------"
echo "setup byobu and bash"
sudo apt-get install byobu
mv ~/.bashrc ~/.bashrc.old
cp .bashrc ~/.bashrc

sudo mkdir -p /usr/local/git/contrib/completion
sudo wget -O /usr/local/git/contrib/completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "--------------------"
echo "setup vim"
sudo apt-get install vim
cp .vimrc ~/.vimrc
wget http://spinner-vim-plugin.googlecode.com/files/spinner-vim-plugin.vba

echo "--------------------"
echo Please open by vim: spinner-vim-plugin.vba
echo and :source %

echo "==============================="
echo "Finish setup"
