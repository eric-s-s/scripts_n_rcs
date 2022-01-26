pip_conf=".pip/pip.conf"
not_pip_conf=".pip/not.pip.conf"
if [[ -e "${HOME}/${pip_conf}" ]]; then
    mv "${HOME}/${pip_conf}" "${HOME}/${not_pip_conf}";
    echo "deactivate pip conf";
else 
    mv "${HOME}/${not_pip_conf}" "${HOME}/${pip_conf}";
    echo "activate pip_conf";
fi

