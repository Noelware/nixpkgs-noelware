# Even though Hazel's `rust-version.toml` uses a nightly release, it still
# can be built with the stable version of Rust.
{
  pkg-config,
  openssl,
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}: let
  outputHashes = {
    "azalia-0.1.0" = (import ../../azalia.nix).hazel;
  };
in
  rustPlatform.buildRustPackage rec {
    version = "2.0.0";
    pname = "hazel";

    src = fetchFromGitHub {
      owner = "Noelware";
      repo = "hazel";

      # TODO(@auguwu): use the version instead of a hash
      rev = "49c286061c4a676bbf64e4b0bd10741175db9e9f";
      hash = "sha256-MG4F5NcFppkFpDe/PEiksVirK0V6nuVeVO33Ae+UKEg=";
    };

    nativeBuildInputs = [pkg-config];
    buildInputs =
      [openssl]
      ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        CoreFoundation
        SystemConfiguration
      ]));

    cargoLock = {
      inherit outputHashes;
      lockFile = ./Cargo.lock;
    };

    meta = with lib; {
      description = "Easy to use read-only proxy to map storage objects as URLs";
      homepage = "https://noelware.org/oss/hazel";
      license = with licenses; [asl20];
      maintainers = with maintainers; [auguwu];
      mainProgram = "hazel";
      changelog = "https://github.com/Noelware/hazel/releases/v${version}";
    };
  }
