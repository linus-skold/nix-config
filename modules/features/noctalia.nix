{ self, inputs, ...}: {

    flake.nixosModules.noctalia = { pkgs, ... }: {
        imports = [
            inputs.noctalia.nixosModules.default
        ];

        programs.noctalia = {
            enable = true;
            recommendedServices.enable = true;
        };
    };

    perSystem = { pkgs, ... }: {
        packages.myNoctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
