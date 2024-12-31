# Since `charted-helm-plugin` is in the same repository as charted, we still
# need access to unstable features due to the following unstable language or
# library features:
#
# - `once_cell_try` (https://doc.rust-lang.org/unstable-book/library-features/once-cell-try.html, rust-lang/rust#109737)
# - `ptr_as_ref_unchecked` (https://doc.rust-lang.org/unstable-book/library-features/ptr-as-ref-unchecked.html, rust-lang/rust#122034)
# - `decl_macro` (https://doc.rust-lang.org/unstable-book/language-features/decl-macro.html, rust-lang/rust#39412)
# - `never_type` (https://doc.rust-lang.org/unstable-book/language-features/never-type.html, rust-lang/rust#35121)
#
# As a hack, `RUSTC_BOOTSTRAP = 1` is set. This is so we don't pull `oxalica/rust-overlay`.
{
  lib,
  darwin,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
  sqlite,
  postgresql,
}: let
  outputHashes = {
    "azalia-0.1.0" = (import ../../../azalia.nix).charted;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "charted";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "charted-dev";
      repo = "charted";

      # TODO(@auguwu): use `version` instead of a commit
      rev = "07a107e823a728ecc68f0ad5051a8ecf6ed5a476";
      hash = "sha256-KwItR18bbq8omkth42kUo10LYFKR6AbzKeVd8CVKQSo=";
    };

    nativeBuildInputs = [pkg-config installShellFiles];
    buildInputs =
      [openssl sqlite postgresql]
      ++ (lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        SystemConfiguration
        CoreFoundation
        Security
      ]));

    # allows to use Nightly features on a stable compiler
    #
    # !!! THIS IS A HACK, READ ABOVE ON WHY WE ARE USING THIS !!!
    RUSTC_BOOTSTRAP = 1;

    checkFlags = [
      # We're still unsure why when building with `nixpkgs`, this will
      # fail but on other machines (Noel: NixOS, macOS (nix-darwin); Spotlight: macOS (nix-darwin))
      # and in GitHub actions, it succeeds.
      #
      # TODO(@auguwu/@spotlightishere): should we add a `--cfg nixpkgs` rustflag
      # and do other checks or what?
      "--skip ulid::tests::test_monotonicity"
    ];

    cargoLock = {
      inherit outputHashes;
      lockFile = ../Cargo.lock;
    };

    # For this derivation, only build the `charted-helm-plugin` binary.
    cargoBuildFlags = ["--bin" "charted-helm-plugin"];

    env.CHARTED_DISTRIBUTION_KIND = "nix";
    postInstall = ''
      installShellCompletion --cmd "helm charted"               \
        --bash <($out/bin/charted-helm-plugin completions bash) \
        --fish <($out/bin/charted-helm-plugin completions fish) \
        --zsh  <($out/bin/charted-helm-plugin completions zsh)
    '';

    meta = with lib; {
      description = "Faciliate operations on charted-server with Helm directly";
      maintainers = with maintainers; [auguwu spotlightishere];
      mainProgram = "helm charted";
      changelog = "https://charts.noelware.org/changelogs/helm-plugin#v${version}";
      homepage = "https://charts.noelware.org";
      license = with licenses; [asl20];
    };
  }
