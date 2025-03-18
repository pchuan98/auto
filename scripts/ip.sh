ip_address=$(curl -s cip.cc | grep -oP 'IP\s+:\s+\K\S+' | awk '{print $1}')
