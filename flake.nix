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
      };
  in {
    overlays.default = import ./overlay.nix;
    packages = eachSystem (system: let
      pkgs = nixpkgsFor system;
    in {
      # cattle = pkgs.callPackage ./packages/cattle {};
      charted = pkgs.callPackage ./packages/charted/server {};
      charted-helm-plugin = pkgs.callPackage ./packages/charted/helm-plugin {};
      # foxbuild = pkgs.callPackage ./packages/foxbuild {};
      hazel = pkgs.callPackage ./packages/hazel {};
      # helm-xtest = pkgs.callPackage ./packages/helm-xtest.nix {};
      # hibiki = pkgs.callPackage ./packages/hibiki {};
      # kokori = pkgs.callPackage ./packages/kokori {};
      # noelctl = pkgs.callPackage ./packages/noelctl {};
      # noeldoc = pkgs.callPackage ./packages/noeldoc {};
      # provisionerd = pkgs.callPackage ./packages/provisionerd {};
      # ryu = pkgs.callPackage ./packages/ryu {};
    });

    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
