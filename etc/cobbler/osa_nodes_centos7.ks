# This kickstart file should only be used with EL > 5 and/or Fedora > 7.
# For older versions please use the sample.ks kickstart file.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
# Install OS instead of upgrade
install
# Use text mode install
text
# Use network installation
network --bootproto dhcp
url --url=$tree
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard --vckeymap=us --xlayouts=''
# System language
lang en_US.UTF-8 
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot
#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  Europe/Paris
# Create cento user
user --groups=wheel --name=centos --password=$centos_password_crypted --iscrypted
# Partition clearing information
clearpart --all --initlabel
# Clear the Master Boot Record
zerombr
# Disk partitioning 
part biosboot --fstype=biosboot --size=1
part /boot --fstype=ext4 --size=1024 --asprimary --ondrive=sda
part swap --fstype=swap --recommended --ondrive=sda
part pv.01 --size=24000 --maxsize=64000 --grow --ondrive=sda  # System partition
part pv.02 --size=32000 --maxsize=82000 --grow --ondrive=sda  # OpenStack partition
part pv.03 --size=1000 --grow --ondrive=sda                  # Compute partition
part pv.04 --size=1000 --grow --ondrive=sda		        # Ceph data partition
# System partitions
volgroup system_vg pv.01
logvol / --fstype=xfs --name=root_lv --vgname=system_vg --size=16384
logvol /var/log --fstype=xfs --name=varlog_lv --vgname=system_vg --size=32000 --grow
logvol /tmp --fstype=xfs --name=tmp_lv --vgname=system_vg --size=2000
logvol /opt --fstype=xfs --name=opt_lv --vgname=system_vg --size=4000
# Openstack dedicated partitions
volgroup openstack_vg pv.02
logvol /openstack --fstype=xfs --name=ost_lv --vgname=openstack_vg --percent=20
logvol /openstack/log --fstype xfs --name=log_lv --vgname=openstack_vg --percent=80
# OpenStack compute instances
volgroup compute_vg pv.03
logvol /var/lib/nova/instances --fstype=xfs --name=compute_lv --vgname=compute_vg --size=64000 --grow
# Ceph data
volgroup ceph-data_vg pv.04
logvol /var/lib/ceph/data --fstype=xfs --name=ceph-data_lv --vgname=ceph-data_vg --grow

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
@base
@core
git
chrony
openssh-server
python-devel
sudo
@ Development Tools
$SNIPPET('func_install_if_enabled')
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
$SNIPPET('import_ssh_keys')
# Install OpenStack RDO packages 
rpm -Uvh https://rdoproject.org/repos/openstack-rocky/rdo-release-rocky.rpm 
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end