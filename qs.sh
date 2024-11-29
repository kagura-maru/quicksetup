#!/usr/bin/sh
# v0.05

preparation () {
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update -y && sudo apt-get upgrade -y
	sudo apt remove needrestart
	echo "\033[34m[!] Installing CopyQ, Terminator Terminal and Sublime Gobuster \033[0m"
	sudo apt-get install copyq terminator sublime-text gobuster seclists curl dnsrecon enum4linux feroxbuster gobuster impacket-scripts nbtscan nikto nmap onesixtyone oscanner redis-tools smbclient smbmap snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf nuclei python3-venv locate --fix-missing -y
}

autorecon_installation () {
	python3 -m pip install --user pipx --break-system-packages
	python3 -m pipx ensurepath
	pipx install git+https://github.com/Tib3rius/AutoRecon.git
	ATRO="\033[32m[+] AutoRecon has been installed. \033[0m"
	echo $ATRO
}

zsh_installation() {
	if [ ! -f '/home/kali/.zshrc' ]; then	
		echo "\033[34m[!] Installing ZSH and Plugins \033[0m"
		sh -c "$(wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
		git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		echo "plugins=(git zsh-syntax-highlighting zsh-autosuggestions )" >> $HOME/.zshrc
		echo "source $HOME/.oh-my-zsh/oh-my-zsh.sh" >> $HOME/.zshrc
		ZSHO="\033[32m[+] ZSH has been installed. \033[0m" 
		echo $ZSHO
	else
		ZSHO="\033[34m[!] ZSH is already installed.\033[0m"
		echo $ZSHO
	fi
}

nerdfont_installation() {
	if [ ! -f "/home/kali/.local/share/fonts/JetBrainsMonoNerdFont-Medium.ttf" ]; then	
		echo "\033[34m[!] Installing nerdfont \033[0m"
		wget -q -P /home/kali/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
		unzip /home/kali/.local/share/fonts/JetBrainsMono.zip -d /home/kali/.local/share/fonts/
		fc-cache -f /home/kali/.local/share/fonts/
		NFO="\033[32m[+] NerdFont has been installed \033[0m"
		echo $NFO
	else
		NFO="\033[34m[!] NerdFont is already installed.\033[0m"
		echo $NFO
	fi
}

go_installation () {
	echo "\033[34m[!] Installing Go \033[0m"
	sh -c "(wget -q https://go.dev/dl/go1.23.3.linux-amd64.tar.gz -O $HOME/Downloads/go1.23.3.linux-amd64.tar.gz)"
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $HOME/Downloads/go1.23.3.linux-amd64.tar.gz
	export PATH="$PATH:/home/kali/go/bin"
	GOO="\033[32m[+] Go has been installed and path has been set"
	echo $GOO
}

catpuccin_installation () {
	terminator_config=".config/terminator/config"
	echo "\033[34m[!] Installing Terminator catpuccin\033[0m"
	mkdir $HOME/.config/terminator
	touch $HOME/$terminator_config
	cp $HOME/$terminator_config $HOME/$terminator_config.bak
	echo  '[global_config]' > $HOME/$terminator_config
	echo  '[keybindings]' >> $HOME/$terminator_config
	echo  '[profiles]' >> $HOME/$terminator_config
	echo  '  [[default]]' >> $HOME/$terminator_config
	echo  '    cursor_color = "#f5e0dc"' >> $HOME/$terminator_config
	echo  '    background_color = "#1e1e2e"' >> $HOME/$terminator_config
	echo  '    foreground_color = "#cdd6f4"' >> $HOME/$terminator_config
	echo  '    background_darkness = 0.95' >> $HOME/$terminator_config
	echo  '    background_type = transparent' >> $HOME/$terminator_config
	echo  '    show_titlebar = False' >> $HOME/$terminator_config
	echo  '    scrollback_infinite = True' >> $HOME/$terminator_config
	echo  '    palette = "#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"' >> $HOME/$terminator_config 
	echo  '    background_image = None' >> $HOME/$terminator_config
	echo  '  [[Catppuccin_Latte]]' >> $HOME/$terminator_config
	echo  '    cursor_color = "#dc8a78"' >> $HOME/$terminator_config
	echo  '    background_color = "#eff1f5"' >> $HOME/$terminator_config
	echo  '    foreground_color = "#4c4f69"' >> $HOME/$terminator_config
	echo  '    palette = "#5c5f77:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#acb0be:#6c6f85:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#bcc0cc"' >> $HOME/$terminator_config 
	echo  '    background_image = None' >> $HOME/$terminator_config
	echo  '  [[Catppuccin_Frappe]]' >> $HOME/$terminator_config
	echo  '    cursor_color = "#f2d5cf"' >> $HOME/$terminator_config
	echo  '    background_color = "#303446"' >> $HOME/$terminator_config
	echo  '    foreground_color = "#c6d0f5"' >> $HOME/$terminator_config
	echo  '    palette = "#51576d:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#b5bfe2:#626880:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#a5adce"' >> $HOME/$terminator_config 
	echo  '    background_image = None' >> $HOME/$terminator_config
	echo  '  [[Catppuccin_Macchiato]]' >> $HOME/$terminator_config
	echo  '    cursor_color = "#f4dbd6"' >> $HOME/$terminator_config
	echo  '    background_color = "#24273a"' >> $HOME/$terminator_config
	echo  '    foreground_color = "#cad3f5"' >> $HOME/$terminator_config
	echo  '    palette = "#494d64:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#b8c0e0:#5b6078:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#a5adcb"' >> $HOME/$terminator_config 
	echo  '    background_image = None' >> $HOME/$terminator_config
	echo  '  [[Catppuccin_Mocha]]' >> $HOME/$terminator_config
	echo  '    cursor_color = "#f5e0dc"' >> $HOME/$terminator_config
	echo  '    background_color = "#1e1e2e"' >> $HOME/$terminator_config
	echo  '    foreground_color = "#cdd6f4"' >> $HOME/$terminator_config
	echo  '    palette = "#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"' >> $HOME/$terminator_config 
	echo  '    background_image = None' >> $HOME/$terminator_config
	echo  '[layouts]' >> $HOME/$terminator_config
	echo  '  [[default]]' >> $HOME/$terminator_config
	echo  '    [[[window0]]]' >> $HOME/$terminator_config
	echo  '      type = Window' >> $HOME/$terminator_config
	echo  '      parent = ""' >> $HOME/$terminator_config
	echo  '    [[[child1]]]' >> $HOME/$terminator_config
	echo  '      type = Terminal' >> $HOME/$terminator_config
	echo  '      parent = window0' >> $HOME/$terminator_config
	echo  '[plugins]' >> $HOME/$terminator_config
	CTO="\033[32m[+] Catpuccin Theme has been set. \033[0m"
	echo $CTO
}

