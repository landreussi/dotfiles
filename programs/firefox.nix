{
  pkgs,
  lib,
  # Whether to move the toolbox (tab bar + nav bar) to the bottom of the
  # window. Only worth it on the multi-monitor desktop, where the pointer is
  # already travelling to the bottom edge for the i3bar; on a single screen the
  # stock top layout is fine. Firefox has no way to react to the live display
  # count, so this is per-host rather than dynamic.
  bottomToolbox ? false,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
  {
    enable = true;

    # `profiles.<name>.extensions.packages` would need the rycee NUR, so add-ons
    # are force-installed through enterprise policy instead. Firefox fetches and
    # updates them from AMO on its own.
    policies = {
      ExtensionSettings = let
        fromAmo = slug: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
          installation_mode = "force_installed";
        };
      in {
        "*".installation_mode = "allowed";
        "uBlock0@raymondhill.net" = fromAmo "ublock-origin";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = fromAmo "vimium-ff";
        "87677a2c52b84ad3a151a4a72f5bd3c4@jetpack" = fromAmo "grammarly-1";
        "webextension@metamask.io" = fromAmo "ether-metamask";
      };
    };

    # Vimium keeps its options in `storage.sync`, which home-manager cannot seed
    # (`extensions.settings` only writes `storage.local`), and Firefox has no
    # keybinding config of its own. So ./vimium-options.json holds the exported
    # options - the Ctrl+arrow tab mappings and the search engines - and has to be
    # loaded by hand on a fresh profile, through the Vimium options page under
    # "Backup and Restore" -> "Restore from file". Re-export over that file after
    # changing anything in the options page.
    #
    # Vimium stays out of the way inside text fields, so Ctrl+arrow still jumps
    # by word there. Firefox's built-in Ctrl+PageUp/PageDown (plus Shift) do the
    # same four things and keep working on about: pages, where no add-on runs.

    profiles.default =
      {
        id = 0;
        isDefault = true;

        settings =
          {
            # Policy-installed add-ons land in a disabled scope otherwise.
            "extensions.autoDisableScopes" = 0;
          }
          // lib.optionalAttrs bottomToolbox {
            # userChrome.css is ignored unless this is on.
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            # The tab bar drawn at the bottom must not be tucked into the titlebar.
            "browser.tabs.inTitlebar" = 0;
          }
          // lib.optionalAttrs (!isDarwin) {
            # GPU rendering and decoding. The NVIDIA blob is not on Firefox's
            # allowlist for either, so both have to be forced on; VA-API reaches
            # NVDEC through the nvidia-vaapi-driver shim wired up in
            # hosts/stout/configuration.nix. macOS needs none of this.
            "gfx.webrender.all" = true;
            "gfx.webrender.compositor.force-enabled" = true;
            "layers.acceleration.force-enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.rdd-ffmpeg.enabled" = true;
            "media.hardware-video-decoding.force-enabled" = true;
          };

        # Flip the toolbox (tab bar + nav bar) to the bottom of the window by
        # reordering the flex column that holds it and the content area.
        userChrome = lib.optionalString bottomToolbox ''
          #main-window > #titlebar {
            -moz-box-ordinal-group: 10;
          }

          #navigator-toolbox {
            order: 10;
          }

          #browser {
            order: 1;
          }

          /* Toolbar shadows point up now that the bar sits under the page. */
          #navigator-toolbox::after {
            top: 0;
            bottom: auto;
          }

          /* Drop-downs anchored on the bar have to open upwards. */
          #urlbar[breakout][breakout-extend] {
            bottom: 0 !important;
            top: auto !important;
          }
        '';
      }
      // lib.optionalAttrs (!isDarwin) {
        # The directory Firefox has actually been using on stout; `path`
        # defaults to the profile name, which would point home-manager at an
        # empty profile. Darwin has no such legacy profile, so it takes the
        # default.
        path = "ivkumz3s.default";
      };
  }
  // lib.optionalAttrs (!isDarwin) {
    # home-manager 26.05 flipped this default to `$XDG_CONFIG_HOME/mozilla/firefox`
    # for stateVersion >= 26.05. Firefox 155 does read that path, but only when
    # `~/.mozilla/firefox` is absent, and stout's profile has lived there since
    # 2023 - so everything home-manager wrote under .config was silently
    # ignored. Stay on the legacy path instead of moving 200M of profile around.
    # On Darwin the default is `Library/Application Support/Firefox`, which this
    # would break.
    configPath = ".mozilla/firefox";
  }
