{
  stdenv,
  fetchurl,
  lib,
}: let
  version = "2024.12.1";
  url = "https://download.jetbrains.com/teamcity/TeamCity-${version}.tar.gz";
in
  stdenv.mkDerivation {
    inherit version;

    pname = "teamcity-server";
    src = fetchurl {
      inherit url;

      hash = "sha256-pcbrwixIHWMEQ+yz+aIZIQClPgTrOWk1tymuUXQ30Ic=";
    };

    installPhase = "cp -R . $out";
    meta = with lib; {
      description = "Powerful CI/CD solution for modern DevOps teams";
      homepage = "https://jetbrains.com/teamcity";
      sourceProvenance = with sourceTypes; [binaryBytecode];
      maintainers = with maintainers; [auguwu];
      license = with licenses; [unfreeRedistributable];
    };
  }
