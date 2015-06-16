#glance image-create --name ubuntu --disk-format vdi --container-format ova --is-public True --file /vagrant/devstack-ubuntu.ova
glance image-create --name ubuntu --disk-format raw --is-public True --container-format=bare < /vagrant/devstack-ubuntu-disk1.raw

