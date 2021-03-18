{ stdenv, cmake, cairo, fetchFromGitHub, libxkbcommon, libudev,
  meson, ninja, pkgconfig, wlroots, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "wio";
  version = "20201101";

  src = fetchGit {
    url = "https://git.sr.ht/~sircmpwn/wio";
    rev = "31b742e473b15a2087be740d1de28bc2afd47a4d";
  };

  buildInputs = [ wlroots cmake cairo wayland wayland-protocols libxkbcommon libudev ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  meta = with stdenv.lib; {
    description = "A Plan 9 type window manager for wlroots";
    homepage = "https://wio-project.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tgunnoe ];
    platforms = with platforms; linux;
  };
}
