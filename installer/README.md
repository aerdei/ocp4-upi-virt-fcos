wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux-4.2.0.tar.gz
tar -xf openshift-install-linux-4.2.0.tar.gz
cp install-config.yaml install-files/
./openshift-install create manifests --dir=install-files/
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' install-files/manifests/cluster-scheduler-02-config.yml
./openshift-install create ignition-configs --dir=install-files/
scp -r install-files/* root@192.168.122.53:/var/www/html/
