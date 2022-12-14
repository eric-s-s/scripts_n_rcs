if [[ "${1}" == "check" ]]; then
    ls -l ~/.cache/JetBrains/PyCharm2022.3/python_packages
elif [[ "${1}" == "clean" ]]; then
    rm ~/.cache/JetBrains/PyCharm2022.3/python_packages/packages_v2.json
else
    echo "call with 'clean' or 'check'"
fi




