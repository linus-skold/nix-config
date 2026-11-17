{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Upstream's own flake. It carries its own locked nixpkgs, so llama.cpp is
    # insulated from `nix flake update nixpkgs` and only moves when asked:
    #   nix flake update llama-cpp
    llama-cpp.url = "github:ggml-org/llama.cpp";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";

    wrapper-modules.url = "path:/home/linus/Development/nix-wrapper-modules";

    zen-browser.url = "github:youwen5/zen-browser-flake";

    battlenet.url = "github:linus-skold/battlenet.nix";
  };

  # NOTE: nixConfig is ignored for non-trusted users (trusted-users = root here),
  # so these are also set via nix.settings in the NixOS modules, which is what
  # actually takes effect. Kept for anyone consuming this flake as a trusted user.
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
