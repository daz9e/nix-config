{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "zloserver";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.daze = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHcdeukE4Ocv7YTuQHB/p/gIun3QRD/CJLF8PwGw3is daze@rpi"
    ];
  };

  # restic user
  users.groups.restic = {};

  users.users.restic = {
    isNormalUser = true;
    group = "restic";
    createHome = true;
    home = "/var/lib/restic";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmm8v4Sk3eNm1nZdiO1A/0WkERCPggBpVyBZ0JNhp/o restic-zloserver"
    ];
  };

  systemd.tmpfiles.rules = [
      "d /mnt/data/restic 0750 restic restic - -"
      "d /mnt/data/restic/rpi-data 0750 restic restic - -"
    ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9"
  ];

  services.openssh = {
    enable = true;
    ports = [ 41230 ];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      GatewayPorts = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [ 41230 41231 ];

  environment.systemPackages = with pkgs; [
    vim
    htop
    tree
    wget
    git
    curl
    tmux
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/205ccad1-88ed-4c02-8e43-d8655144118b";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "daze" ];
  };

  system.stateVersion = "25.11";
}
