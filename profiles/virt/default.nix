{ pkgs, ... }: {
  virtualisation = {
    anbox = {
      enable = false;
    };
    libvirtd = {
      enable = true;
    };

    containers.enable = true;

  };
  programs.dconf.enable = true;
  environment.systemPackages = [
    pkgs.virt-manager
  ];
}
