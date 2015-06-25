# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  num_compute_nodes = (ENV['DEVSTACK_NUM_COMPUTE_NODES'] || 1).to_i

  # ip configuration
  control_ip = "192.168.50.20"
  compute_ip_base = "192.168.50."
  neutron_ex_ip = "192.168.111.11"
  compute_ips = num_compute_nodes.times.collect { |n| compute_ip_base + "#{n+21}" }

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "base.pp"
  end

  # Devstack Controller
  config.vm.define "devstack-control", primary: true do |control|
    control.vm.box = "trusty64"
    control.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
    control.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_ubuntu-14.04_chef-provisionerless.box"
    end
    control.vm.hostname = "devstack-control"
    control.vm.network "private_network", ip: "#{control_ip}"
    control.vm.network "private_network", ip: "#{neutron_ex_ip}", virtualbox__intnet: "mylocalnet" 
    control.vm.provider :virtualbox do |vb|
      vb.memory = 6144
    end
    control.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "6144"
    end
    control.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "devstack-control.pp"
    end
  end

  # Devstack Compute Nodes
  num_compute_nodes.times do |n|
    config.vm.define "devstack-compute-#{n+1}", autostart: true do |compute|
      compute_ip = compute_ips[n]
      compute_index = n+1
      compute.vm.box = "trusty64"
      compute.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      compute.vm.provider "vmware_fusion" do |v, override|
        override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_ubuntu-14.04_chef-provisionerless.box"
      end
      compute.vm.hostname = "devstack-compute-#{compute_index}"
      compute.vm.network "private_network", ip: "#{compute_ip}"
      #compute.vm.network "private_network", ip: "192.168.111.12", virtualbox__intnet: "mylocalnet"
      compute.vm.provider :virtualbox do |vb|
        vb.memory = 6144
      end
      compute.vm.provider "vmware_fusion" do |vf|
        vf.vmx["memsize"] = "6144"
      end
      compute.vm.provision "puppet" do |puppet|
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.working_directory = "/vagrant/puppet"
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "devstack-compute.pp"
      end
    end
  end

end
