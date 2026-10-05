#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-$(dirname "$0")/cloudinit.env}"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"

: "${CI_USER:?Defina CI_USER (veja cloudinit.env.example)}"
: "${CI_SSHKEYS:?Defina CI_SSHKEYS com o caminho da chave publica SSH}"
[ -r "$CI_SSHKEYS" ] || { echo "Chave publica nao encontrada: $CI_SSHKEYS" >&2; exit 1; }

CI_AUTH=(--ciuser "$CI_USER" --sshkeys "$CI_SSHKEYS")
[ -n "${CI_PASSWORD:-}" ] && CI_AUTH+=(--cipassword "$CI_PASSWORD")

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
  "${CI_AUTH[@]}"

qm template 6006
