{ self, config, ... }:
{
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        DOMAIN = "git.daz9e.space";
        ROOT_URL = "https://git.daz9e.space/";
        HTTP_PORT = 3001;
        HTTP_ADDR = "127.0.0.1";
      };
      service = {
        DISABLE_REGISTRATION = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3001 ];
}
