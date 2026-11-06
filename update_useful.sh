#! /bin/bash

cat home_files.txt | xargs -I{} cp ~/{} home-files

while IFS= read -r config_file; do
  mkdir -p ".config/$(dirname "$config_file")"
  cp "${HOME}/.config/${config_file}" ".config/${config_file}"
done < special_config_files.txt

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

mkdir -p "$target_dir"
find "$hypr_config" -maxdepth 1 -type f \( -name '*.conf' -o -name '*.lua' \) -exec cp -p {} "$target_dir" \;
