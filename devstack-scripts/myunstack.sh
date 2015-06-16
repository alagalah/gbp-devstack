./reallyunstack.sh --all
 rm -rf /opt/stack/horizon/openstack_dashboard/enabled/*gbp*.py
 sudo service rabbitmq-server restart
 sudo service mysql restart

