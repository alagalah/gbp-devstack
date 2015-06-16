neutron security-group-create client_sg
neutron security-group-rule-create client_sg --direction egress --ethertype IPv4
neutron security-group-rule-create client_sg --direction ingress --ethertype IPv4


neutron net-create net1
neutron subnet-create net1 10.1.1.0/24 --name sub1 --gateway 10.1.1.1
neutron net-create net2
neutron subnet-create net2 20.1.1.0/24 --name sub2 --gateway 20.1.1.1
neutron net-create net3
neutron subnet-create net3 30.1.1.0/24 --name sub3 --gateway 30.1.1.1
neutron net-create net4
neutron subnet-create net4 40.1.1.0/24 --name sub4 --gateway 40.1.1.1

neutron router-create r1
neutron router-interface-add r1 sub1
neutron router-interface-add r1 sub2

novaboot.sh net1 client_sg 1 devstack-control

novaboot.sh net2 client_sg 2 devstack-control


neutron router-create r2
neutron router-interface-add r2 sub3
neutron router-interface-add r2 sub4

novaboot.sh net3 client_sg 3 devstack-control

novaboot.sh net4 client_sg 4 devstack-control


nova list
