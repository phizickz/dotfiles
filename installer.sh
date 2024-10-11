#!/bin/zsh

STARTING_LOC=$(pwd)
case "$OSTYPE" in
	darwin*) brew install tar tmux ;;
	linux*) apt install -y tar tmux ;;
esac

#Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Install Perl
curl -L http://xrl.us/installperlnix | bash

#Install Stow
wget https://gnuftp.uib.no/stow/stow-latest.tar.gz -P ~/stow/
cd ~/stow
./configure
make install
cd $STARTING_LOC

#Install NeoVim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
