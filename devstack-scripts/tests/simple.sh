source openrc admin admin


neutron security-group-create red_hub
neutron security-group-create red_spoke



neutron security-group-rule-create red_spoke --remote-group-id red_hub --direction ingress --ethertype IPv4
neutron security-group-rule-create red_spoke --remote-group-id red_hub --direction egress --ethertype IPv4

neutron security-group-rule-create red_hub --remote-group-id red_spoke --direction ingress --ethertype IPv4
neutron security-group-rule-create red_hub --remote-group-id red_spoke --direction egress --ethertype IPv4

neutron security-group-create blue
neutron security-group-rule-create blue --direction egress --ethertype IPv4
neutron security-group-rule-create blue --direction ingress --ethertype IPv4

neutron net-create net1
neutron subnet-create net1 10.1.1.0/24 --name sub1 --gateway 10.1.1.1 --dns-nameservers list=true 8.8.4.4 8.8.8.8

novaboot-control.sh net1 red_spoke 1 
novaboot-compute.sh net1 red_hub 1 
novaboot-compute.sh net1 red_spoke 2

novaboot-control.sh net1 blue 1
novaboot-compute.sh net1 blue 2

echo "control:"
nova list --host devstack-control
echo "compute:"
nova list --host devstack-compute-1

