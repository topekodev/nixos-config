{
    disko.devices = {
        disk = {
            main = {
                type = "disk";
                device = "/dev/sda";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [
                                    "defaults"
                                ];
                            };
                        };
                        luks = {
                            size = "100%";
                            content = {
                                type = "luks";
                                name = "crypt";
                                settings = {
                                    allowDiscards = true;
                                };
                                postCreateHook = ''
                                    dd bs=512 count=4 iflag=fullblock if=/dev/random of=/mnt/crypt.key
                                    chmod 600 /mnt/crypt.key
                                    cryptsetup luksAddKey /dev/sda2 /mnt/crypt.key /tmp/disk.key
                                '';
                                content = {
                                    type = "btrfs";
                                    extraArgs = [ "-f" ];
                                    subvolumes = {
                                        "/root" = {
                                            mountpoint = "/";
                                            mountOptions = [ "compress=zstd" "noatime" ];
                                        };
                                        "/home" = {
                                            mountpoint = "/home";
                                            mountOptions = [ "compress=zstd" "noatime" ];
                                        };
                                        "/nix" = {
                                            mountpoint = "/nix";
                                            mountOptions = [ "compress=zstd" "noatime" ];
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}
