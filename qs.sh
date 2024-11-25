#!/usr/bin/sh
# v0.01

#### Installing
# update and download apt
echo "\033[34m[!] Updating\033[0m"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update -y && sudo apt-get upgrade -y
echo "\033[34m[!] Installing CopyQ, Terminator Terminal and Sublime Gobuster \033[0m"
sudo apt-get install copyq terminator sublime-text gobuster seclists curl dnsrecon enum4linux feroxbuster gobuster impacket-scripts nbtscan nikto nmap onesixtyone oscanner redis-tools smbclient smbmap snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf nuclei

# autorecon
sudo apt install python3-venv -y
python3 -m pip install --user pipx --break-system-packages
python3 -m pipx ensurepath
pipx install git+https://github.com/Tib3rius/AutoRecon.git

# zsh
echo "\033[34m[!] Installing ZSH and Plugins \033[0m"
sh -c "$(wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
echo "\033[32m[+] ZSH Installed \033[0m" 
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/kali/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/kali/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
echo "plugins=(git zsh-syntax-highlighting zsh-autosuggestions )" >> /home/kali/.zshrc
echo "source /home/kali/.oh-my-zsh/oh-my-zsh.sh" >> /home/kali/.zshrc

# nerdfont
echo "\033[34m[!] Installing nerdfont \033[0m"
wget -q -P /home/kali/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip /home/kali/.local/share/fonts/JetBrainsMono.zip -d /home/kali/.local/share/fonts/
fc-cache -f /home/kali/.local/share/fonts/
echo "\033[32m[+] nerdfont installed \033[0m"

# go
echo "\033[34m[!] Installing Go \033[0m"
sh -c "(wget -q https://go.dev/dl/go1.23.3.linux-amd64.tar.gz -O /home/kali/Downloads/go1.23.3.linux-amd64.tar.gz)"
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf /home/kali/Downloads/go1.23.3.linux-amd64.tar.gz
export PATH="$PATH:/usr/local/go/bin"
echo "\033[32m[+] Go Installed and Path is set"

# catpuccin setting
echo "\033[34m[!] Installing Terminator catpuccin\033[0m"
mkdir /home/kali/.config/terminator
touch /home/kali/.config/terminator/config
sudo echo  '[global_config]' > /home/kali/.config/terminator/config
sudo echo  '[keybindings]' >> /home/kali/.config/terminator/config
sudo echo  '[profiles]' >> /home/kali/.config/terminator/config
sudo echo  '  [[default]]' >> /home/kali/.config/terminator/config
sudo echo  '    cursor_color = "#f5e0dc"' >> /home/kali/.config/terminator/config
sudo echo  '    background_color = "#1e1e2e"' >> /home/kali/.config/terminator/config
sudo echo  '    foreground_color = "#cdd6f4"' >> /home/kali/.config/terminator/config
sudo echo  '    background_darkness = 0.95' >> /home/kali/.config/terminator/config
sudo echo  '    background_type = transparent' >> /home/kali/.config/terminator/config
sudo echo  '    show_titlebar = False' >> /home/kali/.config/terminator/config
sudo echo  '    scrollback_infinite = True' >> /home/kali/.config/terminator/config
sudo echo  '    palette ="#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"' >> /home/kali/.config/terminator/config 
sudo echo  '    background_image = None' >> /home/kali/.config/terminator/config
sudo echo  '  [[Catppuccin_Latte]]' >> /home/kali/.config/terminator/config
sudo echo  '    cursor_color = "#dc8a78"' >> /home/kali/.config/terminator/config
sudo echo  '    background_color = "#eff1f5"' >> /home/kali/.config/terminator/config
sudo echo  '    foreground_color = "#4c4f69"' >> /home/kali/.config/terminator/config
sudo echo  '    palette ="#5c5f77:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#acb0be:#6c6f85:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#bcc0cc"' >> /home/kali/.config/terminator/config 
sudo echo  '    background_image = None' >> /home/kali/.config/terminator/config
sudo echo  '  [[Catppuccin_Frappe]]' >> /home/kali/.config/terminator/config
sudo echo  '    cursor_color = "#f2d5cf"' >> /home/kali/.config/terminator/config
sudo echo  '    background_color = "#303446"' >> /home/kali/.config/terminator/config
sudo echo  '    foreground_color = "#c6d0f5"' >> /home/kali/.config/terminator/config
sudo echo  '    palette ="#51576d:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#b5bfe2:#626880:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#a5adce"' >> /home/kali/.config/terminator/config 
sudo echo  '    background_image = None' >> /home/kali/.config/terminator/config
sudo echo  '  [[Catppuccin_Macchiato]]' >> /home/kali/.config/terminator/config
sudo echo  '    cursor_color = "#f4dbd6"' >> /home/kali/.config/terminator/config
sudo echo  '    background_color = "#24273a"' >> /home/kali/.config/terminator/config
sudo echo  '    foreground_color = "#cad3f5"' >> /home/kali/.config/terminator/config
sudo echo  '    palette ="#494d64:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#b8c0e0:#5b6078:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#a5adcb"' >> /home/kali/.config/terminator/config 
sudo echo  '    background_image = None' >> /home/kali/.config/terminator/config
sudo echo  '  [[Catppuccin_Mocha]]' >> /home/kali/.config/terminator/config
sudo echo  '    cursor_color = "#f5e0dc"' >> /home/kali/.config/terminator/config
sudo echo  '    background_color = "#1e1e2e"' >> /home/kali/.config/terminator/config
sudo echo  '    foreground_color = "#cdd6f4"' >> /home/kali/.config/terminator/config
sudo echo  '    palette ="#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"' >> /home/kali/.config/terminator/config 
sudo echo  '    background_image = None' >> /home/kali/.config/terminator/config
sudo echo  '[layouts]' >> /home/kali/.config/terminator/config
sudo echo  '  [[default]]' >> /home/kali/.config/terminator/config
sudo echo  '    [[[window0]]]' >> /home/kali/.config/terminator/config
sudo echo  '      type = Window' >> /home/kali/.config/terminator/config
sudo echo  '      parent = ""' >> /home/kali/.config/terminator/config
sudo echo  '    [[[child1]]]' >> /home/kali/.config/terminator/config
sudo echo  '      type = Terminal' >> /home/kali/.config/terminator/config
sudo echo  '      parent = window0' >> /home/kali/.config/terminator/config
sudo echo  '[plugins]' >> /home/kali/.config/terminator/config
echo "\033[32m[+] Terminator catpuccin set \033[0m"

