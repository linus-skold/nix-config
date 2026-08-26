{ self, inputs, ...}: {
    flake.nixosModules.PACKAGE = { pkgs, lib, ... }: {
        programs.PACKAGE = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myPACKAGE;
        };
    };
    perSystem = { pkgs, lib, ... }: {
        packages.myPACKAGE = inputs.wrapper-modules.wrappers.PACKAGE.wrap {
            inherit pkgs;
            settings = {
            };
        };
    }; 
}
