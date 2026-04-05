let
  daze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiL7EzQF7kBBfQDU2R8crMFvVrEZTslH1WcQJylxrQ9";

  rpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEA3NwJvlPzcbxNBDaSIDGNh2J4DnliJR7XDFCgr747T root@rpi";

  allKeys = [ daze rpi ];
in
{
  "wifi-password.age".publicKeys = allKeys;
}
