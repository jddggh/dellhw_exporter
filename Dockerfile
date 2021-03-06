FROM centos:7
MAINTAINER Alexander Trost <galexrt@googlemail.com>

# Environment variables
ENV DSU_VERSION="DSU_17.07.00" \
    PATH="$PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin" \
    USER="root" \
    PASS="password" \
    SYSTEMCTL_SKIP_REDIRECT="1"

# Do overall update and install missing packages needed for OpenManage
RUN yum -y update && \
    yum -y install sysvinit-tools wget perl passwd gcc which tar libstdc++.so.6 compat-libstdc++-33.i686 glibc.i686 && \
    echo "$USER:$PASS" | chpasswd && \
    wget -q -O - "http://linux.dell.com/repo/hardware/${DSU_VERSION}/bootstrap.cgi" | bash && \
    yum -y install srvadmin-base srvadmin-storageservices && \
    yum clean all


ADD .build/linux-amd64/dellhw_exporter /bin/dellhw_exporter

ENTRYPOINT ["/bin/dellhw_exporter"]

CMD ["-container"]
