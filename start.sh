hosts=(worker-1 worker-0 master-2 master-1 master-0 bootstrap)
nums=6
while [ $nums -gt 0 ]
do
let nums-=1
virsh start "${hosts[$nums]}.ocp.kahvi.online"
done
