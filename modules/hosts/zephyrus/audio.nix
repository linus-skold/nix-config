{ self, inputs, ...}: {

    flake.nixosModules.zephyrusAudio = { pkgs, ... }: {

        # The ALC285 in this laptop attenuates in the codec/amp, and its taper
        # eats the top and bottom of the range: turning the volume down makes
        # the speakers sound muffled and boxy instead of just quieter. Pin the
        # hardware mixer wide open and let PipeWire scale the samples in
        # software, which is linear and keeps the tone intact.
        # NOTE: this must match the *device* (the card), not the node/stream.
        # PipeWire's ALSA backend (ACP) decides at profile/route-build time
        # whether to bind the hardware "Master" mixer as the volume control;
        # by the time a node exists that decision is already made, so a
        # node.name match here is a silent no-op (confirmed: wpctl volume
        # still dragged `amixer -c 2 sget Master` 1:1 with it applied).
        services.pipewire.wireplumber.extraConfig."51-alsa-soft-mixer" = {
            "monitor.alsa.rules" = [
                {
                    matches = [
                        { "device.name" = "~alsa_card\\..*"; }
                    ];
                    actions.update-props = {
                        "api.alsa.soft-mixer" = true;
                    };
                }
            ];
        };

        # alsamixer/amixer for inspecting the hardware controls directly.
        environment.systemPackages = [ pkgs.alsa-utils ];

        # With the hardware mixer pinned (above), its level needs to survive
        # a reboot too, or the codec comes back up at its power-on default
        # and we're back to a non-max Master fighting the soft volume curve.
        # This persists ALSA mixer state across boots (restores on start,
        # saves on shutdown) via /var/lib/alsa/asound.state.
        # NOTE: this is independent of hardware.alsa.enable, which must stay
        # off here — enabling it would set services.pipewire.enable = false.
        hardware.alsa.enablePersistence = true;
    };
}
