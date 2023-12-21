{ final, prev, gitOverride, ... }:

gitOverride {
  nyxKey = "cosmic-applets_git";
  prev = prev.cosmic-applets;

  versionNyxPath = "pkgs/cosmic-applets-git/version.json";
  fetcher = "fetchFromGitHub";
  fetcherData = {
    owner = "pop-os";
    repo = "cosmic-applets";
  };
  ref = "master_jammy";

  withCargoDeps = lockFile: final.rustPlatform.importCargoLock {
    inherit lockFile;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "cosmic-config-0.1.0" = "sha256-DKjNoB+Y2rG5B6anIzVp8rNTkTp0JRXoHSoWtq7B1MQ=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-eSUyDME39UhoimO/gd2mJDaunCrLNXesO9C69IwtjgM=";
      "cosmic-notifications-config-0.1.0" = "sha256-9ZZdPBDgqH79O81DlTswSOkqC+oHeXcS8oRsV6lWrmE=";
      "cosmic-panel-config-0.1.0" = "sha256-SDqNLuj219FMqlO2devw/DD04RJfSBJLDLH/4ObRCl8=";
      "cosmic-time-0.4.0" = "sha256-kPahIznCtjIa38ty8IzGTbZ25tEZ26hLOL1ybPaTeAk=";
      "glyphon-0.3.0" = "sha256-Uw1zbHVAjB3pUfUd8GnFUnske3Gxs+RktrbaFJfK430=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-3Dc2fU8xBVUmAs0Q1zEdcdG7vlxpBO+UIlyM/kzGcC4=";
    };
  };
}
