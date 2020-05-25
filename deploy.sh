#!/bin/bash
domain=${2:-"example.com"}
memory=${3:-10240}
vcpus=${4:-12}
storage=${5:-125}

case ${1} in
	"masters")
		num=2
		mac=1
		ign="master"
		;;
	"workers")
		num=1
		mac=2
		ign="worker"
		;;
	"bootstrap")
		num=0
		mac=0
		ign="bootstrap"
		;;
	*)
		echo "Usage: ${0} {bootstrap,masters,workers} [domain] [memory(in M)] [vcpus] [storage(in G)]"
		exit 1
esac

for i in $(seq 0 ${num}); do
	virt-install --autostart --graphics=none --noautoconsole --network bridge=ovsbr,mac=12:34:56:00:00:"${mac}${i}",virtualport_type=openvswitch --os-type=rhel8.0 --location=iso_rhcos --file=/var/lib/libvirt/images/"${ign}"-"${i}".ocp."${domain}" --file-size="${storage}"  --memory="${memory}" --vcpus="${vcpus}" --name="${ign}"-"${i}".ocp."${domain}" --extra-args="rd.neednet=1 ip=dhcp coreos.inst=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://utility.ocp.${domain}:8080/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://utility.ocp.${domain}:8080/${ign}.ign console=ttyS0"
done