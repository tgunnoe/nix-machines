# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/91d1dfd6-bf33-46ad-8fc7-3ff39ba826ff";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/2EB0-BB29";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/04983f36-41ad-4dea-9227-6a3f06fbbb11"; }
    ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
