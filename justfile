default:
    @just --list

# Activate local configuration
[group('main')]
activate:
    nix run

# Deploy host 'immediacy'
[group('main')]
deploy:
    nix run . immediacy

# Format the nix source tree
fmt:
    treefmt
hp8470p:
    nix run .#activate hzgood@ --target-host hzgood@192.168.1.6 --build-host localhost --verbose
win-vm:
    nix run .#activate nixos@