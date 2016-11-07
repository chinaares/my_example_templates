openstack stack create -t 01-create-one-vm.yaml \
--parameter "flavor=m1.micro" \
--parameter "image=TestVM" \
--parameter "key_name=heat_key" \
stack-01-create-one-vm

