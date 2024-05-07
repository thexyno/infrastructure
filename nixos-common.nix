{ inputs, config, lib, pkgs, ... }:
{
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  services.openssh.enable = true;

  environment.systemPackages = [
    pkgs.bottom
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJwOH1b6xWmEr1VZh48kBIYhW11vtPFR3my8stAHlSi" # saurier
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuwQJY0H/fdu1UmGXAut7VfcvAk2Dm78tJpkyyv2in2" # daedalus
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZ0hlF6EFQXpw74kkpoA8vxMX6vVDTnpM41rCDXRMuo" # daedalusvm
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6xx1IWlRoSQvCUZ+iyzekjFjoXBKmDT4Kxww4Tl+63" # iPad
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmN2QRbwQyeUChQ0ZxNzjNnUZTOUVbM4kDEGfEtmufc" # iPhone
  ];

  services.journald.extraConfig = ''
    SystemMaxUse=512M
  '';

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_DK.UTF-8";
  };

  system.configurationRevision = with inputs; lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";

  boot = {
    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;
      systemd-boot.configurationLimit = 5;
    };
  };
}
