{ lib, nyxOverlay }:
rec {
  # For viewing in our documentation page.
  _description = "Pack of functions that are useful for Chaotic-Nyx and might become useful for you too";

  # All the ways I found to overlay in nixpkgs
  applyOverlay = { replace ? false, merge ? false, overlay ? nyxOverlay, nyxPkgs ? null, pkgs }:
    let
      fullPackages = if replace then pkgs // ourPackages else ourPackages // pkgs;
      overlayFinal = fullPackages // { callPackage = pkgs.newScope overlayFinal; };
      ourPackages = if nyxPkgs != null then nyxPkgs else overlay overlayFinal pkgs;
    in
    if merge then overlayFinal else ourPackages;

  # When `removeByBaseName` and `removeByURL` can't help, use this to drop patches.
  dropN = qty: list: lib.lists.take (builtins.length list - qty) list;

  # Helps when batch-overriding.
  dropAttrsUpdateScript = builtins.mapAttrs (_k: v:
    if (v.passthru.updateScript or null) != null then
      v.overrideAttrs dropUpdateScript
    else v
  );

  # Helps when overriding.
  dropUpdateScript = prevAttrs:
    { passthru = removeAttrs prevAttrs.passthru [ "updateScript" ]; };

  # NOTE: Don't use in your system's configuration, this helps in the repo's infra.
  # Checks if a derivation is in a list.
  drvElem = x: xs:
    builtins.elem x.drvPath (builtins.map (xsx: xsx.drvPath) xs);

  # NOTE: Don't use in your system's configuration, this helps in the repo's infra
  # Get's the hash of a derivation.
  drvHash = drv:
    builtins.substring 0 32 (builtins.baseNameOf (builtins.unsafeDiscardStringContext drv.drvPath));

  # NOTE: Don't use in your system's configuration, this helps in the repo's infra.
  # Finds dependencies in a derivation that are also present in a attrset filled with derivations.
  internalDeps = packages: drv:
    let
      allDeps = lib.strings.concatStringsSep " "
        (builtins.attrNames (builtins.getContext (builtins.toJSON drv.drvAttrs)));
    in
    builtins.filter (x: lib.strings.hasInfix (builtins.unsafeDiscardStringContext x.drvPath) allDeps) packages;

  # NOTE: Don't use in your system's configuration, this helps in the repo's infra.
  # Creates a super-context with all the derivations involved in building a list of packages
  getStore = packages:
    let
      allDeps = drv:
        let
            thisDeps = builtins.getContext (builtins.toJSON drv.drvAttrs);

            inDeps = builtins.mapAttrs (_key: out: getStore [out]) thisDeps;
        in
        #(builtins.attrNames thisDeps) ++ (builtins.attrValues inDeps);
        (builtins.attrValues inDeps);
    in
    builtins.concatLists (builtins.map allDeps packages);

  # Helps when converting flakes to src.
  gitToVersion = src: "unstable-${src.lastModifiedDate}-${src.shortRev}";

  # Helps when converting flakes to src.
  gitOverride = src: drv:
    drv.overrideAttrs (_prevAttrs: {
      version = gitToVersion src;
      inherit src;
    });

  # Helps when overriding both inputs and outputs attrs.
  multiOverride = prev: newInputs: (prev.override newInputs).overrideAttrs;

  # Helps when overriding both inputs and outputs attrs, multiple times.
  multiOverrides = prev: newInputs: lib.lists.foldl
    (accu: accu.overrideAttrs)
    (prev.override newInputs);

  # Single-value optional attr
  optionalAttr = key: pred: value:
    if pred then { "${key}" = value; } else { };

  # Helps when overriding.
  overrideDescription = descriptionMap: prevAttrs: {
    meta = (rejectAttr "longDescription" prevAttrs.meta) // {
      description = descriptionMap prevAttrs.meta.description;
    };
  };

  # Helps removing attrs.
  rejectAttr = x: lib.attrsets.filterAttrs (k: _v: k != x);

  # Helps when dropping patches.
  removeByBaseName = baseName:
    builtins.filter (x: builtins.baseNameOf x != baseName);

  # Helps when dropping patches.
  removeByName = baseName:
    builtins.filter (x: (x.name or null) != baseName);

  # Helps when dropping multiple patches at once, same as the one before but taking a lit of names.
  removeByNames = baseNames:
    builtins.filter (x: ! builtins.elem (x.name or null) baseNames);

  # Helps when dropping patches.
  removeByBaseNames = baseNames:
    builtins.filter (x: ! builtins.elem (builtins.baseNameOf x) baseNames);

  # Helps when dropping patches.
  removeByURL = url: builtins.filter (x:
    !(lib.attrsets.isDerivation x) || (x.url or null) != url
  );

  # Helps updating flags
  replaceStartingWith = prefix: newSuffix: builtins.map (x:
    if lib.strings.hasPrefix prefix x then
      prefix + newSuffix
    else
      x
  );

  # Helps when batch-overriding.
  setAttrsPlatforms = platforms: builtins.mapAttrs (_k: v:
    if (v ? "overrideAttrs") then
      v.overrideAttrs
        (prevAttrs: {
          meta = (prevAttrs.meta or { }) // {
            platforms = lib.lists.intersectLists (prevAttrs.meta.platforms or [ ]) platforms;
            platformsOrig = prevAttrs.meta.platforms or [ ];
            badPlatforms = [ ];
          };
        })
    else v
  );

  # For revs
  shorter = builtins.substring 0 7;

  # Like `lib.fakeHash`, but beautier.
  unreachableHash = "sha256-2342234223422342234223422342234223422342069=";

  # We don't want builders playing around here.
  recurseForDerivations = false;
}
