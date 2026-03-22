#!/bin/sh

wget https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 -O /var/lib/vz/images/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2

virt-customize --add /var/lib/vz/images/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 --install qemu-guest-agent

qemu-img resize /var/lib/vz/images/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 +20G

qm create 6006 \
  --name vm-rocky10 \
  --memory 2048 \
  --cores 2 \
  --cpu host \
  --machine q35 \
  --net0 virtio,bridge=vmbr0,firewall=1 \
  --agent enabled=1

qm importdisk 6006 /var/lib/vz/images/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 local-lvm

qm set 6006 \
  --scsihw virtio-scsi-single \
  --scsi0 local-lvm:vm-6006-disk-0,discard=on,iothread=1,ssd=1 \
  --ide2 local-lvm:cloudinit \
  --boot order=scsi0 \
  --serial0 socket \
  --vga serial0 \
  --ipconfig0 ip=dhcp \
  --ciuser muller \
  --cipassword 'P@ssword123'

qm template 6006
