# { ... }: {
#     flake.nixosModules.ghostty = { pkgs, ... }: {
#         environment.systemPackages = [ pkgs.ghostty ];
#     };
# }

{ self, inputs, ...}: {
    flake.nixosModules.ghostty = { pkgs, lib, ... }: {
        environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myGhostty ];
    };

    perSystem = { pkgs, lib, ... }: {
        packages.myGhostty = inputs.wrapper-modules.wrappers.ghostty.wrap {
            inherit pkgs;
            settings = {
                font-size = 14;
                window-decoration = false;
            };
            keybindings."ctrl+shift+c" = "copy_to_clipboard";
        };
    };
}
