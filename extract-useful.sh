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

mkdir -p "${HOME}/old-systemd-files"

while IFS= read -r short_file_name; do
  systemd_dir="${HOME}/.config/systemd/user/"
  mv-to-old-files-dir "${systemd_dir}${short_file_name}" "${HOME}/old-systemd-files/"
  cp "omarchy-systemd/${short_file_name}" "${systemd_dir}"
done < omarchy_systemd.txt

