declare -a tilde=(".vimrc" ".bashrc" ".bash_aliases" ".inputrc") 
for el in "${tilde[@]}"
do
    echo "in home $el"
    cp ~/$el ~/useful
done

declare -a bin_files=("startup.sh" "update_useful.sh")
for el in "${bin_files[@]}"
do
    echo "in bin $el"
    cp ~/bin/$el ~/useful
done
