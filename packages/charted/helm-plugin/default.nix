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
  pname = "charted-helm-plugin";
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

  # For this derivation, only build the `charted-helm-plugin` binary.
  cargoBuildFlags = ["--bin" "charted-helm-plugin"];

  env.CHARTED_DISTRIBUTION_KIND = "nix";
  postInstall = ''
    installShellCompletion --cmd "helm charted"               \
      --bash <($out/bin/charted-helm-plugin completions bash) \
      --fish <($out/bin/charted-helm-plugin completions fish) \
      --zsh  <($out/bin/charted-helm-plugin completions zsh)

    install -Dm644 plugin.yaml $out/charted-helm-plugin/plugin.yaml
    mv $out/bin $out/charted-helm-plugin
  '';

  postPatch = ''
    sed -i '/^platformHooks:/,+2 d' plugin.yaml
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
