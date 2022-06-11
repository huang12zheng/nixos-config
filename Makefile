HOSTNAME := $(shell hostname -s)

all:
	if [[ "`uname`" == 'Darwin' ]]; then \
		echo macOS; \
		make macos-system; \
	else \
		echo NixOS; \
		make nixos-system; \
	fi

nixos-system:
	nixos-rebuild --use-remote-sudo switch -j auto

macos-system:
	sudo ls # cache sudo
	$$(nix build --extra-experimental-features "flakes nix-command"  .#darwinConfigurations.$(HOSTNAME).system --no-link --json | nix --extra-experimental-features "flakes nix-command" run ${WITHEXP} nixpkgs#jq -- -r '.[].outputs.out')/sw/bin/darwin-rebuild switch --flake .

freeupboot:
	# Delete all but the last few generations
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
	sudo nixos-rebuild boot
