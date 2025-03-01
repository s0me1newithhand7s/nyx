{ final, prev, gitOverride, ... }:

gitOverride {
  nyxKey = "mwc_git";
  prev = final.callPackage ./package.nix { };

  versionNyxPath = "pkgs/mwc-git/version.json";
  fetcher = "fetchFromGitHub";
  fetcherData = {
    owner = "dqrk0jeste";
    repo = "mwc";
    fetchSubmodules = true;
  };
}
