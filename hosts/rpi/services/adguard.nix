{ ... }:
{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;
    settings = {
      dns = {
        upstream_dns = [
          "9.9.9.9"
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };
      filters = map (url: { enabled = true; inherit url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