copyq_installation () {
	copyq_service="/etc/systemd/system/copyq.service"
	echo "\033[34m[!] Setting CopyQ \033[0m"
	sudo touch $copyq_service
	sudo chmod 777 $copyq_service
	sudo echo '[Unit]' > $copyq_service
	sudo echo 'Description=CopyQ Clipboard Manager' >> $copyq_service
	sudo echo 'Documentation=man:copyq(1)' >> $copyq_service
	sudo echo 'After=graphical.target' >> $copyq_service
	sudo echo '' >> $copyq_service
	sudo echo '[Service]' >> $copyq_service
	sudo echo 'ExecStart=/usr/bin/copyq' >> $copyq_service
	sudo echo 'Restart=always' >> $copyq_service
	sudo echo 'Environment=DISPLAY=:0' >> $copyq_service
	sudo echo 'Environment=XAUTHORITY=$HOME/.Xauthority' >> $copyq_service
	sudo echo 'User=kali' >> $copyq_service
	sudo echo 'Group=kali' >> $copyq_service
	sudo echo '' >> $copyq_service
	sudo echo '[Install]' >> $copyq_service
	sudo echo 'WantedBy=default.target' >> $copyq_service
	sudo chmod 755 $copyq_service
	sudo systemctl daemon-reload
	sudo systemctl enable copyq.service
	sudo systemctl start copyq.service
	CO="\033[32m[+] CopyQ has been installed. \033[0m"
	echo $CO
}

# superfile
superfile_installation () {
	echo "\033[34m[!] Installing Superfile File Manager \033[0m"
	bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
	SPFO="\033[32m[+] Superfile File Manager Installed \033[0m"
	echo $SPFO
}

alias_environment_installation () {
	echo "\033[34m[!] Setting Desktop Directories and alias \033[0m"
	export PATH="/home/kali/.local/bin:$PATH"

	mkdir $HOME/Desktop/tool
	mkdir $HOME/Desktop/htb
	mkdir $HOME/Desktop/assessment

	alias assessment="cd $HOME/Desktop/assessment" >> /.zshrc
	alias tool="cd $HOME/Desktop/tool" >> /.zshrc
	alias htb="cd $HOME/Desktop/htb" >> /.zshrc
	alias hosts="sudo nano /etc/hosts" >> /.zshrc
 	alias mpd='mousepad' >> /.zshrc
  	alias up="echo ''; pwd; ls -la .; echo ''; (ip -br -4 a | grep -E 'UP|UNKNOWN') grep -v 'lo'; python -m http.server" >> /.zshrc
}

main () {
	echo "\033[34m[!] Updating\033[0m"
	
	preparation
 	sudo updatedb
	autorecon_installation
	zsh_installation
	nerdfont_installation
	go_installation
	catpuccin_installation
	copyq_installation
	superfile_installation
	alias_environment_installation

	echo '\n'
	echo $ATRO
	echo $ZSHO
	echo $NFO
	echo $GOO
	echo $CTO
	echo $CO
	echo $SPFO
	echo "\033[32m[+] Alias has been set \033[0m"
	echo "\033[32m[+] Installation Successful! \033[0m"
}

main
