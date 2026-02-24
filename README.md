# Proxmox Cloud-Init Template Automation
> A bash script to create Linux cloud-init templates in Proxmox with a single command.

## Features

- Single command template creation
- Pre-configured cloud-init settings with QEMU guest agent integration
- Custom network and storage configuration
- VM deployment in ~30 seconds versus ~13 minutes with the traditional method

## Prerequisites

1. Proxmox VE 9.0.10 (tested version)
2. Install libguestfs-tools:
```bash
apt install libguestfs-tools -y
```

3. SSH public key imported for passwordless access

## Usage

1. Make the script executable:
```bash
chmod +x create-template.sh
```

2. Run the script:
```bash
./create-template.sh
```

3. Clone the template to deploy new VMs in ~30 seconds.

## Configuration

The script creates a VM template with the following defaults - customize cloud-init credentials before running:

- 2 CPU cores (x86-64-v2-AES)
- 2GB RAM
- VirtIO network bridge (vmbr0)
- 30GB disk space minimum
- OVMF BIOS with pre-enrolled keys
- Cloud-init ready

___
Created by [Muller Matos](https://linktr.ee/millerjmatos)
