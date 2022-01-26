repository_name="$(git remote -v | head -1 | sed -e 's/.*github.com[\/:]\(.*git\).*/\1/')"
echo "${repository_name}"

git remote set-url origin git@github.com:${repository_name}

git remote -v

