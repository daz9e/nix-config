{ self, pkgs, agenix, home-manager, ... }:
{
  imports = [
    home-manager.darwinModules.home-manager
  ];

  system.primaryUser = "daze";

  users.users.daze = {
    name = "daze";
    home = "/Users/daze";
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.fastfetch
    pkgs.syncthing-macos

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

    pkgs.go
    pkgs.nodejs
    pkgs.php
    pkgs.php84Packages.composer
    pkgs.pnpm
    pkgs.cmake
    pkgs.python3

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
    r = "sudo darwin-rebuild switch --flake $HOME/nix#macbook";
    rrpi = "nix run nixpkgs#nixos-rebuild -- switch --flake $HOME/nix#rpi --target-host root@192.168.1.7 --target-host root@192.168.1.7";
  };

  programs.zsh.enable = true;

  security.sudo.extraConfig = ''
    Defaults secure_path="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  '';

  nix = {
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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.daze = import ./home.nix;
}
