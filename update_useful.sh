
cat home_files.txt | xargs -I{} cp ~/{} home-files
cat omarchy_systemd.txt | xargs -I{} cp ~/.config/systemd/user/{} omarchy-systemd

ls ~/bin | grep -v "\(jetbrains\|oc\)" | xargs -I{} cp ~/bin/{} bin-files


touch personal-repos.sh
chmod 774 personal-repos.sh
ls ~/workspace/ | sed -e "s/\(.*\)/git clone git@github.com:eric-s-s\/\1.git/" > personal-repos.sh

