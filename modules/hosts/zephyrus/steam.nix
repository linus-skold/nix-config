{ self, inputs, ... }: {
  flake.nixosModules.zephyrusSteam = { pkgs, lib, config, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      # Adds GE-Proton as a selectable compatibility tool (Steam > game
      # properties > Compatibility) alongside Valve's stock Proton builds.
      # It tracks upstream Proton but backports/patches in fixes and extra
      # compat layers (e.g. for anticheat, FSR, media codecs) well before
      # Valve's releases pick them up.
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    # gamescope is the SteamOS-style compositor/session Steam can launch
    # games through (micro-compositor, resolution/FSR scaling, HDR); useful
    # on niri since games don't always behave well under a tiling WM.
    programs.gamescope.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
