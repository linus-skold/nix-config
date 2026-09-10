{ self, inputs, ...}: {

    flake.nixosModules.lutris = { pkgs, lib, ... }: {
        environment.systemPackages = with pkgs; [
            # steamSupport defaults to true, which pulls the whole Steam stack
            # into Lutris' FHS env (+163 MiB download, +500 MiB on disk) so
            # Lutris can launch Steam games. zephyrusSteam is commented out, so
            # that is dead weight. Flip back to true if Steam is ever enabled.
            (lutris.override { steamSupport = false; })

            # Lutris shells out to winetricks for per-prefix tweaks (fonts,
            # DLL overrides) and does not vendor it.
            winetricks
        ];

        # No system wine here on purpose: the nixpkgs lutris is a buildFHSEnv
        # with multiArch = true, so the Wine runners Lutris downloads itself
        # (wine-ge, lutris-wine) run fine inside it. Adding wineWowPackages
        # would cost ~680 MiB of downloads to duplicate what Lutris manages.

        # Battle.net still ships 32-bit components, and the 32-bit Vulkan/GL
        # driver needs to exist outside the FHS env. mkDefault so this module
        # stays self-contained without fighting a host that already sets it.
        hardware.graphics.enable32Bit = lib.mkDefault true;
    };
}
