## Install:
curl https://raw.githubusercontent.com/fission1110/exnux/master/infect.sh | bash
## Uninstall:
exnux disinfect

- TODO: randomize metasploit postgres password
- TODO: Attempt to reduce size of image (currently ~12g) without compromising functionality
- TODO: Clean up neovim config and think out hotkeys better
- TODO: Find a better way to host/load completed image so we don't need to recompile on all systems
- TODO: Add documentation for hotkeys, configurations, and included tools
- TODO: Maybe switch to a modern plugin management system for vim plugins 
- TODO: Test sound or find a better way to impliment sound
- TODO: Maybe integrate postgres into the image so we don't need two containers
        - Or at least put it on a non standard port
- TODO: Fix permissions across host/vm mounts. Not sure of a good solution for this one.
