{ ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/mnt/data/syncthing";
    configDir = "/mnt/data/syncthing/.config";
    guiAddress = "0.0.0.0:8384";
  };

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
