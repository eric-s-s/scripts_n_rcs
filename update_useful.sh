#! /bin/bash

cat home_files.txt | xargs -I{} cp ~/{} home-files
cat omarchy_systemd.txt | xargs -I{} cp ~/.config/systemd/user/{} omarchy-systemd
cat omarchy_systemd_configs.txt | xargs -I{} cp ~/.config/environment.d/{} omarchy-systemd-configs

for file in ~/bin/*; do
  [[ -f "$file" ]] || continue
  case "${file##*/}" in
    *jetbrains*|*oc*) continue ;;
  esac
  cp "$file" bin-files
done


touch personal-repos.sh
chmod 774 personal-repos.sh
for repo in ~/workspace/*/; do
  repo="${repo%/}"
  echo "git clone git@github.com:eric-s-s/${repo##*/}.git"
done > personal-repos.sh


hypr_config="$HOME/.config/hypr/"
target_dir="$(dirname "$(readlink -f "$0")")/.config/hypr"

find "$hypr_config" -maxdepth 1 -type f \( -name '*.conf' -o -name '*.lua' \) -exec cp -p {} "$target_dir" \;


nvim_plugins_dir="$HOME/.config/nvim/lua/plugins/"
nvim_target_dir="$(dirname "$(readlink -f "$0")")/.config/nvim/lua/plugins"
mkdir -p "$nvim_target_dir"
cat nvim_plugin_files.txt | xargs -I{} cp "${nvim_plugins_dir}"{} "$nvim_target_dir"
