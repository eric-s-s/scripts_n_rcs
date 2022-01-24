sudo rm /home/eric.shaw/.GlobalProtect/*.dat

sudo systemctl restart gpd

echo "/opt/paloaltonetworks/globalprotect/globalprotect launch-ui --recover"
