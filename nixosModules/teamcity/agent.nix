{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.teamcity.agent;
  format = pkgs.formats.javaProperties {};
in {
  options.services.teamcity.agent = with lib.types; {
    enable = lib.mkEnableOption "teamcity-agent";
    package = lib.mkPackageOption pkgs "teamcity-agent" {};

    user = lib.mkOption {
      type = str;
      default = "teamcity-agent";
      description = "Build Agent user account";
    };

    group = lib.mkOption {
      type = str;
      default = "teamcity-agent";
      description = "Build Agent group account";
    };

    stateDir = lib.mkOption {
      type = str;
      default = "/var/lib/teamcity/agent";
      description = "Directory to hold state data";
    };

    cleanUp = lib.mkOption {
      type = either bool (listOf str);
      default = false;
      example = ["work" "logs"];
      description = "Perform cleanup in the state data directory (${cfg.stateDir})";
    };

    properties = lib.mkOption {
      inherit (format) type;

      description = "Attribute set of the `buildAgent.properties` file";
      default = {};
      example = {
        ## The address of the TeamCity server. The same as is used to open TeamCity web interface in the browser.
        serverUrl = "http://localhost:8111/";

        ## The unique name of the agent used to identify this agent on the TeamCity server
        ## Use blank name to let server generate it.
        ## By default, this name would be created from the build agent's host name
        name = "Default Agent";

        ## Container directory to create default checkout directories for the build configurations.
        ## TeamCity agent assumes ownership of the directory and will delete unknown directories inside.
        workDir = "${cfg.stateDir}/work";

        ## Container directory for the temporary directories.
        ## TeamCity agent assumes ownership of the directory. The directory may be cleaned between the builds.
        tempDir = "${cfg.stateDir}/temp";

        ## Container directory for agent state files and caches.
        ## TeamCity agent assumes ownership of the directory and can delete content inside.
        systemDir = "${cfg.stateDir}/system";
      };
    };

    environment = lib.mkOption {
      type = attrsOf str;
      description = "A list of environment variables to set";
      default = {};
    };

    jdk = lib.mkPackageOption pkgs "jdk17_headless" {};
    plugins = lib.mkOption {
      type = listOf (either path package);
      default = [];
      description = "List of plugins the build agent will use.";
    };
  };

  config = lib.mkIf cfg.enable (let
    # Since we generate our own `buildAgent.properties` to configure it how you want it,
    # we need to ensure that the required properties are here as well.
    buildAgentProperties =
      {
        serverUrl = "http://localhost:8111/";
        name = "Default Agent";
        workDir = "${cfg.stateDir}/work";
        tempDir = "${cfg.stateDir}/temp";
        systemDir = "${cfg.stateDir}/system";
      }
      // cfg.properties;
  in {
    users.users.${cfg.user} = {
      description = "TeamCity Build Agent user";
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = {};
    systemd.services."teamcity-agent" = {
      description = "TeamCity :: Build Agent";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      preStart = with lib; ''
        shopt -s extglob

        ${
          optionalString
          (cfg.cleanUp != false)
          (
            if (cfg.cleanUp == true)
            then "rm -rf ${cfg.stateDir}/*"
            else "rm -rf ${cfg.stateDir}/!(${builtins.concatStringsSep "|" cfg.cleanUp})"
          )
        }

        ## Generate the `work`, `logs`, `conf`, `temp`, and `plugins` folders
        ## and allow the TeamCity user to tamper with it.
        for dir in work logs conf temp plugins; do
          # If it doesn't already exist, create it.
          if ! [ -d "${cfg.stateDir}/$dir" ]; then
            mkdir -p "${cfg.stateDir}/$dir"
            chown -R ${cfg.user}:${cfg.group} "${cfg.stateDir}/$dir"
          fi
        done

        ## Generate the `buildAgent.properties` file.
        echo -e "\n${format.generate "buildAgent.properties" buildAgentProperties}"
          >> "${cfg.stateDir}/conf/buildAgent.properties"

        ## Now we need to pull in all plugins and put them in our state directory.
        ${
          optionalString
          (cfg.plugins != [])
          ''
            plugins=$(${builtins.concatStringsSep " " (map (p: "${p.pname}=${toString p}") cfg.plugins)})
            for i in ''${plugins[@]}; do
              src=''${i#*=}
              dest=''${i%=*}

              mkdir -p "${cfg.stateDir}/plugins/$dest"
              cp -rsf --no-preserve=mode $src/* "${cfg.stateDir}/plugins/$dest"
            done
          ''
        }

        ## A sanity check to determine we did everything correctly
        ${cfg.package}/bin/agent.sh configure || {
          echo "==> failed to configure the agent with given properties"
          echo "==> if this a common occurrence, report this to Noelware:"
          echo "==> https://github.com/Noelware/nixpkgs-noelware/issues/new"
          echo ""
          exit 1
        }
      '';

      path = with pkgs; [gawk];
      environment =
        {
          JAVA_HOME = "${cfg.jdk}";
          CONFIG_FILE = "${cfg.stateDir}/buildAgent.properties";
          LOG_DIR = "${cfg.stateDir}/logs";
        }
        // cfg.environment;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";

        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";

        ExecStart = "${cfg.package}/bin/agent.sh start";
        ExecStop = "${cfg.package}/bin/agent.sh stop";

        RemainAfterExit = true;
        SuccessExitStatus = "0 143";
      };
    };
  });
}
