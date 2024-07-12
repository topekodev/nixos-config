#!/usr/bin/env bash
cp ./disko-config.nix /tmp/disko-config.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko-config.nix
