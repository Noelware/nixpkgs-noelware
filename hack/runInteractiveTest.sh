#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-output-monitor
#
# ./hack/runInteractiveTest.sh :: Builds a NixOS test via `pkgs.testers.nixosTest`, runs
# the test in an interactive environment.

if [ $# -eq 0 ]; then
    echo "==> Missing a test to pass in."
    exit 1
fi

if [ -d "result" ]; then
    rm "result"
fi

# TODO(@auguwu): there is probably a better way of evaluating the
# current system, but this is the only way I can do so.
system=$(nix eval --expr '(import <nixpkgs> {}).system' --impure)

echo "$ nom build .#checks.$system.$1.driver"
nom build ".#checks.$system.$1.driver"

exec ./result/bin/nixos-test-driver --interactive
