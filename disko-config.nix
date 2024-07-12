{
    device ? throw "Disk device, /dev/xxx",
    ...
}: {
    disko.devices = {
        disk = {
            main = {
                type = "disk";
                inherit device;
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
                                passwordFile = "/tmp/secret.key";
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
