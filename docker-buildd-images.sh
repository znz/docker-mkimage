#!/bin/bash
set -euo pipefail
set -x

username=local
# these should match the names found at http://www.debian.org/releases/
debianStable=wheezy
debianUnstable=sid
# this should match the name found at http://releases.ubuntu.com/
ubuntuLatestLTS=precise


deb_suite=wheezy
sudo debootstrap --verbose --variant=buildd --include=iproute --arch=amd64 $deb_suite /tmp/$deb_suite-buildd http://cdn.debian.or.jp/debian
cd /tmp/$deb_suite-buildd
echo $'#!/bin/sh\nexit 101' | sudo tee usr/sbin/policy-rc.d > /dev/null
sudo chmod +x usr/sbin/policy-rc.d
sudo chroot . dpkg-divert --local --rename --add /sbin/initctl
sudo ln -sf /bin/true sbin/initctl
sudo chroot . apt-get clean
echo 'force-unsafe-io' | sudo tee etc/dpkg/dpkg.cfg.d/02apt-speedup > /dev/null
echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | sudo tee etc/apt/apt.conf.d/no-cache > /dev/null
sudo tee etc/apt/sources.list >/dev/null <<EOF
deb http://cdn.debian.or.jp/debian $deb_suite main
deb http://cdn.debian.or.jp/debian $deb_suite-updates main
deb http://security.debian.org/ $deb_suite/updates main
EOF
sudo chroot . apt-get update
sudo chroot . apt-get -y dist-upgrade
echo locales locales/locales_to_be_generated multiselect ja_JP.EUC-JP EUC-JP, ja_JP.UTF-8 UTF-8 | sudo chroot . debconf-set-selections
echo locales locales/default_environment_locale select ja_JP.UTF-8 | sudo chroot . debconf-set-selections
sudo chroot . env DEBIAN_FRONTEND=noninteractive apt-get install locales
sudo chroot . apt-get clean
sudo tar --numeric-owner -c . | sudo docker import - $username/debian-ja:$deb_suite
if [ "$deb_suite" = "$debianStable" ]; then
  sudo docker tag $username/debian-ja:$deb_suite $username/debian-ja:latest
fi
if [ -r etc/debian_version ]; then
  sudo docker tag $username/debian-ja:$deb_suite $username/debian-ja:$(cat etc/debian_version)
fi


ubuntu_suite=precise
sudo debootstrap --verbose --variant=buildd --arch=amd64 $ubuntu_suite /tmp/$ubuntu_suite-buildd http://ftp.jaist.ac.jp/pub/Linux/ubuntu/
cd /tmp/$ubuntu_suite-buildd
echo $'#!/bin/sh\nexit 101' | sudo tee usr/sbin/policy-rc.d > /dev/null
sudo chmod +x usr/sbin/policy-rc.d
sudo chroot . dpkg-divert --local --rename --add /sbin/initctl
sudo ln -sf /bin/true sbin/initctl
sudo chroot . apt-get clean
echo 'force-unsafe-io' | sudo tee etc/dpkg/dpkg.cfg.d/02apt-speedup > /dev/null
echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | sudo tee etc/apt/apt.conf.d/no-cache > /dev/null
sudo tee etc/apt/sources.list >/dev/null <<EOF
deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu $ubuntu_suite main universe
deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu $ubuntu_suite-updates main universe
deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu $ubuntu_suite-security main universe
EOF
sudo chroot . apt-get update
sudo chroot . apt-get -y dist-upgrade
sudo chroot . locale-gen ja_JP.UTF-8
sudo chroot . locale-gen ja_JP.EUC-JP
sudo chroot . apt-get clean
sudo tar --numeric-owner -c . | sudo docker import - $username/ubuntu-ja:$ubuntu_suite
if [ "$ubuntu_suite" = "$ubuntuLatestLTS" ]; then
  sudo docker tag $username/ubuntu-ja:$ubuntu_suite $username/ubuntu-ja:latest
fi
if [ -r etc/lsb-release ]; then
  lsbRelease="$(. etc/lsb-release && echo "$DISTRIB_RELEASE")"
  if [ -n "$lsbRelease" ]; then
    sudo docker tag $username/ubuntu-ja:$ubuntu_suite $username/ubuntu-ja:$lsbRelease
  fi
fi
