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
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9"
  ];

  services.openssh = {
    enable = true;
    ports = [ 41230 ];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 41230 ];

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
