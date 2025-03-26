{fetchFromGitHub}: let
  createSrc = {
    repo,
    rev,
    hash,
  }:
    fetchFromGitHub {
      inherit repo rev hash;

      owner = "charted-dev";
    };
in {
  version = "0.1.0";
  charted = {
    cargoHash = "sha256-KnftxeJbp4hxhDe+yYZAWJH37l/LkJfZoNxKAYEB7I4=";
    src = createSrc {
      repo = "charted";

      # TODO(@auguwu): use `version` instead of a commit
      rev = "7c6ea57387ba140641e2c271ffb6f8ae13a58064";
      hash = "sha256-mYaPdlDAZx1Mdeb+CXK8bHD3e4/I8piqSt9/x7jsHZk=";
    };
  };

  helm-plugin = {
    cargoHash = "sha256-J+mVoGl8z5I955mry3oYgEyAYy3EWeZHSGrsDf85Ogc=";
    src = createSrc {
      repo = "helm-plugin";

      # TODO(@auguwu): use `version` instead of a commit
      rev = "b4892a2ab21d68d452f814fb80ab7f3f824edd01";
      hash = "sha256-C0SSy0hXZOycv/07uxQAdmdXhkG+4w/38MlG86M7Kms=";
    };
  };

  # hoshi = {
  #     pnpmDepsHash = "";
  #     src = createSrc {
  #         repo = "hoshi";
  #         rev = "";
  #         hash = "";
  #     };
  # };
}
