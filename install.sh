#!/usr/bin/env bash

confirm () {
    read -p "$1 (y/N): " confirm
    case "$confirm" in
        y|Y ) ;;
        n|N ) exit 1;;
        * ) exit 1;;
    esac
}

lsblk
read -p "Install disk device: /dev/" disk
if lsblk | grep -w "$disk"; then
    device="/dev/$disk"
else
    echo "Disk not found"
    exit 1
fi

read -sp "Disk encryption password: " password
echo
echo $password > /tmp/secret.key

confirm "Partition $device"
cp ./disko-config.nix /tmp/disko-config.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko-config.nix --arg device '"'$device'"'
