- randomize metasploit postgres password
- Attempt to reduce size of image (currently ~12g) without compromising functionality
- Clean up neovim config and think out hotkeys better
- Find a better way to host/load completed image so we don't need to recompile on all systems
- Maybe switch to a modern plugin management system for vim plugins 
- Test sound or find a better way to implement sound
- Maybe integrate postgres into the image so we don't need two containers
    - Or at least put it on a non standard port
- Fix permissions across host/vm mounts. Not sure of a good solution for this one.
    - Mounting /etc/passwd and /etc/group not a great option because all the things built inside of the Dockerfile will need to be chmoded (slow, balloons the image)
    - Changing the uid/gid isn't a great option for the same reason