#! /bin/bash

echo "missing config files=.config/pip/pip.conf .pypirc .aws/config"


function mv-to-old-files-dir () {
  full_filename="$1"
  target_dir="$2"
  
  if [[ -e "$full_filename" ]]; then
    mv "$full_filename" "$target_dir"
  fi
}


mkdir -p "${HOME}/old-dot-files"

while IFS= read -r short_file_name; do
  mv-to-old-files-dir "${HOME}/${short_file_name}" "${HOME}/old-dot-files/"
  cp "home-files/${short_file_name}" "${HOME}/"
done < home_files.txt


mkdir -p "${HOME}/old-bin-files"

while IFS= read -r short_file_name; do
  mv-to-old-files-dir "${HOME}/${short_file_name}" "${HOME}/old-bin-files/"
  cp "bin-files/${short_file_name}" "${HOME}/bin/"
done < bin_files.txt

# Every file under the repo .config tree, with its path relative to .config
while IFS= read -r config_file; do
  rel_dir="$(dirname "$config_file")"
  config_dir="${HOME}/.config/${rel_dir}"
  old_dir="${HOME}/old-config/${rel_dir}"
  mkdir -p "$config_dir" "$old_dir"
  mv-to-old-files-dir "${HOME}/.config/${config_file}" "${old_dir}/"
  cp ".config/${config_file}" "${config_dir}/"
done < <(find .config -type f -printf '%P\n')
