{ self, inputs, ...}: {
    flake.nixosModules.git = { pkgs, lib, ... }: {
        programs.git = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.gitFeature;
        };
    };

    perSystem = { pkgs, lib, ... }: {
        packages.gitFeature = inputs.wrapper-modules.wrappers.git.wrap {
            inherit pkgs;
        };
    }; 
}
