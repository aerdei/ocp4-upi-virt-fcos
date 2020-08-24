## OpenShift 4.3 UPI disconnected on Libvirt with a Fedora CoreOS utility node

![Diagram](diagram.svg)


# Prerequisites

> libvirt  
> virt-install  
> openvswitch  
> [fcct](https://github.com/coreos/fcct/releases)  
> xz

# Deploy utility node
Create the Libvirt network:
```bash
virsh net-define --file ocp4.xml && virsh net-start ocp4
```

Create an Open vSwitch bridge:
```bash
ovs-vsctl add-br ovsbr
```

Download Fedora CoreOS:
```bash
curl https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/32.20200726.3.1/x86_64/fedora-coreos-32.20200726.3.1-qemu.x86_64.qcow2.xz -o /var/lib/libvirt/images/fedora-coreos-32.20200726.3.1-qemu.x86_64.qcow2.xz && xz --decompress /var/lib/libvirt/images/fedora-coreos-32.20200726.3.1-qemu.x86_64.qcow2.xz
```

Add your pull secret to `.storage.files.$11` and your host's SSH key to `passwd.users.$0.ssh_authorized_keys` in `utility.fcc`.  
Generate ignition config:
```bash
fcct -strict -pretty < utility.fcc > /var/lib/libvirt/images/utility.ign
```

Start Fedora CoreOS with the ignition config:
```bash
virt-install --connect qemu:///system --import --name utility.ocp.example.com --network network=ocp4,mac=12:34:56:00:00:53 --network bridge=ovsbr,mac=12:34:56:00:00:54,virtualport_type=openvswitch --ram 1024 --vcpus 1 --os-variant fedora29 --disk size=50,backing_store=/var/lib/libvirt/images/fedora-coreos-32.20200726.3.1-qemu.x86_64.qcow2,format=qcow2,bus=virtio --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=/var/lib/libvirt/images/utility.ign" --vnc --noautoconsole
```
When the utility node is up, you can start preparing the OpenShift installation.  

# Deploy OpenShift 4.3
## Prepare the installer
Prepare RHCOS images for the install in the `iso_rhcos` directory.
```bash
wget https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.5/latest/rhcos-installer.x86_64.iso https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.5/latest/rhcos-installer-kernel-x86_64 https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.5/latest/rhcos-installer-initramfs.x86_64.img -N -P ./iso_rhcos/
```
Download the extracted installer to the host:  
```bash
curl http://192.168.122.53:8080/openshift-install -o openshift-install
chmod +x ./openshift-install
```
Configure `install-config.yaml` in the `cluster` directory.  
Create installer files and upload them to the utility VM:
```bash
./openshift-install create manifests --dir=cluster/
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' cluster/manifests/cluster-scheduler-02-config.yml
./openshift-install create ignition-configs --dir=cluster/
rsync -Pavr --chmod=o+r ./cluster/* core@192.168.122.53:/opt/services/httpd/www/html/
```
## Deploy nodes
Deploy bootstrap node:
```bash
bash deploy.sh bootstrap
```
Note that you need to manually start all the nodes as they will not automatically reboot:
```bash
bash start.sh
```
When the bootstrap node is up, deploy the masters:
```bash
bash deploy.sh masters
```
When the masters are up and the bootstrap process is complete, you are ready to destroy the bootstrap node and deploy the worker nodes:
```bash
virsh destroy bootstrap.ocp.example.com
virsh undefine bootstrap.ocp.example.com --remove-all-storage
bash deploy.sh workers
```
Make sure to approve any CSRs that are generated while provisioning the workers:
```bash
export KUBECONFIG=$(pwd)/cluster/auth/kubeconfig
oc login -u system:admin
oc get csr -o go-template --template='{{range .items}}{{if  not .status}}{{printf "%s\n" .metadata.name}}{{end}}{{end}}' | xargs -i oc adm certificate approve {}
```
# Cleanup
To destroy and undefine every virtual machine related to this cluster, run `cleanup.sh`. 

# Known issues
- At startup, Fedora CoreOS will request IPs through DHCP on both of its interfaces. This should work on `eth0`, but a timeout must happen on `eth1` for the boot process to continue.
- RHCOS machines configured with virt-install currently don't reboot automatically. You need to invoke `start.sh` once they are in a shut down state.