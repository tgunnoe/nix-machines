{ lib, python3Packages, fetchFromGitHub }:


python3Packages.buildPythonApplication rec {
  pname = "i3-swallow";
  version = "202010107";

  src = fetchFromGitHub {
    owner = "jamesofarrell";
    repo = "i3-swallow";
    rev = "7a9faed693b0da7df762a095fed512eca8c6414c";
    sha256 = "bUWmH606sGsP+j45nZg60j+eKI1zhcSQ+v7VqONmCbs=";
  };

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  # Tests require access to a X session
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jamesofarrell/i3-swallow";
    description = "Simple i3/sway swallow window script";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };
}
