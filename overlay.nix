final: prev: {
  # cattle = prev.callPackage ./packages/cattle {};
  charted = prev.callPackage ./packages/charted/server {};
  charted-helm-plugin = prev.callPackage ./packages/charted/helm-plugin {};
  # hoshi = prev.callPackage ./packages/charted/hoshi {};
  hazel = prev.callPackage ./packages/hazel {};
  # helm-xtest = prev.callPackage ./packages/helm-xtest.nix {};
  # noeldoc = prev.callPackage ./packages/noeldoc {};
  # noelctl = prev.callPackage ./packages/noelctl {};

  ### MISC PACKAGES THAT ARENT TIED TO NOELWARE
  cargo-upgrades = prev.callPackage ./packages/misc/cargo-upgrades.nix {};
}
