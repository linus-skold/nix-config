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
    };

    perSystem = { pkgs, ... }: {
        packages.myNoctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
