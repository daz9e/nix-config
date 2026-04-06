{ self, config, ... }:
{
  age.secrets.money-convert-token = {
    file = "${self}/secrets/money-convert-token.age";
    mode = "0444";
  };

  services.money-convert = {
    enable = true;
    tokenFile = config.age.secrets.money-convert-token.path;
    defaultCurrency = "RSD";
  };
}
