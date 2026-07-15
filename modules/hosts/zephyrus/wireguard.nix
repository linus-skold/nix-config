{ self, inputs, ...}: {

    flake.nixosModules.zephyrusWireguard = { pkgs, ... }: {
        networking.wg-quick.interfaces = {
            wg0 = {
                address = [ "10.100.10.3/32" ];
                dns = [ "10.100.10.1" ];
                privateKeyFile = "/home/linus/.config/wireguard";
                peers = [
                    {
                        publicKey = "tDaP/UZI+R/uVYI54ntAB+wmomNiFHYfE/7+gYsdVhc=";
                        allowedIPs = [ "10.100.0.0/16" ];
                        endpoint = "";
                        persistentKeepalive = 25;
                    }
                ];
            };
        };
    };
}
