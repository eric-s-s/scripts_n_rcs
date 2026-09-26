#! /bin/bash

echo "missing config files=.config/pip/pip.conf .pypirc .aws/config"

[[ ! -d ~/old-dot-files ]] && mkdir ~/old-dot-files

cat home_files.txt | xargs -I{} mv ~/{} ~/old-dot-files
cat home_files.txt | xargs -I{} cp home-files/{} ~/

[[ ! -d ~/old-bin-files ]] && mkdir ~/old-bin-files

cat bin_files.txt | xargs -I{} mv ~/bin/{} ~/old-bin-files
cat bin_files.txt | xargs -I{} cp bin-files/{} ~/bin

[[ ! -d ~/old-systemd-files ]] && mkdir ~/old-systemd-files

cat omarch_systemd.txt | xargs -I{} mv ~/{} ~/old-systemd-files
cat omarch_systemd.txt | xargs -I{} cp  omarchy-systemd/{} ~/.config/systemd/user/ssh-agent.service 
