#! /bin/bash

echo "missing config files=.config/pip/pip.conf .pypirc .aws/config"


function mv-to-old-files-dir () {
  full_filename="$1"
  target_dir="$2"
  
  if [[ -e "$full_filename" ]]; then
    mv "$full_filename" "$target_dir"
  fi
}


mkdir -p ~/old-dot-files

for short_file_name in $(cat home_files.txt); do
  mv-to-old-files-dir "~/${short_file_name}" "~/old-dot-files/"
  cp "home-files/${short_file_name}" ~/
done


mkdir -p ~/old-bin-files

for short_file_name in $(cat bin_files.txt); do
  mv-to-old-files-dir "~/${short_file_name}" "~/old-bin-files/"
  cp "bin-files/${short_file_name}" ~/bin/
done

mkdir -p ~/old-systemd-files

for short_file_name in $(cat omarchy_systemd.txt); do
  systemd_dir="${HOME}/.config/systemd/user/"
  mv-to-old-files-dir "${systemd_dir}${short_file_name}" "${HOME}/old-systemd-files/"
  cp "omarchy-systemd/${short_file_name}" "${systemd_dir}"
done

