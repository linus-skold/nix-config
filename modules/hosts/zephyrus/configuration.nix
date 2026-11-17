{ self, inputs, ...}: {
    
    flake.nixosModules.zephyrusConfig = { pkgs, lib, config, ...}: {
  imports = [
    self.nixosModules.zephyrusHardware
    self.nixosModules.zephyrusAudio
    self.nixosModules.zephyrusSteam
    self.nixosModules.battlenet
    self.nixosModules.llama
    self.nixosModules.lutris
    self.nixosModules.zephyrusWireguard
    self.nixosModules.niri
    self.nixosModules.noctalia
    self.nixosModules.ghostty
    self.nixosModules.development
    self.nixosModules.neovim
    self.nixosModules.dotfiles
    self.nixosModules.mise
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  #networking.networkmanager.enable = true;
  #networking.wireless.iwd.enable = true;
  networking.hostName = "zephyrus-2025";
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
    nushell
    lshw
    usbutils
    supergfxctl
    python314
    pipx
    file
    brave 
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdePackages.dolphin
    qt6Packages.qt6ct
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

console.font = "fira-code";
 
 # amdgpu drives the panel in Hybrid mode (see supergfxd below); nvidia is
 # only engaged via PRIME render offload, so the dGPU no longer has to also
 # carry the compositor/desktop while a game is maxing it out.
 services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

 hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;

    nvidia.modesetting.enable = true;
    nvidia.open = true;
    nvidia.nvidiaSettings = true;

    # Bus IDs for this host (RTX 5070 at 64:00.0, AMD iGPU at 65:00.0 -
    # decimal 100/101). Offload lets specific processes (e.g. Steam/games)
    # render on the dGPU while everything else stays on the iGPU.
    nvidia.prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      nvidiaBusId = "PCI:100:0:0";
      amdgpuBusId = "PCI:101:0:0";
    };

    bluetooth.enable = true;
  };

  programs.nix-ld.enable = true;
  services = {
    asusd.enable = true;
    # Controls the MUX switch (Hybrid/Integrated/dGPU-only) on this ASUS
    # laptop. Needs `supergfxctl -m Hybrid` + logout/reboot once to actually
    # flip the mux so the panel is driven by amdgpu instead of nvidia.
    supergfxd.enable = true;
    gpm.enable = true;
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

    programs.battlenet = {
      enable = true;
      games = {
        wow_anniversary.enable = true;
        wowf.enable = true;
      };
    };

    system.stateVersion = "25.11"; # Did you read the comment?

  };

}
