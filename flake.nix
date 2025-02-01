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
    packages = eachSystem (system: let
      pkgs = nixpkgsFor system;
    in {
      # cattle = pkgs.callPackage ./packages/cattle {};
      charted = pkgs.callPackage ./packages/charted/server {};
      charted-helm-plugin = pkgs.callPackage ./packages/charted/helm-plugin {};
      # hoshi = pkgs.callPackage ./packages/charted/hoshi {};
      hazel = pkgs.callPackage ./packages/hazel {};
      # helm-xtest = pkgs.callPackage ./packages/helm-xtest.nix {};
      # noeldoc = pkgs.callPackage ./packages/noeldoc {};
      # noelctl = pkgs.callPackage ./packages/noelctl {};
      # provisionerd = pkgs.callPackage ./packages/provisionerd {};
      # provctl = pkgs.callPackage ./packages/provisionerd/provctl {};
      # sayu = pkgs.callPackage ./packages/sayu {};
      teamcity-agent = pkgs.callPackage ./packages/jetbrains/teamcity/agent {};
      teamcity-server = pkgs.callPackage ./packages/jetbrains/teamcity/server {};
    });

    nixosModules = {
      hazel = import ./nixosModules/hazel.nix;
      teamcity-agent = import ./nixosModules/teamcity/agent.nix;
    };

    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
