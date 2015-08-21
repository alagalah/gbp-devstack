devstack-nodes
==============

This repository provides a Vagrantfile with provisioning that one can use to easily
get a cluster of nodes configured with DevStack.

It is a fork of the wonderful work of Mr Flavio Fernandes

Usage
-----

1) Run VMs::
    
    A Vagrantfile is provided to easily create a DevStack environment to test with.
    First, set number of compute nodes desired as environment variable. For example:
    
        'DEVSTACK_NUM_COMPUTE_NODES=1'
    
    Next, from root folder execute:
    
        vagrant up
    
    You should see a VMs to be generated in your hypervisor. VirtualBox is predefined.
    
2) Start devstack::
    
        vagrant ssh [devstack-control|devstack-compute-1]
        cd devstack
    
    You are now in git repository refering to https://review.openstack.org/#/admin/projects/openstack-dev/devstack
    It might take a few minutes to stack for the first time.
    
        ./stack.sh
    
    You may see other modules cloned in /opt/stack directory.

3) Set environment path to demo scripts::

    Modify /etc/environment by appending ':/vagrant/devstack-scripts'.

        source /etc/environment
    
    You may now use following scripts to stack safely:

        myunstack.sh
        restack.sh

    They have to be executed from /home/vagrant/devstack directory.

4) Verify

    To verify from control node if all the nodes have stacked successfully:
    
        source openrc admin admin
        nova hypervisor-list

5) Edit local.conf::

    Notice configuration file in /home/vagrant/devstack.
    By default OFFLINE=True is commented out and RECLONE=yes is uncommented.
    When you don't want to stack with updated modules in /opt/stack comment RECLONE=yes and uncomment OFFLINE=True
    It is recommended to do this after you successfully stack on all the nodes.

6) Backup your setup::

    It is strongly recommended to create snapshot of your VMs.
    Here is one plugin you might use https://github.com/dergachev/vagrant-vbox-snapshot

7) Testing with ODL::

    Make sure that ODL is running before every stacking.
    Following features need to be installed:
    
        odl-groupbasedpolicy-neutronmapper
        odl-restconf

    Verify OVS setup after successful stacking:

        Check the ovs bridges first

            sudo ovs-vsctl show

        If manager has not been set

            sudo ovs-vsctl set-manager tcp:192.168.50.1:6640

        If controller has not been set

            sudo ovs-vsctl set-controller br-int tcp:192.168.50.1:6653

7) Notes::

    There may be local.conf files in this repo as well. 
    They may be used instead of generated local.conf files in your VMs.

