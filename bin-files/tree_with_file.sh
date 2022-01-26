output="\""
filename="${1}"
while read -r line; do
    line="$(echo ${line} | tr -d '/')"
    if [[ -n "${line}" ]] && [[ "${line}" != \#* ]];then
        output="${output}${line}|"
    fi

done < "${filename}"

ignore="${output::-1}\""
echo $ignore
tree -I $ignore


