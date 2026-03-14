{
  description = "daze macbook nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
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
        pkgs.sshpass
        pkgs.zoxide
        pkgs.opencode

        # Dev
        pkgs.go
        pkgs.nodejs
        pkgs.php
        pkgs.php84Packages.composer
        pkgs.pnpm

        # Apps
      ];

      homebrew = {
        enable = true;
        brews = [
          "poppler"
        ];
        casks = [
          "discord"
          "iterm2"
          "telegram"
          "orbstack"
          "postman"
          "git-credential-manager"
          "obsidian"
          # "ghostty"
          "zen"
          "raycast"
          "claude-code"
          "orbstack"
        ];
        # masApps = {
        #   "Xcode" = 497799835;
        # };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.defaults = {
        # dock.autohide = false;
      };

      environment.shellAliases = {
        rebuild = "sudo darwin-rebuild switch --flake $HOME/nix#macbook";
        rpi = "ssh rpi.local";
      };

      programs.zsh = {
        enable = true;
        interactiveShellInit = ''
          eval "$(zoxide init zsh)"
          c() { claude "$@"; }
          sus() { claude --dangerously-skip-permissions "$@"; }
        '';
      };

     security.sudo.extraConfig = ''
        Defaults secure_path="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;
    
    };
  in
  {
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
          home-manager.users.daze = { pkgs, ... }: {
            home.stateVersion = "25.11";
            programs.ghostty = {
              enable = true;
              package = pkgs.ghostty-bin;
              settings = {
                macos-option-as-alt = true;
                font-size = 16;
                maximize = true;
              };
            };
          };
        }
      ];
    };
  };
}
