
setup:
	# Install fuzzy-finder external libraries
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
	# Install python deps, xclip and silver-searcher
	sudo apt-get install python-software-properties xclip python-dev python-pip \
		             python3-dev python3-pip silversearcher-ag
	# update with neovim ubuntu PPA
	sudo add-apt-repository ppa:neovim-ppa/stable
	sudo apt-get update
	sudo apt-get install neovim
	# setup local config dir
	mkdir ~/.config/nvim
	cp ./init.vim.sample ~/.config/nvim/init.vim
	# install plug-vim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# setup dependencies
	nvim +PlugInstall
