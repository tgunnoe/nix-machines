{ pkgs, ... }: {
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
    file
    git-crypt
    gnupg
    less
    ncdu
    gopass
    rubber
    taskwarrior
    tig
    tokei
    wget
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
