FROM million12/centos-supervisor
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

RUN \
    yum update -y && \
    yum install -y tar gcc make mariadb-devel net-snmp-devel cacti && \
    curl -o /tmp/cacti-spine.tgz http://www.cacti.net/downloads/spine/cacti-spine-0.8.8c.tar.gz && \
    mkdir -p /tmp/spine && \
    tar zxvf /tmp/cacti-spine.tgz -C /tmp/spine --strip-components=1 && \
    rm -f /tmp/cacti-spine.tgz && \
    cd /tmp/spine/ && ./configure && make && make install && \
    echo "date.timezone = UTC" >> /etc/php.ini && \
    rm -rf /tmp/spine && \
    # Remove packages that are not needed anymore
    yum remove -y gcc make tar mariadb-devel && \
    yum clean all

RUN \
    echo "putenv('TZ='.date_default_timezone_get());" >> /etc/php.ini && \
    echo "date.timezone = Asia/Shanghai" >> /etc/php.ini && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY container-files /
VOLUME  ["/usr/share/cacti/resource", "/var/lib/cacti/rra"]

EXPOSE 80
