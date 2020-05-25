#!/bin/bash
if [ ! -z "${1}" ]; then
    virsh list --all --name | grep "${1}" | xargs -i /bin/bash -c "virsh destroy {}; virsh undefine {} --remove-all-storage"
else
   	echo "Usage: ${0} [domain]"
	exit 1
fi