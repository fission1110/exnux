# Exnux (Ex)ploit li(nux)
Exnux is a Personal Development Environment (PDE) and Capture the Flag (CTF) platform built in a docker image

I got sick of not having my CTF tools at work and my dev tools on CTF's. This allows me to have a very consistent environment across all my computers.

Clone this and drop your own dotfiles, add/remove tools to make it your own.

Centered around neovim, r2, ghidra, gdb(pwdbg), metasploit, burp, etc

The host OS filesystem is mounted inside the docker container to `~/root` and `~/home`.


## Install:
```
curl https://raw.githubusercontent.com/fission1110/exnux/master/infect.sh | bash
```
## Uninstall:
```
exnux disinfect
```

## Tools
- Neovim
- Radare2
- American Fuzzy Lop plus plus (afl++)
- Ghidra
- Metasploit
- GDB (with pwndbg integrated)
- John the Ripper (john)
- hashcat
- Procyon (Java Decompiler)
- Burp
- OWASP ZAP
- BeEF (Browser Exploitation Framework)
- GoBuster (Directory fuzzing)
- Nikto
- WPScan (Wordpress scanning)
- hydra (Bruteforcing)
- chepy (CyberChef like tool in python)
- Alacritty (Terminal)
- Lemonade (Copy/Paste over SSH)
- Wireshark
- zsh
- frida
- nmap
- sqlmap
- p0f
- ophcrack
- openvpn
- And full toolchains for various languages

## Security
This docker image is intended to make changes to your host filesystem and has access to your docker socket file so escapes are trivial.

Sudo has no password for now, which is dangerous. nonroot user is effectively root.