# copyq
echo "\033[34m[!] Setting CopyQ \033[0m"
sudo touch /etc/systemd/system/copyq.service
sudo echo '[Unit]' > /etc/systemd/system/copyq.service
sudo echo 'Description=CopyQ Clipboard Manager' >> /etc/systemd/system/copyq.service
sudo echo 'Documentation=man:copyq(1)' >> /etc/systemd/system/copyq.service
sudo echo 'After=graphical.target' >> /etc/systemd/system/copyq.service
sudo echo '' >> /etc/systemd/system/copyq.service
sudo echo '[Service]' >> /etc/systemd/system/copyq.service
sudo echo 'ExecStart=/usr/bin/copyq' >> /etc/systemd/system/copyq.service
sudo echo 'Restart=always' >> /etc/systemd/system/copyq.service
sudo echo 'Environment=DISPLAY=:0' >> /etc/systemd/system/copyq.service
sudo echo 'Environment=XAUTHORITY=/home/kali/.Xauthority' >> /etc/systemd/system/copyq.service
sudo echo 'User=kali' >> /etc/systemd/system/copyq.service
sudo echo 'Group=kali' >> /etc/systemd/system/copyq.service
sudo echo '' >> /etc/systemd/system/copyq.service
sudo echo '[Install]' >> /etc/systemd/system/copyq.service
sudo echo 'WantedBy=default.target' >> /etc/systemd/system/copyq.service
sudo systemctl daemon-reload
sudo systemctl enable copyq.service
sudo systemctl start copyq.service
echo "\033[32m[+] CopyQ Finished Installing \033[0m"

# superfile
echo "\033[34m[!] Installing Superfile File Manager \033[0m"
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
echo "\033[32m[+] Superfile File Manager Installed \033[0m"

# alias and environment setup
echo "\033[34m[!] Setting Desktop Directories and alias \033[0m"
export PATH="/home/kali/.local/bin:$PATH"

mkdir /home/kali/Desktop/tool
mkdir /home/kali/Desktop/htb
mkdir /home/kali/Desktop/assessment

alias assessment="cd /home/kali/Desktop/assessment"
alias tool="cd /home/kali/Desktop/tool"
alias htb="cd /home/kali/Desktop/htb"
alias hosts="sudo nano /etc/hosts"

# Success
echo "\033[32m[+] Installation Successful! \033[0m"
