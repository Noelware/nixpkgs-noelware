final: prev: {
  # cattle = prev.callPackage ./packages/cattle {};
  charted = prev.callPackage ./packages/charted/server {};
  charted-helm-plugin = prev.callPackage ./packages/charted/helm-plugin {};
  # hoshi = prev.callPackage ./packages/charted/hoshi {};
  hazel = prev.callPackage ./packages/hazel {};
  # helm-xtest = prev.callPackage ./packages/helm-xtest.nix {};
  # noeldoc = prev.callPackage ./packages/noeldoc {};
  # noelctl = prev.callPackage ./packages/noelctl {};
  teamcity-agent = prev.callPackage ./packages/jetbrains/teamcity/agent {};
  teamcity-server = prev.callPackage ./packages/jetbrains/teamcity/server {};

  ### MISC PACKAGES THAT ARENT TIED TO NOELWARE
  cargo-updates = prev.callPackage ./packages/misc/cargo-upgrades.nix {};
}
