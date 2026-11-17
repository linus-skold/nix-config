{ self, inputs, ... }: {
  flake.nixosModules.development = { pkgs, lib, config, ... }: {
    environment.systemPackages = with pkgs; [
      # Neovim already in system packages, just adding language servers

      # Language servers
      rust-analyzer
      typescript-language-server
      vscode-langservers-extracted
      pyright
      lua-language-server
      gopls
      clang-tools
      nil # Nix language server

      nixfmt
      nixd

      # Formatters
      stylua # Lua formatter
      prettierd # JS/TS/CSS/HTML/JSON/YAML/Markdown formatter

      # Build tools & essentials for language support
      nodejs
      ruby
      lua
      go
#      rustup
      gcc
      clang
      cmake
      zig
      gnumake
      libtool


      # Dev utilities
      git
      gh
      ripgrep
      fzf
      fd
      tree-sitter
      zoxide
      herdr
      lazygit
      claude-code
    ];

    # Optional: Configure user-level neovim if needed
    # (Remove or adjust based on your neovim config location)
    # programs.neovim = { ... };
  };
}
