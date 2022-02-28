{ config, lib, pkgs, ... }:

{
  home-manager.users.mainUser = { ... }: {
    programs.firefox = {
      enable = true;

      package = with pkgs; wrapFirefox firefox-esr-unwrapped {
        forceWayland = true;

        nixExtensions = [
          (pkgs.fetchFirefoxAddon {
            name = "cookie-autodelete";
            url = "https://addons.mozilla.org/firefox/downloads/file/3711829/cookie_autodelete-3.6.0-an+fx.xpi";
            sha256 = "sha256-+DZG1C9HbIY4QWT9SGj6nFt0UkkfHzfU4hnD+zxCHe8=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "ublock-origin";
            url = "https://addons.mozilla.org/firefox/downloads/file/3913320/ublock_origin-1.41.8-an+fx.xpi";
            sha256 = "sha256-Unx1JxFqbG/925Y837kBUY1W9iTPySL26rMpFrJOj10=";
          })
          (pkgs.fetchFirefoxAddon {
            name = "bitwarden";
            url = "https://addons.mozilla.org/firefox/downloads/file/3910071/bitwarden_free_password_manager-1.56.6-an+fx.xpi";
            sha256 = "sha256-4oIKi/atb7PA05WFtyH98R9avOXhIPk9DY1O0EwKZH4=";
          })
        ];

        # see https://github.com/mozilla/policy-templates/blob/master/README.md
        extraPolicies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          DontCheckDefaultBrowser = true;
          FirefoxHome = {
            Pocket = false;
            Snippets = false;
          };
          PasswordManagerEnabled = false;
          PromptForDownloadLocation = true;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };

        extraPrefs = ''
          // Show more ssl cert infos
          lockPref("security.identityblock.show_extended_validation", true);
        '';
      };

      profiles.default = { };
    };
  };
}
