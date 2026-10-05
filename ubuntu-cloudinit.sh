#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-$(dirname "$0")/cloudinit.env}"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"

: "${CI_USER:?Defina CI_USER (veja cloudinit.env.example)}"
: "${CI_SSHKEYS:?Defina CI_SSHKEYS com o caminho da chave publica SSH}"
[ -r "$CI_SSHKEYS" ] || { echo "Chave publica nao encontrada: $CI_SSHKEYS" >&2; exit 1; }

CI_AUTH=(--ciuser "$CI_USER" --sshkeys "$CI_SSHKEYS")
[ -n "${CI_PASSWORD:-}" ] && CI_AUTH+=(--cipassword "$CI_PASSWORD")

wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O /var/lib/vz/images/noble-server-cloudimg-amd64.img

mv /var/lib/vz/images/noble-server-cloudimg-amd64.img /var/lib/vz/images/noble-server-cloudimg-amd64.qcow2

virt-customize --add /var/lib/vz/images/noble-server-cloudimg-amd64.qcow2 --install qemu-guest-agent

qemu-img resize /var/lib/vz/images/noble-server-cloudimg-amd64.qcow2 +30G

qm create 6002 \
  --name vm-ubuntu \
  --memory 2048 \
  --cores 2 \
  --cpu x86-64-v2-AES \
  --machine q35 \
  --bios ovmf \
  --efidisk0 local-lvm:0,efitype=4m,pre-enrolled-keys=1 \
  --net0 virtio,bridge=vmbr0,firewall=1 \
  --agent enabled=1

qm importdisk 6002 /var/lib/vz/images/noble-server-cloudimg-amd64.qcow2 local-lvm

qm set 6002 \
  --scsihw virtio-scsi-single \
  --scsi0 local-lvm:vm-6002-disk-1,discard=on,iothread=1,ssd=1 \
  --ide2 local-lvm:cloudinit \
  --boot order=scsi0 \
  --serial0 socket \
  --vga serial0 \
  --ipconfig0 ip=dhcp \
  "${CI_AUTH[@]}"

qm template 6002
