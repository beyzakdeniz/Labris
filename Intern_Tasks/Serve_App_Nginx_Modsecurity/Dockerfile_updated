FROM centos:centos8

ENV nginxversion="1.24.0-1" \
    os="centos" \
    osversion="8" \
    elversion="8"
    
RUN update-ca-trust
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN \
# import rpm key
    echo '--> import rpm keys' && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
# swap to centos stream
    echo '--> swaping to centos stream' && \
    dnf --assumeyes --quiet install centos-release-stream && \
    dnf --assumeyes --quiet swap centos-{linux,stream}-repos && \
    dnf --assumeyes --quiet distro-sync
RUN dnf update -y
RUN dnf -y install epel-release
RUN dnf -y install python3-devel python3 python3-pip nginx git gcc make libxml2-devel pcre-devel openssl-devel wget tar
RUN dnf clean all

RUN dnf install -y wget openssl sed
RUN dnf -y autoremove

RUN dnf clean all


COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /data/www/index.html
VOLUME [ "/data/www" ]
EXPOSE 8080

RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y  httpd-devel pcre pcre-devel libxml2 libxml2-devel curl curl-devel openssl openssl-devel


CMD ["nginx", "-g", "daemon off;"]

