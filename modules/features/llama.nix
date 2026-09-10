{ self, inputs, ...}: {

    flake.nixosModules.llama = { pkgs, ... }: let
        system = pkgs.stdenv.hostPlatform.system;

        # The CUDA toolkit that llama.cpp was built against, taken from the
        # llama-cpp input's own locked nixpkgs. Same store paths as the main
        # nixpkgs today, but pinned alongside llama.cpp from here on, so a
        # routine `nix flake update nixpkgs` no longer re-downloads several GB.
        cudaPkgs = import inputs.llama-cpp.inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in {
        environment.systemPackages = [
            self.packages.${system}.llamaCpp
            cudaPkgs.cudaPackages.cudatoolkit
            cudaPkgs.cudaPackages.cudnn
            pkgs.llama-swap
        ];

        # llama.cpp itself is in no binary cache (upstream publishes none), so it
        # is always a local compile; the pin is what makes that rare. This cache
        # covers the CUDA-enabled *dependency* tree that upstream's `cuda` output
        # builds against, which cache.nixos.org does not always carry.
        # Set here, not in flake.nix's nixConfig: with trusted-users = root, Nix
        # ignores substituters declared by a flake.
        nix.settings = {
            extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
            extra-trusted-public-keys = [
                "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            ];
        };
    };

    perSystem = { pkgs, ... }: {
        packages.llamaCpp = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda;
    };
}
