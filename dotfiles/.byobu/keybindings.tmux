unbind-key -n C-a
set -g prefix ^A
set -g prefix2 F12
bind a send-prefix

bind-key -T copy-mode-vi 'Escape' send-keys -X cancel
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection
bind-key -T copy-mode-vi C-v send-keys -X begin-selection \; send-keys -X rectangle-toggle
