devstack-nodes
==============

This repo provides a Vagrantfile with provisioning that one can use to easily
get a cluster of nodes configured with DevStack.

It is a fork of the wonderful work of Mr Flavio Fernandes

Usage
-----

1) Run VMs::
    
    A Vagrantfile is provided to easily create a DevStack environment to test with. To save
    performance, it is sufficient to run all the required services just on one VM. This VM is
    identified as control node. Other VMs are compute nodes. First, set number of compute nodes
    desired by setting:
    
        'DEVSTACK_NUM_COMPUTE_NODES=1'
    
    #Note: Only 3 or less nodes are supported today
    Next, execute:
    
        vagrant up
    
    If no VMs have been generated yet, they will be now.
    
1) Assign local.conf files::

    Compute or control roles can be set up for each VM in local.conf by ODL_MODE element.
    This is already done in compute-local.conf for compute VM, as well as in
    control-local.conf for control VM.

    Key sections to notice in local.conf::

        [[local|localrc]] LOGFILE=stack.sh.log
        enable_plugin networking-odl https://github.com/stackforge/networking-odl

        Q_PLUGIN=ml2
        Q_ML2_TENANT_NETWORK_TYPE=vxlan
        ODL_MGR_IP=${ODL_IP}
        ENABLE_TENANT_TUNNELS=True
        Q_ML2_TENANT_NETWORK_TYPE=vxlan
        ODL_MODE=externalodl #control node | ODL_MODE=compute #compute node

2) Start devstack::
    
    vagrant ssh [devstack-control|devstack-compute-1]
    cd devstack
    
    You shold stack and unstack from $HOME/devstack directory.
    Rename [compute|control]-local.conf to local.conf and copy it into this directory. You
    can easily copy to VM by placing the file into git root directory (devstack-node) in
    your host machine. The file will be uploaded to VM into /vagrant directory.
    To make devstack-scripts visible modify /etc/environment by appending
    
      ':/vagrant/devstack-scripts'
    
    to PATH variable. Also modify controller's ip if needed.
    When stacking for the first time 'OFFLINE=True' has to be commented and 'RECLONE=yes'
    has to be uncommented in local.conf file on all the VMs.
    
    To stack safely, from $HOME/devstack directory on all the nodes execute:
    
        restack.sh
    
    To verify from control node if all the nodes are stacked successfully.
    
        source openrc admin admin
        nova hypervisor-list

    If everything went fine, comment 'RECLONE=yes' and uncomment OFFLINE=True. This saves
    a lot of time for further restacking.

Testing
-------

    Check the ovs bridges first
    
        sudo ovs-vsctl show
    
    If manager is not set
    
        sudo ovs-vsctl set-manager tcp:192.168.50.1:6640

    If controller has not been set together with manager
    
        sudo ovs-vsctl set-controller br-int tcp:192.168.50.1:6653

More to come, including prebuilt scripts and how this integrates with GBP, GBP+SFC etc...
