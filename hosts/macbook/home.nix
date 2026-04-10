{ pkgs, ... }:
let
  ghosttyCursorShaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "4faa83e4b9306750fc8de64b38c6f53c57862db8";
    hash = "sha256-ruhEqXnWRCYdX5mRczpY3rj1DTdxyY3BoN9pdlDOKrE=";
  };
in
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
      lg() { lazygit }
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-b";
    terminal = "tmux-256color";
    escapeTime = 0;
    historyLimit = 10000;
    extraConfig = ''
      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # New window keeps current path
      bind c new-window -c "#{pane_current_path}"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # Status bar
      set -g status-position bottom
      set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
      set -g status-left '#[bold] #S '
      set -g status-right '#[fg=#a6e3a1] %H:%M #[fg=#89b4fa] %d-%b '
      set -g window-status-current-format '#[fg=#cba6f7,bold] #I:#W '
      set -g window-status-format '#[fg=#6c7086] #I:#W '
      set -g status-left-length 30
      set -g status-right-length 40

      # True color
      set -as terminal-overrides ',*:Tc'

      # Pane borders
      set -g pane-border-style 'fg=#313244'
      set -g pane-active-border-style 'fg=#cba6f7'
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      zlo = {
        hostname = "s4.zloserver.com";
        port = 41230;
        user = "root";
      };
      rpi = {
        hostname = "192.168.1.7";
        user = "root";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      macos-option-as-alt = true;
      font-size = 16;
      maximize = true;
      custom-shader-animation = "always";
      custom-shader = [
        "shaders/cursor_warp.glsl"
        "shaders/ripple_cursor.glsl"
      ];
    };
  };

  xdg.configFile."ghostty/shaders".source = ghosttyCursorShaders;
}
