{
    disko.devices = {
        disk = {
            vdb = {
                type = "disk";
                device = "/dev/vdb";
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
                            name = "crypt";
                            passwordFile = "/tmp/crypt.key";
                            settings = {
                                allowDiscards = true;
                            };
                            content = {
                                type = "btfrs";
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
}
