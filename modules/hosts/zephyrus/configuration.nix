{ self, inputs, ...}: {
    
    flake.nixosModules.zephyrusConfig = { pkgs, lib, config, ...}: {
  imports = [
    self.nixosModules.zephyrusHardware
    self.nixosModules.zephyrusWireguard
    self.nixosModules.niri
    self.nixosModules.noctalia
    self.nixosModules.ghostty
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  #networking.networkmanager.enable = true;
  #networking.wireless.iwd.enable = true;
  networking.hostName = "nixos";
  security.rtkit.enable = true;
  security.polkit.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.linus = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = "Linus";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    brightnessctl
    zlib
    zstd
    curl
    asusctl
    fastfetch
    jq
    socat
    gnupg
    impala
    iw
    arp-scan
    nmap
    aria2
    unzip
    discord
    firefox
    nixfmt
    nushell
    zoxide
    zellij
    git
    mise
    neovim
    lshw
    usbutils
    supergfxctl
    zig
    python314
    pipx
    opencode
    herdr
    claude-code
    lazygit
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  console = {
    font = "fira-code";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      #driSupport = true;
      #driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      #package = config.boot.kernelPackages.nvidiaPackages.stable;

    };
    bluetooth = {
      enable = true;
    };
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };

        services = {
            asusd.enable = true;
            gpm.enable = true;
            libinput = {
                enable = true;
                touchpad = {
                    naturalScrolling = false;
                };
            };
            # xserver = {
            #     enable = true;
            #     videoDrivers = [ "nvidia" ];
            #     xkb = {
            #         layout = "us,se";
            #         variant = "";
            #         options = "grp:win_space_toggle";
            #     };
            # };
#            blueman.enable = true;
            # pipewire = {
            #     enable = true;
            #     alsa.enable = true;
            #     alsa.support32Bit = true;
            #     pulse.enable = true;
            # };
            openssh = {
                enable = true;
                openFirewall = true;
                settings = {
                    PasswordAuthentication = true;
                    KbdInteractiveAuthentication = false;
                    PermitRootLogin = "no";
                    AllowUsers = ["linus"];
                    MaxAuthTries = 3;
                };
            };
        };

        system.stateVersion = "25.11"; # Did you read the comment?

    };

}
