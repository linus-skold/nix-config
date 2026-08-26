{ self, inputs, ... }: {
  flake.nixosModules.zephyrusSteam = { pkgs, lib, config, ... }: {
    # programs.steam = {
    #   enable = true;
    #   remotePlay.openFirewall = true;
    #   dedicatedServer.openFirewall = true;
    # };
  };
}
