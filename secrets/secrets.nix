let
  keys = [
    (import ../users.nix).srid.sshKeyPub
    (import ../systems/hetzner/ax41.info.nix).hostKeyPub
  ];
in
{
  "cache-priv-key.age".publicKeys = keys;
}
