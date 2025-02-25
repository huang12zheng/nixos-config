{ pkgs, config, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "hp8470p"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # environment.systemPackages = pkgs: (pkgs.defaultSystemPackages pkgs).without [
  #   "gnome-calendar"
  #   "gnome-clocks"
  #   "geary"
  #   "cheese"
  # ];
  # https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are/13505/11
  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    evince # document viewer
    geary # email client
    # gnome-backgrounds
    gnome-bluetooth
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-color-manager
    gnome-contacts # contacts
    # gnome-control-center
    gnome-font-viewer
    # gnome-logs
    gnome-maps # maps
    gnome-music # music
    gnome-shell-extensions
    gnome-themes-extra
    gnome-weather
    # nautilus
    adwaita-icon-theme
    gnome-photos
    gnome-tour
    gnome-user-docs
    loupe
    orca
    simple-scan
    totem # video player
    yelp # help viewer
    snapshot # camera
    gnome-connections
    xterm
    file-roller
  ];

  # 仅保留必要工具
  # environment.systemPackages = pkgs: [vim wget curl htop];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    # feishu
    wechat-uos
    wpsoffice
    # brave
    # zed-editor
    geekbench_5
    tree
    nixd
    # home-manager
    android-studio
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
