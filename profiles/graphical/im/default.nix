{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    element-desktop
    signal-desktop
    utox
    tdesktop
  ];
}
