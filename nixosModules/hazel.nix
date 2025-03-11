# `nixosModules.hazel` :: Provision a [Hazel](https://noelware.org/oss/hazel) instance on
#                         any NixOS server that can proxy through filesystem, S3, or Azure
#                         artifacts.
#
#                                 View the documentation here:
#                         >> https://docs.noelware.org/nixpkgs/hazel <<
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types mkIf;

  toml = pkgs.formats.toml {};
  cfg = config.services.hazel;
in {
  options.services.hazel = with types; {
    enable = mkEnableOption "hazel";
    package = mkPackageOption pkgs "hazel" {};

    user = mkOption {
      description = "`hazel` user account";
      type = str;
      default = "hazel";
    };

    group = mkOption {
      description = "`hazel` group";
      type = str;
      default = "hazel";
    };

    stateDir = mkOption {
      description = "if using the filesystem driver, this is the directory where hazel will load content from. use `null` if you're not using the filesystem driver";
      type = nullOr str;
      default = "/var/lib/noelware/hazel";
    };

    settings = mkOption {
      inherit (toml) type;

      example = {
        server_name = "my hazel instance";
        server.host = "0.0.0.0";
        server.port = 7931;
      };

      default = {};
    };

    environment = mkOption {
      type = attrsOr str;
      description = "attrset of environment variables to set";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "`hazel` system account";
      isSystemUser = true;
      group = cfg.group;
    };
  };
}
# # This NixOS module will provision a Hazel instance that can be reached at `http://localhost:8989`.
# {
#   config,
#   lib,
#   pkgs,
#   ...
# }: let
#   cfg = config.services.hazel;
#   format = pkgs.formats.toml {};
# in
#   with lib; {
#     options = {
#       services.hazel = {
#         enable = mkEnableOption "hazel";
#         package = mkPackageOption pkgs "hazel" {};
#         settings = mkOption {
#           inherit (format) type;
#           example = {
#             server_name = "my hazel instance";
#             server = {
#               host = "127.0.0.1";
#               port = 7931;
#             };
#           };
#           description = ''
#             Settings to configure this Hazel instance.
#             See the [documentation](https://docs.noelware.org/hazel/current/configuration) for more details.
#           '';
#         };
#       };
#     };
#     config = mkIf cfg.enable {
#       # users.groups.hazel.gid = config.ids.gids.hazel;
#       # users.users.hazel = {
#       #   description = "Hazel daemon user";
#       #   uid = config.ids.uids.hazel;
#       #   group = "hazel";
#       # };
#       environment.etc."noelware/hazel/config.toml".source = toml.generate "config.toml" config.settings;
#     };
#   }

