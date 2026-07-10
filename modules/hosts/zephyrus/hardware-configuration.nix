{ self, inputs, ...}: {

    flake.nixosModules.zephyrusHardware = { config, lib, pkgs, modulesPath, ... }:
    {
        imports = [ 
            (modulesPath + "/installer/scan/not-detected.nix")
        ];
        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = { 
            device = "/dev/disk/by-uuid/49245ce5-ff75-4d4a-b98d-100fd9b4ef1a";
            fsType = "ext4";
        };

        fileSystems."/boot" = { 
            device = "/dev/disk/by-uuid/92A5-C1D1";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
