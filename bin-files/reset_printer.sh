function printer_ip {
    nmap -sn 192.168.1.0/24 | grep HP | sed -e 's/\(.*\)(\([^)]*\).*/\2/'
}


addr=$(printer_ip)

echo "address at ${addr}"


lpadmin -x downstairs

lpadmin -p downstairs -E -v ipp://$addr/ipp/print -m drv:///hpcups.drv/hp-deskjet_2540_series.ppd


