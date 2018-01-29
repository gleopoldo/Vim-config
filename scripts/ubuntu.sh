#!/bin/bash

set -e

installation_path=~/.config/nvim

echo -n "Installing dependencies... "
if [ -f ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
fi

sudo apt-get install python-software-properties xclip python-dev python-pip \
	             python3-dev python3-pip silversearcher-ag gnome-tweak-tool \
							 exuberant-ctags
echo "Done"

echo -n "Preparing to install neovim... "
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
echo "Done"


echo -n "Linking configs to $installation_path... "
# creates the new directory if not exists
mkdir -p $installation_path
# force the linking, removing previous config files
ln -f ./init.vim.sample $installation_path/init.vim
echo "Done"

echo -n "Installing plug deps... "
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim "+PlugInstall | :qall"
echo "Done"

if ! $(grep nvim ~/.zshrc &> /dev/null); then
  echo "alias nv='nvim'" >> ~/.zshrc
else
  echo -n "already found aliases... skipping... "
fi

if ! $(grep markdown ~/.zshrc &> /dev/null); then
  cat .ctags.sample >> ~/.ctags
fi

echo "Setup complete"
