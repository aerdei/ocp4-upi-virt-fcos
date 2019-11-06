```bash
get https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux-4.2.0.tar.gz
tar -xf openshift-install-linux-4.2.0.tar.gz
cp install-config.yaml install-files/
./openshift-install create manifests --dir=install-files/
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' install-files/manifests/cluster-scheduler-02-config.yml
./openshift-install create ignition-configs --dir=install-files/
scp -r install-files/* root@192.168.122.53:/var/www/html/
bash deploy.sh bootstrap
bash start.sh
bash deploy.sh masters
bash start.sh
export KUBECONFIG=/root/ocp4-upi-local/installer/install-files/auth/kubeconfig
oc get csr -o name | xargs -i oc adm certificate approve {}
bash deploy.sh workers
bash start.sh
oc get csr -o go-template --template='{{range .items}}{{if  not .status}}{{printf "%s\n" .metadata.name}}{{end}}{{end}}' | xargs -i oc adm certificate approve {}
export KUBECONFIG=/root/ocp4-upi-local/installer/install-files/auth/kubeconfig
```
