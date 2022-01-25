declare -a tilde=(`cat home_files.txt`) 
for el in "${tilde[@]}"
do
    echo "in home $el"
    cp ~/$el . 
done

declare -a bin_files=(`cat bin_files.txt`)
for el in "${bin_files[@]}"
do
    echo "in bin $el"
    cp ~/bin/$el .
done

declare -a all_files=(`cat bin_files.txt home_files.txt`)

touch dr-repos.sh
chmod 774 dr-repos.sh
ls ~/dr_workspace/ | sed -e "s/\(.*\)/git clone git@github.com:datarobot\/\1.git/" > dr-repos.sh

# TODO check for files to be removed.  include this file
# TODO include bin_files.txt, home_files.txt, README.md use git rm?
