#! /bin/bash

cat home_files.txt | xargs -I{} cp ~/{} home-files
cat omarchy_systemd.txt | xargs -I{} cp ~/.config/systemd/user/{} omarchy-systemd
cat omarchy_systemd_configs.txt | xargs -I{} cp ~/.config/environment.d/{} omarchy-systemd-configs

ls ~/bin | grep -v "\(jetbrains\|oc\)" | xargs -I{} cp ~/bin/{} bin-files


touch personal-repos.sh
chmod 774 personal-repos.sh
ls ~/workspace/ | sed -e "s/\(.*\)/git clone git@github.com:eric-s-s\/\1.git/" > personal-repos.sh


hypr_config="$HOME/.config/hypr/"
target_dir="$(dirname "$(readlink -f "$0")")/.config/hypr"

find "$hypr_config" -maxdepth 1 -type f \( -name '*.conf' -o -name '*.lua' \) -exec cp -p {} "$target_dir" \;

