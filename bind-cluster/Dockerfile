FROM centos:7
RUN yum install -y bind bind-chroot bind-utils && yum clean all
COPY etc/named.conf /etc/named.conf
COPY var/named/example.com.zone /var/named/example.com.zone
COPY var/named/ocp-example.com.zone /var/named/ocp-example.com.zone
EXPOSE 53/udp 53/tcp 10000/tcp
CMD ["/usr/sbin/named","-u","named","-f"]
