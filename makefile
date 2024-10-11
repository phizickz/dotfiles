# Variables
STARTING_LOC := $(shell pwd)
STOW_DIR := $(HOME)/stow
TMUX_PLUGIN_DIR := $(HOME)/.tmux/plugins/tpm

# Detect operating system
OS := $(shell uname -s)

setup: install_deps install_tmux install_stow install_neovim
	rm -f nvim-linux64.tar.gz
	rm -f $(STOW_DIR)/stow-latest.tar.gz

install_deps:
ifeq ($(OS), Darwin)
else ifeq ($(OS), Linux)
	sudo apt install -y tar
endif

install_stow: install_perl
	mkdir -p $(STOW_DIR)
	wget https://gnuftp.uib.no/stow/stow-latest.tar.gz -P $(STOW_DIR)
	cd $(STOW_DIR)
	tar xzf stow-latest.tar.gz -C latest
	cd $(STOW_DIR)/latest
	./configure 
	make install
	cd $(STARTING_LOC)

install_tmux:
ifeq ($(OS), Darwin)
	brew install tmux
else ifeq ($(OS), Linux)
	sudo apt install -y tmux
endif
	@if [ ! -d $(TMUX_PLUGIN_DIR) ]; then \
		git clone https://github.com/tmux-plugins/tpm $(TMUX_PLUGIN_DIR); \
	fi

install_perl:
	curl -L http://xrl.us/installperlnix | bash


install_neovim:
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz

