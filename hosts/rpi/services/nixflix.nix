{ self, config, ... }:
{
  age.secrets.nixflix-api-key.file = "${self}/secrets/nixflix-api-key.age";

  nixflix = {
    enable = true;
    mediaDir = "/mnt/sd/media";
    stateDir = "/mnt/data/nixflix";

    sonarr = {
      enable = true;
      config.apiKey._secret = config.age.secrets.nixflix-api-key.path;
    };

    radarr = {
      enable = true;
      config.apiKey._secret = config.age.secrets.nixflix-api-key.path;
    };

    prowlarr = {
      enable = true;
      config.apiKey._secret = config.age.secrets.nixflix-api-key.path;
    };


    torrentClients.qbittorrent = {
      enable = true;
      password._secret = config.age.secrets.nixflix-api-key.path;
    };
  };

  services.qbittorrent.serverConfig.Preferences.WebUI.Username = "daze";
}
