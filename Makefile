# Variables definition
ZSH_CUSTOM = ${HOME}/.oh-my-zsh/custom

default: all

all: uninstall

install: install-prerequisites install-prettier install-cargo install-bat install-tokei install-fdfind install-kitty install-nvim install-tmux install-tmux-tpm install-fzf install-oh-my-zsh install-powerlevel10k install-oh-my-zsh-plugins

install-macos: install-prerequisites-macos install-delta-brew install-prettier install-cargo install-bat install-tokei install-fdfind install-nvim-brew install-tmux-brew install-tmux-tpm install-fzf-brew install-oh-my-zsh install-powerlevel10k install-oh-my-zsh-plugins

install-configs:
	./installer.sh

install-prerequisites-macos:
	brew install libtool pkg-config automake ripgrep python3 xclip npm nmap dnsmap gucharmap tree stow wget ninja cmake gettext curl gh
	brew install --cask raycast ghostty scroll-reverser

install-prerequisites:
	@sudo apt-get install -y autotools-dev automake zsh ripgrep xclip python3 pip flameshot curl npm fuse pavucontrol net-tools network-manager network-manager-gnome xbacklight arandr gucharmap pulseaudio-utils tree stow
	@pip3 install virtualenv

install-prettier:
	@sudo npm install -g prettier

install-fdfind:
	@cargo install fd-find

install-delta-brew:
	brew install git-delta

install-delta:
	@sudo snap install git-delta-snap

install-nitrogen:
	@sudo apt-get install nitrogen

install-polybar:
	@sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libcurl4-openssl-dev libmpdclient-dev libiw-dev libpulse-dev libjsoncpp-dev libnl-genl-3-dev libcurlpp-dev libxcb-image0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev wireless-tools
	@git clone https://github.com/polybar/polybar.git ~/polybar

install-fonts-macos:
	cp ~/.dotfiles/fonts/.fonts/* ~/Library/Fonts/

install-fonts:
	@fc-cache -fv

install-fzf-clone:
	@git clone https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

install-fzf:
	@sudo apt-get install fzf -y

install-fzf-brew:
	brew install fzf

install-oh-my-zsh-plugins:
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM}/plugins/zsh-you-should-use
	git clone https://github.com/MichaelAquilina/zsh-auto-notify.git ${ZSH_CUSTOM}/plugins/auto-notify

install-oh-my-zsh:
	wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	sh install.sh
	rm install.sh

install-rofi-theme-selector:
	@git clone https://github.com/lr-tech/rofi-themes-collection.git

install-rofi:
	sudo apt-get install rofi

#Not working in Makefiles, execute directly in shell
install-i3:
	@/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
	@sudo apt install ./keyring.deb
	echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
	@sudo apt update
	@sudo apt install i3 i3-wm i3lock i3lock-fancy xss-lock picom lxappearance gtk-chtheme lxqt-config
	@pip install autotiling

install-bat:
	@cargo install --locked bat

install-tokei:
	@cargo install tokei

install-cargo:
	curl https://sh.rustup.rs -sSf | sh

install-kitty:
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	sudo ln -sf ~/.local/kitty.app/bin/kitty /usr/bin
	sudo ln -sf ~/.local/kitty.app/bin/kitten /usr/bin
	sudo cp ~/.local/kitty.app/share/applications/kitty* /usr/share/applications/
	sudo sed -i "s|Icon=kitty|Icon=/home/$$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" /usr/share/applications/kitty*.desktop
	sudo sed -i "s|Exec=kitty|Exec=/home/$$USER/.local/kitty.app/bin/kitty|g" /usr/share/applications/kitty*.desktop

install-nodejs:
	@mkdir -p ~/.nvm
	@curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	@nvm install --lts
	@nvm use --lts

install-powerlevel10k:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

install-nvim-brew:
	brew install nvim

install-nvim:
	git clone https://github.com/neovim/neovim.git ~/neovim
	make -C ~/neovim CMAKE_BUILD_TYPE=Release
	echo "Execute sudo make install or move manually from ~/neovim"

install-tmux-brew:
	brew install tmux

install-tmux:
	@sudo apt-get install tmux
	@git clone https://github.com/tmux/tmux.git ~/tmux
	@cd ~/tmux && git checkout 3.3a && sh autogen.sh && ./configure && make
	@sudo cp ~/tmux/tmux /usr/bin/tmux
	@rm -rf ~/tmux

install-tmux-tpm:
	@git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

uninstall:
	@./clean-env.sh
	@rm -rf ~/.local/share/nvim
	@rm -rf ~/.tmux/
