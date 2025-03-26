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
    cargoHash = "sha256-HF8QPtaL34XfjWki2aVl2pWZ+8JYDqLucqMqEhQTaA0=";
    src = createSrc {
      repo = "charted";

      # TODO(@auguwu): use `version` instead of a commit
      rev = "7990a60fb298fd9a3510e8bffc19a5132160d3f1";
      hash = "sha256-OeANiw0CqTQGhpM3M3yuGpYLD3Dy5QaapCpobRZjZoc=";
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
