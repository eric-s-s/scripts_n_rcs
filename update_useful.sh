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

# TODO check for files to be removed.  include this file
# TODO include bin_files.txt, home_files.txt, README.md use git rm?
