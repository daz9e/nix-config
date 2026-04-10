{ ... }:
{
  services.autossh.sessions = [
    {
      name = "immich-tunnel";
      user = "daze";
      monitoringPort = 0;
      extraArguments = "-N -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R 0.0.0.0:41231:localhost:2283 -p 41230 daze@s4.zloserver.com";
    }
  ];
}
