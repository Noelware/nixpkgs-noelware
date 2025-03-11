# `charted-server` uses a nightly version of Rust to have the following features
# that haven't landed in stable:
#
# - `let_chains` (https://doc.rust-lang.org/unstable-book/language-features/let-chains.html, rust-lang/rust#53667)
#
# As a hack, we will use `RUSTC_BOOTSTRAP` set to `1`, which is HIGHLY UNRECOMMENDED,
# but it is a hack to work with `nixpkgs` alone as I don't want to pull `oxalica/rust-overlay`.
{
  lib,
  darwin,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "charted";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "charted-dev";
    repo = "charted";

    # TODO(@auguwu): use `version` instead of a commit
    rev = "fa278581b8358078a24eddad09fb41b675220efe";
    hash = "sha256-LbYWV7P9mzpn9H9kzmB7fbb7a3oHHm47Rp5ev7yw6bk=";
  };

  nativeBuildInputs = [pkg-config installShellFiles];
  buildInputs =
    [openssl]
    ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      SystemConfiguration
      CoreFoundation
      Security
    ]));

  # allows to use Nightly features on a stable compiler
  #
  # !!! THIS IS A HACK, READ ABOVE ON WHY WE ARE USING THIS !!!
  RUSTC_BOOTSTRAP = 1;

  # checkFlags = [
  #   # We're still unsure why when building with `nixpkgs`, this will
  #   # fail but on other machines (Noel: NixOS, macOS (nix-darwin); Spotlight: macOS (nix-darwin))
  #   # and in GitHub actions, it succeeds.
  #   #
  #   # TODO(@auguwu/@spotlightishere): should we add a `--cfg nixpkgs` rustflag
  #   # and do other checks or what?
  #   "--skip ulid::tests::test_monotonicity"
  # ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-/n7rV8R51G+vn0ztQKuWDytz9MTMuAy57i5WiwMhmHM=";

  # For this derivation, only build the `charted` binary.
  cargoBuildFlags = ["--bin" "charted"];

  env.CHARTED_DISTRIBUTION_KIND = "nix";

  postInstall = ''
    installShellCompletion --cmd charted          \
      --bash <($out/bin/charted completions bash) \
      --fish <($out/bin/charted completions fish) \
      --zsh  <($out/bin/charted completions zsh)
  '';

  meta = with lib; {
    description = "Free and open source way to distribute Helm charts across the world";
    maintainers = with maintainers; [auguwu spotlightishere];
    mainProgram = "charted";
    changelog = "https://charts.noelware.org/changelogs/charted#v${version}";
    homepage = "https://charts.noelware.org";
    license = with licenses; [asl20];
  };
}
