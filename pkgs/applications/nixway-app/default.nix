{ pkgs, stdenv }:

let
  config = pkgs.substituteAll
    {
      name = "sway-config";
      src = ./config;
      background = "/home/tgunnoe/src/nix-machines/pkgs/applications/nixway-app/212797-abstract-polyscape.jpg";
      term = "${pkgs.termite}/bin/termite";
  };
  extra-container = let
    src = builtins.fetchGit {
      url = "https://github.com/erikarvstedt/extra-container.git";
      # Recommended: Specify a git revision hash
      rev = "66c8c3d4480e9cb076a966cd7b71fc672f0dfbb6";
    };
  in
    pkgs.callPackage src { pkgSrc = src; };

  #container = builtins.path { path = ./container.nix; name = "container"; };
  container = pkgs.writeText "container" ''
  {
    containers.demo = {
      privateNetwork = true;
      hostAddress = "10.250.0.1";
      localAddress = "10.250.0.2";

      config = { pkgs, ... }: {
        systemd.services.hello = {
          wantedBy = [ "multi-user.target" ];
          script = "
            while true; do
              echo hello | ${pkgs.netcat}/bin/nc -lN 50
            done
          ";
        };
        networking.firewall.allowedTCPPorts = [ 50 ];
      };
    };
  }
  '';
  container-import = import container;
  nixway-container = (container-import pkgs);
in
pkgs.symlinkJoin {
  name = "nixway-app";
  paths = with pkgs; [ sway waybar hello cmatrix bpytop ];
  buildInputs = with pkgs; [ makeWrapper nixos-container ];
  postBuild = ''
    mv $out/bin/sway $out/bin/nixway-app
    wrapProgram $out/bin/nixway-app \
    --add-flags "--config ${config}" \
    --prefix PATH : "${pkgs.hello}/bin" \
    --prefix PATH : "${extra-container}/bin" \
    --prefix PATH : "${pkgs.cmatrix}/bin" \
    --prefix PATH : "${pkgs.bpytop}/bin" \
    --run "${extra-container}/bin/extra-container create --nixpkgs-path /home/tgunnoe/src/nixpkgs --start ${container}"
  '';
#    --run "nixos-container create foo --nixos-path /home/tgunnoe/src/nixpkgs/nixos --config 'services.openssh.enable = true;'"
  #    --run "nixos-container start foo" \

  meta = with stdenv.lib; {
    homepage = "https://github.com/tgunnoe/nix-machines/";
    description = "Test nix+sway app";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };

}
