#! /bin/bash

[[ ! -d ~/old-dot-files ]] && mkdir ~/old-dot-files

cat home_files.txt | xargs -I{} mv ~/{} ~/old-dot-files
cat home_files.txt | xargs -I{} cp home-files/{} ~/

[[ ! -d ~/old-bin-files ]] && mkdir ~/old-bin-files

cat bin_files.txt | xargs -I{} mv ~/bin/{} ~/old-bin-files
cat bin_files.txt | xargs -I{} cp bin-files/{} ~/bin

