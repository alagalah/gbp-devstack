neutron security-group-create client_sg
neutron security-group-rule-create client_sg --direction egress --ethertype IPv4
neutron security-group-rule-create client_sg --direction ingress --ethertype IPv4

neutron security-group-create video_sg
neutron security-group-rule-create video_sg --direction egress --ethertype IPv4
neutron security-group-rule-create video_sg --direction ingress --ethertype IPv4

neutron security-group-create game_sg
neutron security-group-rule-create game_sg --direction egress --ethertype IPv4
neutron security-group-rule-create game_sg --direction ingress --ethertype IPv4


neutron net-create net1
neutron subnet-create net1 10.1.1.0/24 --name sub1 --gateway 10.1.1.1
neutron net-create net2
neutron subnet-create net2 20.1.1.0/24 --name sub2 --gateway 20.1.1.1
#neutron net-create net3
#neutron subnet-create net3 30.1.1.0/24 --name sub3 --gateway 30.1.1.1
#neutron net-create net4
#neutron subnet-create net4 40.1.1.0/24 --name sub4 --gateway 40.1.1.1
#neutron net-create net5
#neutron subnet-create net5 50.1.1.0/24 --name sub5 --gateway 50.1.1.1

neutron router-create r1
neutron router-interface-add r1 sub1
neutron router-interface-add r1 sub2
resetcontroller.sh

testnovaboot-control.sh net1 client_sg 1 #"bekind"
testnovaboot-compute.sh net1 video_sg 1
testnovaboot-compute.sh net1 game_sg 1

testnovaboot-control.sh net2 client_sg 2
testnovaboot-compute.sh net2 video_sg 2
testnovaboot-compute.sh net2 game_sg 2 #"bekind"

