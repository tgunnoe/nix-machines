{
  description = "A highly structured configuration database.";


  inputs =
    {
      # Once desired, bump master's locked revision:
      # nix flake update --update-input master
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
      flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
      devshell.url = "github:numtide/devshell";
      emacs.url = "github:nix-community/emacs-overlay";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      ci-agent.url = "github:hercules-ci/hercules-ci-agent";
      # nixus = { url = "github:infinisil/nixus"; flake = false; };
    };

  outputs =
    inputs@{ self
    , ci-agent
    , home
    , nixos
    , master
    , flake-utils
    , nur
    , devshell
    , emacs
    , nixos-hardware
    }:
    let
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos.lib) recursiveUpdate;
      inherit (self.lib) overlays nixosModules genPackages pkgImport
        genHomeActivationPackages;

      externOverlays = [ nur.overlay devshell.overlay emacs.overlay ];
      externModules = [
        home.nixosModules.home-manager
        ci-agent.nixosModules.agent-profile
      ];

      outputs =
        let
          system = "x86_64-linux";
          pkgs = self.legacyPackages.${system};
        in
        {
          inherit nixosModules overlays;

          nixosConfigurations =
            import ./hosts
              (recursiveUpdate inputs {
                inherit pkgs externModules system;
                inherit (pkgs) lib;
              });

          homeConfigurations =
            builtins.mapAttrs
              (_: config: config.config.home-manager.users)
              self.nixosConfigurations;

          overlay = import ./pkgs;

          lib = import ./lib {
            inherit (nixos) lib;
          };

          templates.flk.path = ./.;

          templates.flk.description = "flk template";

          defaultTemplate = self.templates.flk;
        };
    in
    recursiveUpdate
      (eachDefaultSystem
        (system:
        let
          unstable = pkgImport master [ ] system;

          pkgs =
            let
              override = import ./pkgs/override.nix;
              overlays = [
                (override unstable)
                self.overlay
                (final: prev: {
                  lib = (prev.lib or { }) // {
                    inherit (nixos.lib) nixosSystem;
                    flk = self.lib;
                    utils = flake-utils.lib;
                  };
                })
              ]
              ++ (attrValues self.overlays)
              ++ externOverlays;
            in
            pkgImport nixos overlays system;

          packages =
            let
              packages' = flattenTreeSystem system
                (genPackages {
                  inherit self pkgs;
                });

              homeActivationPackages = genHomeActivationPackages
                self.homeConfigurations;
            in
            recursiveUpdate packages' homeActivationPackages;
        in
        {
          inherit packages;

          devShell = import ./shell {
            inherit pkgs nixos;
          };

          legacyPackages = pkgs;
        })
      )
      outputs;
}
