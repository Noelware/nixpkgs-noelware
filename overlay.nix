self: super: {
  # cattle = super.callPackage ./packages/cattle {};
  charted = super.callPackage ./packages/charted/server {};
  charted-helm-plugin = super.callPackage ./packages/charted/helm-plugin {};
  # foxbuild = super.callPackage ./packages/foxbuild.nix {};
  hazel = super.callPackage ./packages/hazel {};
  # helm-xtest = super.callPackage ./packages/helm-xtest.nix {};
  # hibiki = super.callPackage ./packages/hibiki {};
  # kokori = super.callPackage ./packages/kokori {};
  # noeldoc = super.callPackage ./packages/noeldoc {};
  # noelctl = super.callPackage ./packages/noelctl {};
  # provisionerd = super.callPackage ./packages/provisionerd {};
  # provctl = super.callPackage ./packages/provisionerd/provctl {};
  # ryu = super.callPackage ./packages/ryu {};
}
