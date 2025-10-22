# Proxmox Cloud-Init Template Automation

> A bash script to create Linux cloud-init templates in Proxmox with a single command.

## Features

- One-command template creation
- Pre-configured cloud-init settings
- QEMU guest agent integration
- Custom network and storage configuration
- Fast VM deployment (30 seconds vs 13 minutes traditional method)

## Prerequisites

1. Proxmox VE 9.0.10 (tested version)
2. Install libguestfs-tools (recommended):
```bash
apt install libguestfs-tools -y
```
3. SSH public key imported (recommended for passwordless access)

## Usage

1. Make script executable:
```bash
chmod +x create-template.sh
```

2. Run:
```bash
./create-template.sh
```

3. Deploy new VMs from template in ~30 seconds ✓

## Configuration

The script creates a VM template (basically) with:
- 2 CPU cores (x86-64-v2-AES)
- 2GB RAM
- VirtIO network bridge (vmbr0)
- At least 30GB disk space guaranteed
- OVMF BIOS with pre-enrolled keys
- Cloud-init ready

Default credentials configured in cloud-init can be customized before template creation!

___
Created by [Muller Matos](https://linktr.ee/millerjmatos)
