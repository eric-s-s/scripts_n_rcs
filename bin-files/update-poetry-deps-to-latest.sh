#! /bin/bash

get-version () {
    grep "$1 =" pyproject.toml | grep -oE "[0-9.]{2,}"
}

old_black="$(get-version "black")"
old_isort="$(get-version "isort")"
old_flake8="$(get-version "flake8")"

sed -n '/\[tool.poetry.dependencies\]/, /^$/{ /^\w/ p }' pyproject.toml | \
sed -e 's/ =.*/@latest/' | grep -v python | xargs poetry add

sed -n '/\[tool.poetry.dev-dependencies\]/, /^$/{ /^\w/ p }' pyproject.toml | \
sed -e 's/ =.*/@latest/' | grep -v python | xargs poetry add --dev

poetry update

new_black="$(get-version "black")"
new_isort="$(get-version "isort")"
new_flake8="$(get-version "flake8")"

sed -i "s/${old_black//./\\.}$/${new_black}/" .pre-commit-config.yaml
sed -i "s/${old_isort//./\\.}$/${new_isort}/" .pre-commit-config.yaml
sed -i "s/${old_flake8//./\\.}$/${new_flake8}/" .pre-commit-config.yaml
