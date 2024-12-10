{
  description = "Nixpkgs overlay for Noelware products and services";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    charted = {
      # TODO(@auguwu): map to `github:charted-dev/charted/0.1.0` once released
      # TODO(@auguwu): remove this and build our own with nixpkgs primitives once all nightly features land in Rust stable
      url = "github:charted-dev/charted";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
  };

  outputs = {
    nixpkgs,
    systems,
    charted,
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
      charted = charted.packages.${system}.charted;
      charted-helm-plugin = charted.packages.${system}.helm-plugin;
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
