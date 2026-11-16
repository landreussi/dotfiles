{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "google-calendar-tui";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "akitaonrails";
    repo = "google-calendar-tui";
    tag = "v${version}";
    hash = "sha256-HoRT6GH6+Ec+RFnWppMbOYFkc3hPCE4U5CyZBQTwhRw=";
  };

  cargoHash = "sha256-+gzJC5IaktZ32bjjxx8Tyh2qAKySRRd20Y5Roz1gH/I=";

  meta = {
    description = "Read-only terminal agenda for Google Calendar";
    homepage = "https://github.com/akitaonrails/google-calendar-tui";
    changelog = "https://github.com/akitaonrails/google-calendar-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    # GNOME Online Accounts over D-Bus is the default source.
    platforms = lib.platforms.linux;
    mainProgram = "google-calendar-tui";
  };
}
