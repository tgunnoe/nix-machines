{ pkgs, stdenv, sway }:

let
  config = ''
    set $mod Mod4
    bindsym $mod+space exec termite
    output * bg ~/Pictures/Wallpapers/1296328.jpg fill
  '';
in
pkgs.symlinkJoin {
  name = "nixway-app";
  paths = [ pkgs.sway ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/sway \
    --config ${config}
  '';
  meta = with stdenv.lib; {
    homepage = "https://github.com/tgunnoe/nix-machines/";
    description = "Test nix+sway app";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };

}
