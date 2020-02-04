virsh list --all --name | grep ".ocp.example.com" | xargs -i /bin/bash -c "virsh destroy {}; virsh undefine {} --remove-all-storage"
