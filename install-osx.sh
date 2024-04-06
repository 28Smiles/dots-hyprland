#!/usr/bin/env bash
sudo pacman -Suy qemu python python-pip python-wheel
git clone https://github.com/foxlet/macOS-Simple-KVM.git /tmp/macOS-Simple-KVM
cd /tmp/macOS-Simple-KVM
python -m venv venv
source venv/bin/activate
pip install -r tools/FetchMacOS/requirements.txt

python tools/FetchMacOS/fetch-macos.py -v 10.15
sudo tools/dmg2img BaseSystem/BaseSystem.dmg /var/lib/libvirt/images/macOS_catalina.img
sudo cp ESP.qcow2 /var/lib/libvirt/images/macOS_ESP.qcow2
sudo cp firmware/OVMF_CODE.fd /var/lib/libvirt/qemu/nvram/macOS_CODE.fd
sudo cp firmware/OVMF_VARS-1024x768.fd /var/lib/libvirt/qemu/nvram/macOS_VARS-1024x768.fd
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/macOS.qcow2 48G

for file in /var/lib/libvirt/images/macOS_catalina.img /var/lib/libvirt/images/macOS_ESP.qcow2 /var/lib/libvirt/images/macOS.qcow2 /var/lib/libvirt/qemu/nvram/macOS_CODE.fd /var/lib/libvirt/qemu/nvram/macOS_VARS-1024x768.fd
do
    sudo chmod 0600 $file
    sudo chown libvirt-qemu: $file
done

MACHINE="$(qemu-system-x86_64 --machine help | grep q35 | cut -d" " -f1 | grep -Eoe ".*-[0-9.]+" | sort -rV | head -1)"
sed -e "s|VMDIR/firmware/OVMF_CODE.fd|/var/lib/libvirt/qemu/nvram/macOS_CODE.fd|g" \
    -e "s|VMDIR/firmware/OVMF_VARS-1024x768.fd|/var/lib/libvirt/qemu/nvram/macOS_VARS-1024x768.fd|g" \
    -e "s|VMDIR/ESP.qcow2|/var/lib/libvirt/images/macOS_ESP.qcow2|g" \
    -e "s|VMDIR/BaseSystem.img|/var/lib/libvirt/images/macOS_catalina.img|g" \
    -e "s|MACHINE|$MACHINE|g" \
    -e "s|<name>macOS-Simple-KVM</name>|<name>macOS</name>|g" \
    -e "s|</devices>|<disk type='file' device='disk'><driver name='qemu' type='qcow2'/><source file='/var/lib/libvirt/images/macOS.qcow2'/><target dev='sdc' bus='sata'/><address type='drive' controller='0' bus='0' target='0' unit='2'/></disk></devices>|g" \
    tools/template.xml.in > macOS.xml
virsh --connect qemu:///system define macOS.xml
