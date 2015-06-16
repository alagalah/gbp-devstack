neutron security-group-create web_sg
neutron security-group-rule-create web_sg --direction ingress --protocol tcp --port-range-min 80 --port-range-max 80
neutron security-group-rule-create web_sg --direction egress --ethertype IPv4
neutron security-group-create secured_web_sg
neutron security-group-rule-create secured_web_sg --direction ingress --protocol tcp --port-range-min 443 --port-range-max 443
neutron security-group-rule-create secured_web_sg --direction egress --ethertype IPv4
neutron security-group-create client_sg
neutron security-group-rule-create client_sg --direction egress --protocol tcp --port-range-min 80 --port-range-max 80
neutron security-group-rule-create client_sg --direction egress --protocol tcp --port-range-min 443 --port-range-max 443
neutron security-group-rule-create client_sg --direction ingress --ethertype IPv4

neutron net-create net1
neutron subnet-create net1 10.1.1.0/24 --name sub1 --gateway 10.1.1.1
neutron net-create net2
neutron subnet-create net2 20.1.1.0/24 --name sub2 --gateway 20.1.1.1
neutron net-create net3
neutron subnet-create net3 30.1.1.0/24 --name sub3 --gateway 30.1.1.1
neutron net-create net4
neutron subnet-create net4 40.1.1.0/24 --name sub4 --gateway 40.1.1.1
neutron net-create net5
neutron subnet-create net5 50.1.1.0/24 --name sub5 --gateway 50.1.1.1

neutron router-create r1
neutron router-interface-add r1 sub1
neutron router-interface-add r1 sub2

resetcontroller.sh

testnovaboot-control.sh net1 client_sg 1 #"bekind"
testnovaboot-compute1.sh net1 web_sg 1
testnovaboot-control.sh net1 secured_web_sg 1

testnovaboot-compute1.sh net2 client_sg 2
testnovaboot-control.sh net2 web_sg 2
testnovaboot-compute1.sh net2 secured_web_sg 2 #"bekind"

neutron router-create r2
neutron router-interface-add r2 sub3
neutron router-interface-add r2 sub4
neutron router-interface-add r2 sub5

resetcontroller.sh

testnovaboot-compute1.sh net3 client_sg 3
testnovaboot-compute1.sh net3 client_sg 4

testnovaboot-control.sh net4 web_sg 3
testnovaboot-compute1.sh net4 secured_web_sg 3

testnovaboot-control.sh net5 web_sg 4
testnovaboot-control.sh net5 secured_web_sg 4

echo "control:"
nova list --host devstack-control
echo "compute:"
nova list --host devstack-compute-1
