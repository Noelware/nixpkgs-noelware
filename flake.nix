{
  description = "Nixpkgs overlay for Noelware products and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    # x86_64-linux and {aarch64,x86_64}-darwin is based off our CI when we push
    # the packages to our Nix binary cache. In the future, we do aim to support
    # aarch64-linux soon!
    eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
    nixpkgsFor = system:
      import nixpkgs {
        inherit system;

        # We redistribute "unfree" software (JetBrains TeamCity); "unfree" is used
        # loosely as we can download them and use them for free but with limited
        # features.
        config.allowUnfree = true;
      };
  in {
    overlays.default = import ./overlay.nix;
    packages = eachSystem (system: (import ./overlay.nix {} (nixpkgsFor system)));
    nixosModules = {
      hazel = import ./nixosModules/hazel.nix;
      teamcity-agent = import ./nixosModules/teamcity/agent.nix;
    };

    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
