{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rust
    cargo
  ];
  # environment.sessionVariables = {

  # };
}
