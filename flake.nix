{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      commonModule =
        { lib, ... }:
        {
          options.programs.rootchat = {
            enable = lib.mkEnableOption "Root Chat" // {
              default = false;
            };
            shaHash = lib.mkOption {
              type = lib.types.str;
              description = "sha hash for the root appimage download";
              default = lib.fakeHash;
            };
          };
        };
    in
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      packages.${system} = {
        rootchat = nixpkgs.legacyPackages.${system}.callPackage ./package.nix { };
        default = self.packages.${system}.rootchat;
      };
      homeModules.default =
        { config, lib, ... }:
        {
          imports = [ commonModule ];
          config = lib.mkIf config.programs.rootchat.enable {
            home.packages = [
              (nixpkgs.legacyPackages.${system}.callPackage ./package.nix { shaHash = config.programs.rootchat.shaHash; })
              # (self.packages.${system}.rootchat.override { shaHash = config.programs.rootchat.shaHash; })
            ];
          };
        };
      nixosModules.default =
        { config, lib, ... }:
        {
          imports = [ commonModule ];
          config = lib.mkIf config.programs.rootchat.enable {
            environment.systemPackages = [
              (nixpkgs.legacyPackages.${system}.callPackage ./package.nix { shaHash = config.programs.rootchat.shaHash; })
              # (self.packages.${system}.rootchat.override { shaHash = config.programs.rootchat.shaHash; })
            ];
          };
        };
    });
}
