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
                                    keyFile = "/dev/mapper/cryptkey";
                                    keyFileSize = 8192;
                                    allowDiscards = true;
                                };
                                postCreateHook = ''
                                    dd bs=512 count=4 iflag=fullblock if=/dev/random of=/tmp/crypt.key
                                    chmod 600 /tmp/crypt.key
                                    cryptsetup luksAddKey --key-file /dev/mapper/cryptkey --keyfile-size 8192 /dev/sda2 /tmp/crypt.key
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
