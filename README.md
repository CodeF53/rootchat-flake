## Usage:
Add to your flake inputs
```nix
# flake.nix
{
  inputs = {
    rootchat = {
      url = "github:CodeF53/rootchat-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

<details>
<summary>install in a standard nixOS module</summary>

  ```nix
  # configuration.nix
  {
    imports = [
      inputs.rootchat.nixosModules.default
    ];
    programs.rootchat = {
      enable = true;
      shaHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  }
  ```
</details>

<details>
  <summary>install in a home manager module</summary>

  ```nix
  # home.nix
  {
    imports = [
      inputs.rootchat.homeModules.default
    ];
    programs.rootchat = {
      enable = true;
      shaHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  }
  ```
</details>

Root doesnt version their appimage downloads so you have to specify the `shaHash` yourself, just go ahead and rebuild with without specifying `shaHash` at first and it will tell you what hash you're supposed to use.