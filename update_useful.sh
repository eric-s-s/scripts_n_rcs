declare -a tilde=(`cat home_files.txt`) 
for el in "${tilde[@]}"
do
    echo "in home $el"
    cp ~/$el ~/scripts_n_rcs
done

declare -a bin_files=(`cat bin_files.txt`)
for el in "${bin_files[@]}"
do
    echo "in bin $el"
    cp ~/bin/$el ~/scripts_n_rcs
done
