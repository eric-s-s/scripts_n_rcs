#! /bin/bash

sed -n '/\[tool.poetry.dependencies\]/, /^$/{ /^\w/ p }' pyproject.toml | \
sed -e 's/ =.*/@latest/' | grep -v python | xargs poetry add

sed -n '/\[tool.poetry.dev-dependencies\]/, /^$/{ /^\w/ p }' pyproject.toml | \
sed -e 's/ =.*/@latest/' | grep -v python | xargs poetry add --dev

poetry update
