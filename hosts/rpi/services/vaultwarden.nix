{ self, config, ... }:
{
  age.secrets.vaultwarden-env.file = "${self}/secrets/vaultwarden.age";

  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      SIGNUPS_ALLOWED = true;
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8222 ];
}
