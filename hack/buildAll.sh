#!/usr/bin/env nix-shell
#!nix-shell -p nix-output-monitor -i bash

set -euo pipefail

# TODO(@auguwu): there is probably a better way of evaluating the
# current system, but this is the only way I can do so.
system=$(nix eval --expr '(import <nixpkgs> {}).system' --impure)
packages=$(nix flake show --json --all-systems 2>/dev/null | jq ".packages.$system | keys[]" | tr -d '"' | tr '\n' ' ')

for pkg in $packages; do
    echo "===> \`nom build $pkg\`"
    nom build ".#$pkg"
done
