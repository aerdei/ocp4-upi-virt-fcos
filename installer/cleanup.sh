hosts=(bootstrap master-0 master-1 master-2 worker-0 worker-1 )
nums=6
while [ $nums -gt 0 ]
do
let nums-=1
virsh destroy "${hosts[$nums]}.ocp.kahvi.online"
virsh undefine "${hosts[$nums]}.ocp.kahvi.online"
done
