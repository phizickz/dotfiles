# Variables
STARTING_LOC := $(shell pwd)
STOW_DIR := $(HOME)/stow
TMUX_PLUGIN_DIR := $(HOME)/.tmux/plugins/tpm

# Detect operating system
OS := $(shell uname -s)

install: install_tmux_plugin_manager install_perl install_stow install_neovim
	rm -f nvim-linux64.tar.gz

install_deps:
ifeq ($(OS), Darwin)
	brew install tar 
else ifeq ($(OS), Linux)
	sudo apt install -y tar
endif

install_stow: $(STOW_DIR)/stow-latest.tar.gz
	cd $(STOW_DIR) && ./configure && make install
	cd $(STARTING_LOC)

$(STOW_DIR)/stow-latest.tar.gz: install_deps
	mkdir -p $(STOW_DIR)
	wget https://gnuftp.uib.no/stow/stow-latest.tar.gz -P $(STOW_DIR)
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

