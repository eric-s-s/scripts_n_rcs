
cat home_files.txt | xargs -I{} cp ~/{} home-files
cat bin_files.txt | xargs -I{} cp ~/{} bin-files


touch dr-repos.sh
chmod 774 dr-repos.sh
ls ~/dr_workspace/ | sed -e "s/\(.*\)/git clone git@github.com:datarobot\/\1.git/" > dr-repos.sh

