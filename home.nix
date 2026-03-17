{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      c() { claude "$@"; }
      sus() { claude --dangerously-skip-permissions "$@"; }
    '';
  };

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
