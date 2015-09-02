devstack-nodes
==============

This repo provides a Vagrantfile with provisioning that one can use to easily
get a cluster of nodes configured with DevStack.

It is a fork of the wonderful work of Mr Flavio Fernandes

Usage
-----
* Expect external ODL with features: odl-groupbasedpolicy-neutronmapper odl-groupbasedpolicy-ui odl-restconf


* Run VMs::
    
    A Vagrantfile is provided to easily create a DevStack environment to test with. To save
    performance, it is sufficient to run all the required services just on one VM. This VM
    is identified as control node. Other VMs are compute nodes. First, set number of compute
    nodes desired by setting:
    
        'DEVSTACK_NUM_COMPUTE_NODES=1'
    
    #Note: Only 3 or less nodes are supported today
    Next, execute:
    
        vagrant up
    
    If no VMs have been generated yet, they will be now.
    
* Start devstack::
    
    vagrant ssh [devstack-control|devstack-compute-1]
    cd devstack
    sudo cp /vagrant/devstack-scripts/environment /etc/environment; source /etc/environment
    sudo ovs-vsctl add-br br-int
 
    After initial stack, in local.conf change to:

        OFFLINE=True
        #RECLONE=yes
  
    Then instead of ./unstack.sh etc ./stack.sh: 

        restack.sh
    
    To verify from control node if all the nodes are stacked successfully.
    
        source openrc admin admin
        nova hypervisor-list

    If everything went fine, comment 'RECLONE=yes' and uncomment OFFLINE=True. This saves
    a lot of time for further restacking.

Testing
-----

1) Check the ovs bridges first::

    sudo ovs-vsctl show

2) If manager is not set::

    sudo ovs-vsctl set-manager tcp:192.168.50.1:6640

3) If controller has not been set together with manager::

    sudo ovs-vsctl set-controller br-int tcp:192.168.50.1:6653

4) Prebuilt scripts can be run from command line:
    
    step01.sh
    step02.sh

    These can be modified from /vagrant/devstack-scripts/tutorial
