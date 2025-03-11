#!/usr/bin/env bash
#!nix-shell -p nix-output-monitor -i bash
#
# ./hack/runNixOSTests.sh :: Runs all NixOS tests under `checks.<system>` in
# the Nix flake.

set -euo pipefail

nix flake check --show-trace --log-format internal-json 2>&1 |& nom --json
