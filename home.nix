{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      macos-option-as-alt = true;
      font-size = 16;
      maximize = true;
    };
  };
}
