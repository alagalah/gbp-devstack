ip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | grep 192.168.50`
IFS=. read ip1 ip2 ip3 ip4 <<< "$ip"
hex=`echo "obase=16; $ip4" | bc`
dpid=$(printf %016g $hex)

sudo ovs-vsctl add-br br-int 
#sudo ovs-vsctl set bridge br-int other-config:datapath-id=$dpid
#sudo ovs-vsctl show

