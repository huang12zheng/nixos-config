{ pkgs,flake, ... }: 
let
  inherit (flake.config.me) username;
  inherit (flake.config.opt) proxyPort;
in
  {
  services = {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = username;
  };
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    
    desktopManager.gnome.enable = true;
    # desktopManager.gnome.extraGSettingsOverrides = {
    #   "org.gnome.system.proxy" = {
    #     mode = "manual";
    #     http-host = "127.0.0.1";
    #     http-port = proxyPort;
    #     https-host = "127.0.0.1";
    #     https-port = proxyPort;
    #     ignore-hosts = "[localhost]";
    #     # ignore-hosts = "[localhost, 127.0.0.1]";
    #   };
    # };
  };

  environment.variables.GLFW_IM_MODULE = "ibus";
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [
    rime
    # keyboard layout is wrong in anthy, e.g. punctuations
    # anthy
    # hinagara toggle setting is absent in mozc
    # mozc
    # hangul
  ];

  environment.systemPackages = with pkgs; [

    # This is necessary to set CAPS to CTRL
    gnome-tweaks
    # home-manager
    google-chrome

    # gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
  ];
}
