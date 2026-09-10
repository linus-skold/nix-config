{ self, inputs, ...}: {

    flake.nixosModules.noctalia = { pkgs, ... }: {
        imports = [
            inputs.noctalia.nixosModules.default
            inputs.noctalia-greeter.nixosModules.default
        ];

        programs.noctalia = {
            enable = true;
            recommendedServices.enable = true;
        };

        programs.noctalia-greeter = {
            enable = true;

        };

        # flake.nix declares this too, but nixConfig from a flake is ignored
        # unless the invoking user is trusted (trusted-users = root here), so
        # noctalia was being compiled from source. This is the effective place.
        nix.settings = {
            extra-substituters = [ "https://noctalia.cachix.org" ];
            extra-trusted-public-keys = [
                "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            ];
        };
    };

    perSystem = { pkgs, ... }: {
        packages.myNoctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
