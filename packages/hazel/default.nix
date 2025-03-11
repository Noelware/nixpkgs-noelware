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
}:
rustPlatform.buildRustPackage rec {
  version = "2.0.0";
  pname = "hazel";

  src = fetchFromGitHub {
    owner = "Noelware";
    repo = "hazel";

    # TODO(@auguwu): use the version instead of a hash
    rev = "ec028b6878970c612d1a9352f1e3aea3acdceb61";
    hash = "sha256-MIm3gnM9Ku7mSl+QsgVcyfLDE3muLmj+RP+pG+AneFk=";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs =
    [openssl]
    ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation
      SystemConfiguration
    ]));

  useFetchCargoVendor = true;
  cargoHash = "sha256-hC9JFqdoEhgrA7Cq+jyVvEAD3oC1LKB83/DCs4FWLAk=";

  meta = with lib; {
    description = "Easy to use read-only proxy to map storage objects as URLs";
    homepage = "https://noelware.org/oss/hazel";
    license = with licenses; [asl20];
    maintainers = with maintainers; [auguwu];
    mainProgram = "hazel";
    changelog = "https://github.com/Noelware/hazel/releases/v${version}";
  };
}
