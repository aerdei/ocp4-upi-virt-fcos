#!/bin/bash

if [ "$1" == "masters" ]
then
	for i in $(seq 0 2);
	do
		virt-install --autostart --graphics=none --noautoconsole --network bridge=ovsbr,mac=12:34:56:00:00:1"$i",virtualport_type=openvswitch --os-type=rhel8.0 --location=iso_rhcos --file=/var/lib/libvirt/images/master-"$i".ocp.kahvi.online --file-size=125  --memory=10240 --vcpus=12 --name=master-"$i".ocp.kahvi.online --extra-args="rd.neednet=1 ip=dhcp coreos.inst=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://support.ocp.kahvi.online:8080/rhcos-4.3.0-x86_64-metal.raw.gz coreos.inst.ignition_url=http://support.ocp.kahvi.online:8080/master.ign console=ttyS0"
	done
elif [ "$1" == "workers" ]
then
	for i in $(seq 0 1);
	do
		virt-install --autostart --graphics=none --noautoconsole --network bridge=ovsbr,mac=12:34:56:00:00:2"$i",virtualport_type=openvswitch --os-type=rhel8.0 --location=iso_rhcos --file=/var/lib/libvirt/images/worker-"$i".ocp.kahvi.online --file-size=125  --memory=10240 --vcpus=12 --name=worker-"$i".ocp.kahvi.online --extra-args="rd.neednet=1 ip=dhcp coreos.inst=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://support.ocp.kahvi.online:8080/rhcos-4.3.0-x86_64-metal.raw.gz coreos.inst.ignition_url=http://support.ocp.kahvi.online:8080/worker.ign console=ttyS0"
	done
elif [ "$1" == "bootstrap" ]
then
	virt-install --autostart --graphics=none --noautoconsole --network bridge=ovsbr,mac=12:34:56:00:00:00,virtualport_type=openvswitch --os-type=rhel8.0 --location=iso_rhcos --file=/var/lib/libvirt/images/bootstrap.ocp.kahvi.online --file-size=125  --memory=10240 --vcpus=12 --name=bootstrap.ocp.kahvi.online --extra-args="rd.neednet=1 ip=dhcp coreos.inst=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://support.ocp.kahvi.online:8080/rhcos-4.3.0-x86_64-metal.raw.gz coreos.inst.ignition_url=http://support.ocp.kahvi.online:8080/bootstrap.ign console=ttyS0"
else
	echo "Usage: $0 {bootstrap,masters,workers}"
fi
