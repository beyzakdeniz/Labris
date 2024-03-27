rpmdev-setuptree

# ana bilgisayardan terminal aç: 
docker cp /home/beyza/Downloads/netflow2ng-0.0.4.tar.gz wizardly_snyder:/root/rpmbuild/SOURCES
#

dnf install -y tree
dnf install -y nano
dnf install -y zeromq-devel
pkg-config --cflags -- libzmq
cd ~/rpmbuild
tree
cd ~/rpmbuild/SPECS
rpmdev-newspec netflow2ng
nano netflow2ng.spec

# doldur

#rpmbuild -bs netflow2ng.spec
rpmbuild -ba --define 'debug_package %{nil}' netflow2ng.spec

#cd ~/rpmbuild/SRPMS
#ls
# rpm adı öğrenildi: netflow2ng-0.0.4-1.el8.src.rpm
#rpmbuild --rebuild ~/rpmbuild/SRPMS/netflow2ng-0.0.4-1.el8.src.rpm

rpmlint netflow2ng.spec
rpmlint ~/rpmbuild/SRPMS/netflow2ng-0.0.4-1.el8.src.rpm
rpmlint ~/rpmbuild/RPMS/x86_64/netflow2ng-0.0.4-1.el8.x86_64.rpm

dnf install -y ~/rpmbuild/RPMS/x86_64/netflow2ng-0.0.4-1.el8.x86_64.rpm


####
# MSMTP
####

rpmdev-setuptree

dnf install -y git autoconf automake libtool gettext pkg-config
dnf --enablerepo=powertools install -y texinfo
dnf install -y gnutls-devel
dnf install gettext
dnf install -y gettext-devel

#
docker cp /home/beyza/Downloads/msmtp-1.8.25.tar.xz musing_leavitt:/root/rpmbuild/SOURCES
#

cd ~/rpmbuild/SPECS
rpmdev-newspec msmtp
nano msmtp.spec





