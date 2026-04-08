{ self, config, ... }:

{
  age.secrets.restic-password.file = "${self}/secrets/restic-password.age";

  age.secrets.restic-zloserver-key = {
    file = "${self}/secrets/restic-zloserver-key.age";
    owner = "root";
    group = "root";
    mode = "0400";
  };

  services.restic.backups.data = {
    initialize = true;
    repository = "sftp:zlo-restic:/mnt/data/restic/rpi-data";
    passwordFile = config.age.secrets.restic-password.path;
    paths = [ "/mnt/data" ];
    exclude = [ "/mnt/data/lost+found" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
    ];

    backupPrepareCommand = ''
      test -d /mnt/data
    '';
  };
}
