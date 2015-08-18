source openrc admin admin

neutron security-group-create client_sg
#neutron security-group-rule-create client_sg --direction egress --protocol tcp --port-range-min 80 --port-range-max 80
neutron security-group-rule-create client_sg --direction ingress --ethertype IPv4
neutron security-group-rule-create client_sg --direction egress --ethertype IPv4
#neutron security-group-rule-delete `neutron security-group-rule-list | grep "| client_sg      | egress    | IPv4      | any           | any             |" | awk '{print $2}'`

neutron security-group-create web_sg
neutron security-group-rule-create web_sg --direction ingress --protocol tcp --port-range-min 80 --port-range-max 80
neutron security-group-rule-create web_sg --direction egress --ethertype IPv4

neutron security-group-create client2_sg
neutron security-group-rule-create client2_sg --direction egress --protocol tcp --port-range-min 80 --port-range-max 80
neutron security-group-rule-create client2_sg --direction ingress --ethertype IPv4
#neutron security-group-rule-delete `neutron security-group-rule-list | grep "| client2_sg      | egress    | IPv4      | any           | any             |" | awk '{print $2}'`

neutron net-create net1
neutron subnet-create net1 10.1.1.0/24 --name sub1 --gateway 10.1.1.1 --dns-nameservers list=true 8.8.4.4 8.8.8.8

novaboot-control.sh net1 client_sg 1 
novaboot-control.sh net1 web_sg 1 

echo "control:"
nova list --host devstack-control
echo "compute:"
nova list --host devstack-compute-1

