{ pkgs, config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  services.k3s = {
    enable = true;
  };
}