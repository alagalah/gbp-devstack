echo;echo "Resetting quottas for tenant admin..."
source openrc admin admin
nova quota-update --instances -1 --cores -1 --ram -1 --fixed-ips -1 --floating-ips -1 --security-groups -1 --security-group-rules -1 --key-pairs -1 admin
nova quota-update --user admin --instances -1 --cores -1 --ram -1 --fixed-ips -1 --floating-ips -1 --security-groups -1 --security-group-rules -1 --key-pairs -1 admin

