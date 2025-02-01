self: super: {
  # cattle = super.callPackage ./packages/cattle {};
  charted = super.callPackage ./packages/charted/server {};
  charted-helm-plugin = super.callPackage ./packages/charted/helm-plugin {};
  # hoshi = super.callPackage ./packages/charted/hoshi {};
  hazel = super.callPackage ./packages/hazel {};
  # helm-xtest = super.callPackage ./packages/helm-xtest.nix {};
  # noeldoc = super.callPackage ./packages/noeldoc {};
  # noelctl = super.callPackage ./packages/noelctl {};
  # provisionerd = super.callPackage ./packages/provisionerd {};
  # provctl = super.callPackage ./packages/provisionerd/provctl {};
  # sayu = super.callPackage ./packages/sayu {};
  teamcity-agent = super.callPackage ./packages/jetbrains/teamcity/agent {};
  teamcity-server = super.callPackage ./packages/jetbrains/teamcity/server {};
}
