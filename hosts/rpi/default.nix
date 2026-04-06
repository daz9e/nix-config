{ self, config, pkgs, lib, agenix, ... }:
let
  dataDiskUuid = "24982dc0-36bf-40d8-9187-2816437247fd";
in
{
  imports = [
    ./services/adguard.nix
    ./services/vaultwarden.nix
    ./services/cloudflared.nix
    ./services/forgejo.nix
    # ./services/paperless.nix
    ./services/money-convert.nix
    # ./services/immich.nix
  ];

  networking.hostName = "rpi";

  age.secrets.wifi-env = {
    file = "${self}/secrets/wifi-password.age";
  };

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [
        config.age.secrets.wifi-env.path
      ];
      profiles.Home = {
        connection = {
          id = "$WIFI_SSID";
          type = "wifi";
        };
        wifi.ssid = "$WIFI_SSID";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PSK";
        };
      };
    };
  };

  users.users.daze = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9"
  ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    htop
    tree
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/${dataDiskUuid}";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  boot.loader.raspberry-pi.bootloader = "kernel";

  system.stateVersion = "25.11";
}
