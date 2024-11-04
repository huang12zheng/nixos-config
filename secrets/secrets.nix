let
  config = import ../config.nix;
  users = [ config.me.sshKey ];
  win-nixos-vm = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODixkP460ow40H3sepPRc+DWCXuCkXr+VBwSEsxardb"]
  win = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5Bo5rlt83hjhPrzDM7++GxX7M8FrWOVWaVHEC1cSMa"]

  # appreciate = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICra+ZidiwrHGjcGnyqPvHcZDvnGivbLMayDyecPYDh0";
  # immediacy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZALEiJIrH1Kj10u+WshkQXr5NHmszza8wNLqW+2fB0";
  # systems = [ appreciate immediacy ];
  systems = [ ];
in
{
  # "hedgedoc.env.age".publicKeys = users ++ systems;
  # "github-nix-ci/srid.token.age".publicKeys = users ++ systems;
}
