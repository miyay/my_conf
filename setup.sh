echo "==================================="
echo "Start setup !!"
echo "==================================="


echo "------------------------"
echo "install byobu"
echo "------------------------"
sudo apt-get install byobu
#cp backend ~/.byobu/

echo "------------------------"
echo "setup bash"
echo "------------------------"
cp .bashrc ~/.bashrc
sudo mkdir -p /usr/local/git/contrib/completion
sudo cp git-completion.bash /usr/local/git/contrib/completion/
source ~/.bashrc

echo "------------------------"
echo "install ruby"
echo "------------------------"
sudo apt-get upgrade ruby


echo "------------------------"
echo "install git"
echo "------------------------"
sudo apt-get install git

echo "------------------------"
echo "install tig"
echo "------------------------"
sudo apt-get install tig

echo "------------------------"
echo "setup git"
echo "------------------------"
cp .gitconfig ~/.gitconfig
cp .ssh/* ~/.ssh
find ~/.ssh -type f -print | xargs chmod 700
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/known_hosts

echo "------------------------"
echo "install vim"
echo "------------------------"
sudo apt-get install vim

echo "------------------------"
echo "setup vim"
echo "------------------------"
cp .vimrc ~/.vimrc

echo "Please open spinner-vim-plugin.vba by vim."
echo "and :source %"


echo "==================================="
echo "Finish setup !!"
echo "==================================="
