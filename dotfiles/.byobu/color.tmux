BYOBU_DARK="\#333333"
BYOBU_LIGHT="\#EEEEEE"
BYOBU_ACCENT="\#587b7b"
BYOBU_HIGHLIGHT="\#DD4814"

#!/usr/bin/env bash
# Nightfox colors for Tmux
# Style: terafox
# Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/terafox/nightfox_tmux.tmux
set -g mode-style "fg=#587b7b,bg=#cbd9d8"
set -g message-style "fg=#587b7b,bg=#cbd9d8"
set -g message-command-style "fg=#587b7b,bg=#cbd9d8"
set -g pane-border-style "fg=#cbd9d8"
set -g pane-active-border-style "fg=#587b7b"
set -g status "on"
set -g status-justify "left"
set -g status-style "fg=#587b7b,bg=#0f1c1e"
set -g status-left-length "100"
set -g status-right-length "100"
set -g status-left-style NONE
set -g status-right-style NONE
set -g status-left "#[fg=#2f3239,bg=#587b7b,bold] #S #[fg=#587b7b,bg=#0f1c1e,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#0f1c1e,bg=#0f1c1e,nobold,nounderscore,noitalics]#[fg=#587b7b,bg=#0f1c1e] #{prefix_highlight} #[fg=#cbd9d8,bg=#0f1c1e,nobold,nounderscore,noitalics]#[fg=#587b7b,bg=#cbd9d8] #fan_speed #cpu_temp load_average #disk_io #[fg=#587b7b,bg=#cbd9d8,nobold,nounderscore,noitalics]#[fg=#587b7b,bg=#cbd9d8] %Y-%m-%d  %I:%M %p #[fg=#587b7b,bg=#cbd9d8,nobold,nounderscore,noitalics]#[fg=#2f3239,bg=#587b7b,bold] #h "
setw -g window-status-activity-style "underscore,fg=#587b7b,bg=#0f1c1e"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#587b7b,bg=#0f1c1e"
setw -g window-status-format "#[fg=#cbd9d8,bg=#cbd9d8,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#0f1c1e,bg=#0f1c1e,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#0f1c1e,bg=#cbd9d8,nobold,nounderscore,noitalics]#[fg=#587b7b,bg=#cbd9d8,bold] #I  #W #F #[fg=#cbd9d8,bg=#0f1c1e,nobold,nounderscore,noitalics]"
