{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ../develop /*./xmonad*/ ./im ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = true;

  boot = {

    kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;

  };

  environment = {

    etc = {
      "xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-icon-theme-name=Papirus
          gtk-theme-name=Adapta
          gtk-cursor-theme-name=Adwaita
        '';
        mode = "444";
      };
    };

    sessionVariables = {
      # Theme settings
      QT_QPA_PLATFORMTHEME = "gtk2";

      GTK2_RC_FILES =
        let
          gtk = ''
            gtk-icon-theme-name="Papirus"
            gtk-cursor-theme-name="Adwaita"
          '';
        in
        [
          ("${pkgs.writeText "iconrc" "${gtk}"}")
          "${pkgs.adapta-gtk-theme}/share/themes/Adapta/gtk-2.0/gtkrc"
          "${pkgs.gnome3.gnome-themes-extra}/share/themes/Adwaita/gtk-2.0/gtkrc"
        ];
    };

    systemPackages = with pkgs; [
      adapta-gtk-theme
      cursor
      dzen2
      cage
      chromium
      electrum
      feh
      ffmpeg-full
      gtk3
      glxinfo
      gnome3.adwaita-icon-theme
      #gnome3.networkmanagerapplet
      gnome-themes-extra
      gimp
      imagemagick
      imlib2
      inkscape
      libreoffice
      librsvg
      libsForQt5.qtstyleplugins
      manpages
      mupdf
      nomacs
#      nyxt
      papirus-icon-theme
      pulsemixer
      pavucontrol
      qt5.qtgraphicaleffects
      sddm-chili
      stdmanpages
      transmission-gtk
      xsel
      untrunc
      zathura
      pcmanfm
      vlc
    ];
  };

  services.xbanish.enable = true;

  services.gnome3.gnome-keyring.enable = true;

  services.xserver = {
    enable = false;

    libinput.enable = true;

    displayManager.sddm = {
      enable = false;
      theme = "chili";
    };
  };
}
