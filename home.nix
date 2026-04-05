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
