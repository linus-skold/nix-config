{ self, inputs, ...}: {

    flake.nixosModules.niri = { pkgs, lib, ... }: {
        programs.niri = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
        };
    };

    perSystem = { pkgs, lib, ... }: {
        packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
            inherit pkgs;
            settings = {
                spawn-at-startup = [
                    (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia)
                ];

                input.keyboard = {
                    xkb.layout = "us,se";
                };
                input.touchpad = {
                    tap = {};
                    dwt = {};
                    natural-scroll = {};
                    click-method = "clickfinger";
                };
               
               layout.gaps = 5;
                binds = {
                    "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
                    "Mod+Q".close-window = _: { };
                    "Mod+S".spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
                    "Mod+Shift+S".spawn = ["noctalia" "msg" "screenshot-region"];
                };

            };
        };
    }; 
}
