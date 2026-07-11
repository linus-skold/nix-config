{ self, inputs, ...}: {
    flake.nixosModules.ghostty = { pkgs, ... }: {
        programs.ghostty = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
        };
    };

    perSystem = { pkgs, lib, ... }: {
        packages.myGhostty = inputs.wrapper-modules.wrappers.ghostty.wrap {
            inherit pkgs;
            settings = {
            };
        };
    }; 
}
