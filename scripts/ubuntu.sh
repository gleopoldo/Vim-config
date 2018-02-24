#!/bin/bash

set -e

neovim_installation_path=~/.config/nvim
samples_dir=./samples

##################################
# Installing neovim dependencies #
##################################

echo -n "Installing dependencies... "
if [ -f ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
fi

sudo apt-get install python-software-properties xclip python-dev python-pip \
	             python3-dev python3-pip silversearcher-ag gnome-tweak-tool \
							 exuberant-ctags
echo "Done"

#################################
####### Installing neovim #######
#################################

echo -n "Preparing to install neovim... "
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
echo "Done"

echo -n "Linking configs to $neovim_installation_path... "
# creates the new directory if not exists
mkdir -p $neovim_installation_path
# force the linking, removing previous config files
ln -f $samples_dir/init.vim.sample $neovim_installation_path/init.vim
echo "Done"

#################################
### Installing neovim plugins ###
#################################

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
  ln -f $samples_dir/ctags.sample ~/.ctags
fi

#################################
#######  Installing tmux  #######
#################################

echo -n "Installing tmux... "
sudo apt-get install tmux

ln -f $samples_dir/tmux.conf.sample ~/.tmux.conf
echo "Done"

echo "Setup complete"
