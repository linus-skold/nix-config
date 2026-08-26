{ self, inputs, ... }: {
  flake.nixosModules.zephyrusOpenssh = { pkgs, lib, config, ... }: {
    # OpenSSH configuration is handled in main configuration.nix
  };
}
