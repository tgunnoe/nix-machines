{ stdenv, fetchFromGitHub, fetchurl, makeWrapper, jdk11 }:

stdenv.mkDerivation rec {
  pname = "faforever-downlord-client";

  version = "1.4.0";

  # src = fetchFromGitHub {
  #   owner = "faforever";
  #   repo = "downlords-faf-client";
  #   rev = "v${version}";
  #   sha256 = "1wiq4wh037vjzlvcr6wbvr937f1ii7naxa1liis8561q3c5pnygf";
  # };
  src = fetchurl {
    url = "https://github.com/FAForever/downlords-faf-client/releases/download/v1.4.0/dfc_unix_1_4_0.tar.gz";
    sha256 = "1z1qcq65bqnjzklgsykqlhbkzvsn9ic2ifqgyh2p46zhxddrdar1";
  };

  buildInputs = [ jdk11 makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out
    ln -sf $out/downlords-faf-client $out/bin/faforever
    wrapProgram $out/bin/faforever --set INSTALL4J_JAVA_HOME ${jdk11.home}

  '';


  meta = with stdenv.lib; {
    description = "Lobby client for Forged Alliance Forever";
    homepage = "https://github.com/faforever/downlords-faf-client";
    platforms = ["x86_64-linux"];
    license = licenses.mit;
  };

}
