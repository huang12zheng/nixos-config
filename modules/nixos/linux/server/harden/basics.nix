{

  # Firewall
  networking.firewall.enable = true;

  # Enable auditd
  security.auditd.enable = true;
  security.audit.enable = true;

  

  # Standard openssh protections
  #
  # See primary-as-admin.nix to setup passwordless setup.
  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      allowSFTP = false;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
  };
  };

  # 🤲
  nix.settings.allowed-users = [ "root" "@users" ];
}
