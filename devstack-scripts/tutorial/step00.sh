source openrc admin admin

# create ssh key for each tenant
# 
for x in admin ; do echo "ssh key for ${x}" ; \
   rm -f id_rsa_${x}* ; ssh-keygen -t rsa -b 2048 -N '' -f id_rsa_${x}
   nova keypair-add --pub-key  id_rsa_${x}.pub  ${x}_key
done

glance image-create --name='trusty' --is-public=true --container-format=bare --disk-format=vmdk < /vagrant/ubuntu.vmdk
nova flavor-create trusty 6 1024 40 1

