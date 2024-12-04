{
  description = "Nixpkgs overlay for Noelware products and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    systems,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
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
      # charted-server = pkgs.callPackage ./packages/charted/server {};
      # charted-helm-plugin = pkgs.callPackage ./packages/charted/helm-plugin {};
      # foxbuild = pkgs.callPackage ./packages/foxbuild {};
      hazel = pkgs.callPackage ./packages/hazel {};
      # helm-xtest = pkgs.callPackage ./packages/helm-xtest.nix {};
      # hibiki = pkgs.callPackage ./packages/hibiki {};
      # noeldoc = pkgs.callPackage ./packages/noeldoc {};
      # provisionerd = pkgs.callPackage ./packages/provisionerd {};
      # ryu = pkgs.callPackage ./packages/ryu {};
    });

    formatter = eachSystem (system: (nixpkgsFor system).alejandra);
  };
}
