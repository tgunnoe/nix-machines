{ stdenv, gcc, pkgs, fetchFromGitHub, cmake, makeWrapper, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "argparse++";
  version = "20201204";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "argparse";
    rev = "9903a22904fed8176c4a1f69c4b691304b23c78e";
    sha256 = "uACEKxGS7MVEmcbB6VzxWX81K7LxK5eAOJfYYn4QQ1E=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig gcc ];

  buildInputs = with pkgs; [
    git
  ];
#  dontStrip = true;
 # CMAKE_CXX_FLAGS = "-std=gnu++11 -g -ggdb";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/p-ranav/argparse;
    description = "Argparse";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
  };
}
