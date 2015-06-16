keystone tenant-list
keystone tenant-create --name demo2
keystone user-create --name demo2 --pass admin --tenant demo2
keystone user-role-add --user demo2 --tenant=demo2 --role admin
keystone user-get demo2
keystone tenant-list



neutron security-group-create demo2_client_sg
neutron security-group-rule-create demo2_client_sg --direction egress --ethertype IPv4
neutron security-group-rule-create demo2_client_sg --direction ingress --ethertype IPv4


neutron net-create demo2_net1
neutron subnet-create demo2_net1 10.2.2.0/24 --name demo2_sub1 --gateway 10.2.2.1
neutron net-create demo2_net2
neutron subnet-create demo2_net2 20.2.2.0/24 --name demo2_sub2 --gateway 20.2.2.1

neutron router-create r2
neutron router-interface-add r2 demo2_sub1
neutron router-interface-add r2 demo2_sub2

novaboot.sh demo2_net1 demo2_client_sg 1 devstack-control
novaboot.sh demo2_net2 demo2_client_sg 2 devstack-control


nova list

