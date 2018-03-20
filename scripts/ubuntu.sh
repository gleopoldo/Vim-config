#!/bin/bash

set -e

neovim_installation_path=~/.config/nvim
samples_dir=./samples
fzf_dir=~/.fzf

echo_red () {
  echo -en "\033[0;31m$1\033[0m"
}

##################################
# Installing neovim dependencies #
##################################

echo_red "Installing dependencies... "
{
  if [ -f ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $fzf_dir; $fzf_dir/install
  fi

  sudo apt-get install -y python-software-properties xclip python-dev python-pip \
                 python3-dev python3-pip silversearcher-ag gnome-tweak-tool \
                 exuberant-ctags
} > /dev/null
echo "Done"

#################################
####### Installing neovim #######
#################################

echo_red "Preparing to install neovim... "
{
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install -y neovim 
} > /dev/null
echo "Done"

echo_red "Creating nvim config path at $neovim_installation_path... "
# creates the new directory if not exists
mkdir -p $neovim_installation_path
echo "Done"

#################################
#######  Installing tmux  #######
#################################

echo_red "Installing tmux... "
sudo apt-get install -y tmux > /dev/null
echo "Done"

#################################
### Installing neovim plugins ###
#################################

echo_red "Installing plug deps... "
{
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  nvim "+PlugInstall | :qall"
} > /dev/null
echo "Done"

if ! $(grep nvim ~/.zshrc &> /dev/null); then
  echo "alias nv='nvim'" >> ~/.zshrc
else
  echo "Already found aliases... skipping... "
fi

echo_red "Linking configuration files... "
# force the linking, removing previous config files
ln -f $samples_dir/ctags.sample ~/.ctags
ln -f $samples_dir/init.vim.sample $neovim_installation_path/init.vim
ln -f $samples_dir/tmux.conf.sample ~/.tmux.conf
echo "Done"

echo_red "Setup complete"
