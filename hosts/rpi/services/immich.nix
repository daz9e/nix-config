{ pkgs, nixpkgs-immich, ... }:
let
  immichPkgs = nixpkgs-immich.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.postgresql.ensureUsers = [
    {
      name = "immich";
      ensureClauses.superuser = true;
    }
  ];

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;
    package = immichPkgs.immich;
    openFirewall = true;
    mediaLocation = "/mnt/data/immich/data";
  };
}
