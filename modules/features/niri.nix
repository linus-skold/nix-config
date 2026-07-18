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
                    [ (lib.getExe pkgs.xwayland-satellite) ":0" ]
                ];

                environment.DISPLAY = ":0";

                input.keyboard = {
                    xkb.layout = "us,se";
                    xkb.variant = "";
                    xkb.options = "grp:win_space_toggle";
                };
                input.touchpad = {
                    tap = {};
                    dwt = {};
                    natural-scroll = {};
                    click-method = "clickfinger";
                };
               
               layout.gaps = 5;
                binds = {
                    "Mod+Return".spawn-sh = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myGhostty;
                    "Mod+Q".close-window = _: { };
                    "Mod+S".spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
                    "Mod+Shift+S".spawn = ["noctalia" "msg" "screenshot-region"];
                    "Mod+Ctrl+F".toggle-windowed-fullscreen = _: { };
                    "Mod+F".maximize-column = _: { };
                };

            };
        };
    }; 
}
