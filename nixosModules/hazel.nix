# This NixOS module will provision a Hazel instance that can be reached at `http://localhost:8989`.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hazel;
  format = pkgs.formats.toml {};
in
  with lib; {
    options = {
      services.hazel = {
        enable = mkEnableOption "hazel";
        package = mkPackageOption pkgs "hazel" {};
        settings = mkOption {
          inherit (format) type;

          example = {
            server_name = "my hazel instance";
            server = {
              host = "127.0.0.1";
              port = 7931;
            };
          };

          description = ''
            Settings to configure this Hazel instance.
            See the [documentation](https://docs.noelware.org/hazel/current/configuration) for more details.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      # users.groups.hazel.gid = config.ids.gids.hazel;
      # users.users.hazel = {
      #   description = "Hazel daemon user";
      #   uid = config.ids.uids.hazel;
      #   group = "hazel";
      # };

      environment.etc."noelware/hazel/config.toml".source = toml.generate "config.toml" config.settings;
    };
  }
