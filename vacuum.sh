scp root@192.168.122.53:/var/named/{kahvi.online.zone,155.168.192.in-addr.arpa} ./named/var/named/
scp root@192.168.122.53:/etc/named.conf ./named/etc/named.conf
scp root@192.168.122.53:/etc/dhcp/dhcpd.conf dhcpd/etc/dhcpd/dhcpd.conf
scp root@192.168.122.53:/etc/httpd/conf/httpd.conf ./etc/httpd/conf/
scp root@192.168.122.53:/etc/haproxy/haproxy.cfg ./haproxy/etc/haproxy/haproxy.cfg
