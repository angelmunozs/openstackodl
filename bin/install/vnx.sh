#!/bin/bash
# Download VNX: http://web.dit.upm.es/vnxwiki/index.php/Download

# =========================================================================
# Dependencies
# =========================================================================

# Common content file
source bin/aux/common.sh

# =========================================================================
# Parameters
# =========================================================================

# Working directory
WORKDIR=/opt

# =========================================================================
# Download dependency packages
# =========================================================================

# Update repository
sudo apt-get update

# Install dependencies
sudo apt-get install -y qemu-kvm libvirt-bin vlan xterm bridge-utils screen virt-manager \
  virt-viewer uml-utilities graphviz genisoimage gnome-terminal xfce4-terminal tree \
  curl w3m picocom expect lxc wmctrl xdotool pv bash-completion \
  libnetaddr-ip-perl libxml-libxml-perl libxml-tidy-perl libappconfig-perl \
  libreadonly-perl libterm-readline-perl-perl libnet-pcap-perl libnet-ipv6addr-perl \
  libsys-virt-perl libnet-telnet-perl liberror-perl libexception-class-perl \
  libxml-dom-perl libdbi-perl libmath-round-perl libio-pty-perl libnet-ip-perl \
  libxml-checker-perl libxml-parser-perl libfile-homedir-perl libswitch-perl \
  openvswitch-switch net-tools

# =========================================================================
# Edit libvirt conf
# =========================================================================

# Append these lines to file
sudo echo 'security_driver = "none"'                                     >> /etc/libvirt/qemu.conf
sudo echo 'user = "root"'                                                >> /etc/libvirt/qemu.conf
sudo echo 'group = "root"'                                               >> /etc/libvirt/qemu.conf
sudo echo 'cgroup_device_acl = ['                                        >> /etc/libvirt/qemu.conf
sudo echo '   "/dev/null", "/dev/full", "/dev/zero",'                    >> /etc/libvirt/qemu.conf
sudo echo '   "/dev/random", "/dev/urandom",'                            >> /etc/libvirt/qemu.conf
sudo echo '   "/dev/ptmx", "/dev/kvm", "/dev/kqemu",'                    >> /etc/libvirt/qemu.conf
sudo echo '   "/dev/rtc", "/dev/hpet", "/dev/vfio/vfio", "/dev/net/tun"' >> /etc/libvirt/qemu.conf
sudo echo ']'                                                            >> /etc/libvirt/qemu.conf

# Restart libvirt
sudo systemctl restart libvirt-bin

# =========================================================================
# Install VNX
# =========================================================================

# Move to directory
cd $WORKDIR

# Reset updates folder
mkdir /tmp/vnx-update
cd /tmp/vnx-update
rm -rf /tmp/vnx-update/vnx-*

# Download VNX
wget http://vnx.dit.upm.es/vnx/vnx-latest.tgz

# Unpack and remove .tgz afterwards
tar xfvz vnx-latest.tgz
rm vnx-latest.tgz

# Move to VNX folder
cd vnx-*-*

# Install VNX
sudo ./install_vnx

# Create config file
sudo mv /usr/share/vnx/etc/vnx.conf.sample /etc/vnx.conf

# =========================================================================
# End echoes
# =========================================================================

echo "VNX succesfully installed to $WORKDIR"
echo "[WARN] For Ubuntu 15.04 or newer: change parameter 'overlayfs_workdir_option' in /etc/vnx.conf to 'yes'"
echo "[WARN] Verify that /etc/libvirt/qemu.conf has been updated (if not, see script)"
