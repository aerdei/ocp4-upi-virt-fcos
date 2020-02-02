virsh list --all --name | grep ".ocp.kahvi.online" | xargs -i /bin/bash -c "virsh destroy {}; virsh undefine {} --remove-all-storage"
