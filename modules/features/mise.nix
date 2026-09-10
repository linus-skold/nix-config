{ ... }: {
    flake.nixosModules.mise = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.mise ];
    };
}
