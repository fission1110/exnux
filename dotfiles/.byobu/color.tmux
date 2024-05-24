#!/usr/bin/env bash
BYOBU_DARK="\#0F1C1E"
BYOBU_LIGHT="\#EEEEEE"
BYOBU_ACCENT="\#587b7b"
BYOBU_HIGHLIGHT="\#DD4814"

# Nightfox colors for Tmux
# Style: terafox
# Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/terafox/nightfox_tmux.tmux
set -g mode-style "fg=#5a93aa,bg=#cbd9d8"
set -g message-style "fg=#5a93aa,bg=#cbd9d8"
set -g message-command-style "fg=#5a93aa,bg=#cbd9d8"
set -g pane-border-style "fg=#cbd9d8"
set -g pane-active-border-style "fg=#5a93aa"
set -g status "on"
set -g status-justify "left"
set -g status-style "fg=#5a93aa,bg=#0f1c1e"
set -g status-left-length "100"
set -g status-right-length "100"
set -g status-left-style NONE
set -g status-right-style NONE
set -g status-left "#[fg=#2f3239,bg=#5a93aa,bold] #S #[fg=#5a93aa,bg=#0f1c1e,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#0f1c1e,bg=#0f1c1e,nobold,nounderscore,noitalics]#[fg=#5a93aa,bg=#0f1c1e] #{prefix_highlight} #[fg=#cbd9d8,bg=#0f1c1e,nobold,nounderscore,noitalics]#[fg=#5a93aa,bg=#cbd9d8] %Y-%m-%d  %I:%M %p #[fg=#5a93aa,bg=#cbd9d8,nobold,nounderscore,noitalics]#[fg=#2f3239,bg=#5a93aa,bold] #h "
setw -g window-status-activity-style "underscore,fg=#587b7b,bg=#0f1c1e"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#587b7b,bg=#0f1c1e"
setw -g window-status-format "#[fg=#0f1c1e,bg=#254147,nobold,nounderscore,noitalics]#[fg=#5a93aa,bg=#254147,nobold,nounderscore,noitalics] #I  #W #F #[fg=#254147,bg=#0f1c1e,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#5a93aa,bg=#0f1c1e,nobold,nounderscore,noitalics]#[fg=#5a93aa,bg=#cbd9d8,bold] #I  #W #F #[fg=#0f1c1e,bg=#5a93aa,nobold,nounderscore,noitalics]"
