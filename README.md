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

1. Create your local config from the example (it is git-ignored, never commit it):
```bash
cp cloudinit.env.example cloudinit.env
chmod 600 cloudinit.env
```

2. Edit `cloudinit.env` and set at least `CI_USER` and `CI_SSHKEYS` (path to your public key).

3. Run the script for the distro you want:
```bash
chmod +x ubuntu-cloudinit.sh
./ubuntu-cloudinit.sh
```

4. Clone the template to deploy new VMs in ~30 seconds.

Settings can also come from environment variables or another file:
```bash
CI_USER=admin CI_SSHKEYS=~/.ssh/id_ed25519.pub ./rocky10-cloudinit.sh
ENV_FILE=/secure/path/cloudinit.env ./ol9-cloudinit.sh
```

## Configuration

The script creates a VM template with the following defaults:

- 2 CPU cores (x86-64-v2-AES)
- 2GB RAM
- VirtIO network bridge (vmbr0)
- 30GB disk space minimum
- OVMF BIOS with pre-enrolled keys
- Cloud-init ready

## Security

- No credentials are stored in this repository. They are read from `cloudinit.env` or the environment.
- Access is key-based by default (`--sshkeys`). `CI_PASSWORD` is optional. Leave it empty unless you need console login.
- If you set a password, prefer a SHA-512 hash (`openssl passwd -6`) over plain text. Every VM cloned from the template inherits it.

___
Created by [Muller Matos](https://linktr.ee/millerjmatos)
