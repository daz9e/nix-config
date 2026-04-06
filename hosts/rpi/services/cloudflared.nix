{ self, config, ... }:
{
  age.secrets.cloudflared-creds.file = "${self}/secrets/cloudflared.age";

  services.cloudflared = {
    enable = true;
    tunnels = {
      "cc5c8f0b-4e49-4804-9045-9b81e52c1bec" = {
        credentialsFile = config.age.secrets.cloudflared-creds.path;
        ingress = {
          "vw.daz9e.space" = "http://localhost:8222";
          "git.daz9e.space" = "http://localhost:3001";
          "paper.daz9e.space" = "http://localhost:28981";
        };
        default = "http_status:404";
      };
    };
  };
}
