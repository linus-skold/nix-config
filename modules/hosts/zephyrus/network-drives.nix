{ self, inputs, ...}: {
    
    flake.nixosModules.zephyrusNetworkDrives = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            cifs-utils
            samba
        ];

        fileSystems."/mnt/truenas/decode" = {
            device = "//10.100.0.174/Home Cloud/decode";
            fsType = "cifs";
            options = [
                "credentials=/home/linus/.config/smb/truenas_creds"
                "uid=1000"
                "gid=100"
                "x-systemd.automount"
                "noatime"
            ];
        };

        fileSystems."/mnt/llm-models" = {
            device = "//10.100.0.174/Home Cloud/decode/llm-models";
            fsType = "cifs";
            options = [
                "credentials=/home/linus/.config/smb/truenas_creds"
                "uid=1000"
                "gid=100"
                "x-systemd.automount"
                "noatime"
            ];
        };
    };
}
