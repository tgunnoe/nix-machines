final: prev: {
  sddm-chili =
    prev.callPackage ./applications/display-managers/sddm/themes/chili { };
  dejavu_nerdfont = prev.callPackage ./data/fonts/dejavu-nerdfont { };
  faforever = prev.callPackage ./games/faforever { };
  lzwolf = prev.callPackage ./games/lzwolf { };
  purs = prev.callPackage ./shells/zsh/purs { };
  pure = prev.callPackage ./shells/zsh/pure { };
  wii-u-gc-adapter = prev.callPackage ./misc/drivers/wii-u-gc-adapter { };
  libinih = prev.callPackage ./development/libraries/libinih { };
  steamcompmgr =
    prev.callPackage ./applications/window-managers/steamcompmgr { };
}
