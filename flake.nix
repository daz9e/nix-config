{
  description = "daze macbook nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    money-convert.url = "github:daz9e/currency-converter";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, nixos-raspberrypi, agenix, money-convert }:
  let
    homeManagerConfig = import ./home.nix;
    configuration = { pkgs, ... }: {
      system.primaryUser = "daze";

      users.users.daze = {
        name = "daze";
        home = "/Users/daze";
      };
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.vim
        pkgs.fastfetch
        pkgs.syncthing-macos

        # CLI tools
        pkgs.gh
        pkgs.htop
        pkgs.neovim
        pkgs.helix
        pkgs.fzf
        pkgs.fd
        pkgs.ripgrep
        pkgs.tree
        pkgs.wget
        pkgs.ffmpeg
        pkgs.sshpass
        pkgs.zoxide
        pkgs.opencode
        pkgs.codex
        pkgs.lazygit
        agenix.packages.aarch64-darwin.default

        # Dev
        pkgs.go
        pkgs.nodejs
        pkgs.php
        pkgs.php84Packages.composer
        pkgs.pnpm
        pkgs.cmake
        pkgs.python3
        pkgs.flutter


        # Apps
        pkgs.bitwarden-desktop
        pkgs.google-chrome
        pkgs.alacritty
      ];

      homebrew = {
        enable = true;
        brews = [
          "poppler"
          "mole"
        ];
        casks = [
          "discord"
          "iterm2"
          "telegram"
          "orbstack"
          "postman"
          "git-credential-manager"
          "obsidian"
          "zen"
          "raycast"
          "claude-code"
          "arduino-ide"
          "lm-studio"
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.defaults = {
        # dock.autohide = false;
      };

      environment.shellAliases = {
        rebuild = "sudo darwin-rebuild switch --flake $HOME/nix#macbook";
        rebuild-rpi = "nix run nixpkgs#nixos-rebuild -- switch --flake $HOME/nix#rpi --target-host root@192.168.1.7";
        rpi = "ssh rpi.local";
      };

      programs.zsh.enable = true;

     security.sudo.extraConfig = ''
        Defaults secure_path="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      '';

      nix = {
        # Necessary for using flakes on this system.
        settings = {
          experimental-features = "nix-command flakes";
          trusted-users = [ "@admin" ];
        };

        linux-builder = {
          enable = true;
          ephemeral = true;
          maxJobs = 4;
          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 15 * 1024;
                memorySize = 8 * 1024;
              };
              cores = 6;
            };
          };
        };
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;
    
    };
  in
  {
    nixosConfigurations."rpi" = nixos-raspberrypi.lib.nixosSystemFull {
      specialArgs = inputs // { inherit self; };
      modules = [
        nixos-raspberrypi.nixosModules.sd-image
        agenix.nixosModules.default
        money-convert.nixosModules.default
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

    images.rpi = self.nixosConfigurations.rpi.config.system.build.sdImage;

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "daze";
            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.daze = homeManagerConfig;
        }
      ];
    };
  };
}
