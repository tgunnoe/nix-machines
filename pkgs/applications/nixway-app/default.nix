{ pkgs, stdenv }:

let
  config = pkgs.substituteAll {
      name = "sway-config";
      src = ./config;
      background = "/home/tgunnoe/src/configurations/conf.d/polyscape-background-15.png";
      term = "${pkgs.termite}/bin/termite";
  };
in
pkgs.symlinkJoin {
  name = "sway";
  paths = [ pkgs.sway ];
  buildInputs = with pkgs; [ makeWrapper ];
  propagatedBuildInputs = with pkgs; [ hello ];
  postBuild = ''
    wrapProgram $out/bin/sway \
    --add-flags "--config ${config}"
  '';


  meta = with stdenv.lib; {
    homepage = "https://github.com/tgunnoe/nix-machines/";
    description = "Test nix+sway app";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };

}
