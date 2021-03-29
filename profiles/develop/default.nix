{ pkgs, ... }:

with pkgs;

let
  my-python-packages = python-packages: with python-packages; [
    i3ipc
    requests
    pip
  ];
  python-with-my-packages = python38.withPackages my-python-packages;
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
    gnumake
    docker

    file
    gcc
    git-crypt
    gnupg
    less
    ncdu
    nixpkgs-review
    gopass

    tetex
    texlive.combined.scheme-tetex
    (texlive.combine { inherit (texlive) scheme-medium xifthen ifmtarg framed paralist titlesec; })
    rubber
    pandoc

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
