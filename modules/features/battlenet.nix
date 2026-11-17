{ self, inputs, ... }: {
  # Thin wrapper so hosts just import self.nixosModules.battlenet and then
  # configure `programs.battlenet.games.<product>.enable = true;` themselves.
  # The upstream module (programs.battlenet.*) does the actual work.
  flake.nixosModules.battlenet = {
    imports = [ inputs.battlenet.nixosModules.default ];
  };
}
