{ stdenv, gcc, pkgs, fetchFromGitHub, cmake, makeWrapper, gtkmm3, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "arma3-unix-launcher";
  version = "20201204";

  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = "arma3-unix-launcher";
    rev = "2b4ee63759d167cab8d729c095e066b27298406b";
    sha256 = "uACEKxGS7MVEmcbB6VzxWX81K7LxK5eAOJfYYn4QQ1E=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig gcc ];

  buildInputs = with pkgs; [
    qt5.qtbase
    fmt
    git
  ];
#  dontStrip = true;
 # CMAKE_CXX_FLAGS = "-std=gnu++11 -g -ggdb";

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/usr/bin $out/usr/share/arma3-unix-launcher
    install -Dm755 arma3-unix-launcher "$out/usr/bin/arma3-unix-launcher"
    install -Dm755 MainForm.glade "$out/usr/share/arma3-unix-launcher/MainForm.glade"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/muttleyxd/arma3-unix-launcher;
    description = "Arma 3 unix launcher";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
