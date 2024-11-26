# flake.nix continuation
{pkgs,...}:{
  systemd = {
    services.light-max-brightness = {
        description = "Set screen brightness to maximum";
        wantedBy = [ "default.target" ];
        serviceConfig = {
        ExecStart = "${pkgs.light}/bin/light -S 100"; # Set brightness to 100%
        Type = "oneshot";
        RemainAfterExit = true;
        };
    };
  };
}
