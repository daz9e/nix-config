{
  description = "daze macbook nix-darwin system flake";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-immich.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    money-convert.url = "github:daz9e/currency-converter";
    nixflix.url = "github:kiriwalawren/nixflix";
    nixflix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-immich, nix-homebrew, home-manager, nixos-raspberrypi, agenix, money-convert, nixflix, ... }:
  {
    nixosConfigurations."rpi" = nixos-raspberrypi.lib.nixosSystem {
      specialArgs = inputs // { inherit self; };
      modules = [
        nixos-raspberrypi.nixosModules.sd-image
        agenix.nixosModules.default
        money-convert.nixosModules.default
        inputs.nixflix.nixosModules.default
        {
          imports = with nixos-raspberrypi.nixosModules; [
            raspberry-pi-5.base
            raspberry-pi-5.page-size-16k
          ];
        }
        ./hosts/rpi
      ];
    };

    nixosConfigurations."zloserver" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/zloserver
      ];
    };

    nixosConfigurations."desktop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/desktop
      ];
    };

    images.rpi = self.nixosConfigurations.rpi.config.system.build.sdImage;

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      specialArgs = inputs // { inherit self; };
      modules = [
        ./hosts/macbook
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "daze";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
