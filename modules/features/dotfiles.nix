{ ... }: {
    flake.nixosModules.dotfiles = { pkgs, lib, ... }:
        let
            dotfiles = pkgs.fetchgit {
                url = "https://github.com/linus-skold/dotfiles.git";
                rev = "7c668d35798302a1bed5f4d904cb3c5f7e348fb2";
                hash = "sha256-LP0cWZC/WsslzDYeXYv1pDkmny0R9LIHfZ/LIh3M1bE=";
            };
        in {
            system.activationScripts.dotfiles = lib.stringAfter [ "users" "groups" ] ''
                ln -sfn ${dotfiles} /home/linus/.dotfiles
                chown -h linus:users /home/linus/.dotfiles
            '';
        };
}
