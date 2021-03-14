{ pkgs, ... }:

with pkgs;

let
  my-python-packages = python-packages: with python-packages; [
    asyncio
    i3ipc
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in

{
  imports = [ ./zsh ./tmux ];

  # environment.shellAliases = { emacs = "$EDITOR"; pass = "gopass"; };

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -nw";
  };

  environment.systemPackages = with pkgs; [
    #clang
    cmake
    file
    gcc
    git-crypt
    gnupg
    less
    ncdu
    nixpkgs-review
    gopass
    rubber

    python-with-my-packages

    taskwarrior
    vit

    tig
    tokei
    wget

    tcpdump
  ];

  fonts = {
    fonts = [ pkgs.dejavu_nerdfont ];
    fontconfig.defaultFonts.monospace =
      [ "DejaVu Sans Mono Nerd Font Complete Mono" ];
  };

  documentation.dev.enable = true;

  programs.thefuck.enable = true;
  programs.firejail.enable = true;
  programs.mtr.enable = true;
}
