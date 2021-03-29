{ pkgs, stdenv }:

let
  config = pkgs.substituteAll
    {
      name = "sway-config";
      src = ./config;
      background = "/home/tgunnoe/src/nix-machines/pkgs/applications/nixway-app/bg-basic.png";
      script = "/home/tgunnoe/src/nix-machines/pkgs/applications/nixway-app/startup.zsh";
      term = "${pkgs.kitty}/bin/kitty";
      conky-config = let
        conky-config = pkgs.substituteAll
          {
            name = "conky-config.conf";
            src = ./conky.conf;
            color1 = "A9A9A9";
            color3 = "616161";
          };
      in
        conky-config;
      termconfig = pkgs.writeText "kitty" ''
        background_opacity 0
        font_size 8.0
        window_padding_width 20

      '';
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
        services.tor = {
          enable = true;
          client = {
            enable = true;
          };
        };
        networking.firewall.allowedTCPPorts = [ 50 9050 ];
      };
    };
  }
  '';

  custom-python-pkgs = python-packages: with python-packages; [
    i3ipc
  ];
  python-pkgs = pkgs.python38.withPackages custom-python-pkgs;


  #layout = pkgs.writeText "layout" '' ${builtins.readFile ./ws-1.py} '';
  #layout = builtins.readFile ./ws-1.py;
  layout = builtins.path {
    path = ./ws-1.py;
    name = "ws-1.py";
  };
in
pkgs.symlinkJoin {
  name = "nixway-app";
  paths = with pkgs; [ sway waybar hello ranger bpytop conky ];
  buildInputs = with pkgs; [ makeWrapper nixos-container ];
  postBuild = ''
    mv $out/bin/sway $out/bin/nixway-app
    wrapProgram $out/bin/nixway-app \
    --add-flags "--config ${config}" \
    --prefix PATH : "${pkgs.hello}/bin" \
    --prefix PATH : "${extra-container}/bin" \
    --prefix PATH : "${pkgs.ranger}/bin" \
    --prefix PATH : "${pkgs.bpytop}/bin" \
    --prefix PATH : "${pkgs.conky}/bin" \
    --prefix PATH : "${python-pkgs}"/bin \
    --run "${extra-container}/bin/extra-container create --nixpkgs-path /home/tgunnoe/src/nixpkgs --start ${container}" \

  '';
  #     --run "${python-pkgs}/bin/python ${layout}"
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
