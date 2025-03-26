{
  lib,
  darwin,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}: let
  sources = import ../sources.nix {inherit fetchFromGitHub;};

  inherit (sources) helm-plugin;
in
  rustPlatform.buildRustPackage rec {
    inherit (helm-plugin) src cargoHash;
    inherit (sources) version;

    pname = "charted-helm-plugin";

    nativeBuildInputs = [installShellFiles];
    buildInputs = lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      SystemConfiguration
      CoreFoundation
      Security
    ]);

    useFetchCargoVendor = true;
    cargoBuildFlags = ["--bin" "charted-helm-plugin"];

    env.CHARTED_DISTRIBUTION_KIND = "nix";
    postInstall = ''
      # installShellCompletion --cmd "helm charted"               \
      #  --bash <($out/bin/charted-helm-plugin completions bash) \
      #  --fish <($out/bin/charted-helm-plugin completions fish) \
      #  --zsh  <($out/bin/charted-helm-plugin completions zsh)

      install -Dm644 ${./plugin.yaml} $out/charted-helm-plugin/plugin.yaml
      mv $out/bin $out/charted-helm-plugin
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
