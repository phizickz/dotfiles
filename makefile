# Variables
STARTING_LOC := $(shell pwd)
STOW_DIR := $(HOME)/stow
TMUX_PLUGIN_DIR := $(HOME)/.tmux/plugins/tpm

# Detect operating system
OS := $(shell uname -s)

setup: install_tmux install_neovim install_stow

install_stow: install_perl
ifeq ($(OS), Darwin)
	brew install wget
else ifeq ($(OS), Linux)
	sudo apt install -y tar
endif
	mkdir -p $(STOW_DIR)
	wget https://gnuftp.uib.no/stow/stow-latest.tar.gz -P $(STOW_DIR)
	tar xzf $(STOW_DIR)/stow-latest.tar.gz -C $(STOW_DIR)
	cd $(STOW_DIR); \
	XDIR=$$(find $(STOW_DIR) -maxdepth 1 -type d -name "stow-*" | head -n 1); \
	echo "xdir: $$XDIR"; \
	cp -r $$XDIR/* .; \
	sudo ./configure; \
	sudo make; \
	sudo make install
	rm -f $(STOW_DIR)/stow-latest.tar.gz

install_tmux:
ifeq ($(OS), Darwin)
	brew install tmux
else ifeq ($(OS), Linux)
	sudo apt install -y tmux
endif
	@if [ ! -d $(TMUX_PLUGIN_DIR) ]; then \
		git clone https://github.com/tmux-plugins/tpm $(TMUX_PLUGIN_DIR); \
		tmux source ~/.tmux.conf ; \
	fi

install_perl:
	curl -L http://xrl.us/installperlnix | bash

install_neovim:
ifeq ($(OS), Darwin)
else ifeq ($(OS), Linux)
	sudo apt install -y tar
endif
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	rm -f nvim-linux64.tar.gz

