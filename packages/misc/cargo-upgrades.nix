{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-upgrades";
  version = "2.2.0";

  src = fetchFromGitLab {
    owner = "kornelski";
    repo = "cargo-upgrades";
    rev = "v${version}";
    hash = "sha256-b86ghds8hWllMmPa7cqfiW6sq9Pv9bKL2DLaJVz1Sww=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yEUfWe4/kSvBPx3xneff45+K3Gix2QXDjUesm+psUxI=";

  meta = with lib; {
    description = "Checks if dependencies in Cargo.toml are up to date. Compatible with workspaces and path dependencies.";
    mainProgram = "cargo-upgrades";
    homepage = "https://github.com/kornelski/cargo-upgrades";
    licenses = with licenses; [gpl3Plus];
    maintainers = with maintainers; [auguwu];
  };
}
