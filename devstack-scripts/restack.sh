./unstack.sh --all

 sudo service rabbitmq-server restart
 sudo service mysql restart

sudo ovs-vsctl set-manager tcp:192.168.50.1:6640
sudo ovs-vsctl add-br br-int
sudo ovs-vsctl set-controller tcp:192.168.50.1:6653

time ./stack.sh
echo "Finished stacking at: "; date
