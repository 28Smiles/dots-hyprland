#!/usr/bin/env bash
export base="$(pwd)"

printf "Download the Image from this website (cause its the fastest)...\n"
firefox "https://tiny11.de.softonic.com/"

printf "Checking Sha256...\n"
echo "a2eb270e3f3b10ba9c0c7fc8a1f5e205e6db683f6f415255ae8ab49c256928b0 $HOME/Downloads/tiny11b1.iso" | sha256sum --check --strict -
printf "Ok\n"
printf "Installing QEMU...\n"
sudo pacman -Suy qemu-desktop swtpm libvirt
yay -Suy virtio
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

mv $HOME/Downloads/tiny11b1.iso /var/lib/libvirt/images/tiny11.iso
mv ./win11-libvirt.xml /etc/libvirt/qemu/win11.xml
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/win11.qcow2 32G
sudo virsh start win11
sudo -E virt-viewer win11
