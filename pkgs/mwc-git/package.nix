{ wayland-protocols
, wayland-scanner
, libxkbcommon
, makeWrapper
, pkg-config
, libinput
, wlroots_0_18
, wayland
, pixman
, ninja
, meson
, libxcb
, libdrm
, scenefx
, cmake
, fetchFromGitHub
, stdenv
, lib
,
}:

stdenv.mkDerivation {
  pname = "mwc";
  version = "unstable-20250228-9b9d425";

  src = fetchFromGitHub {
    owner = "dqrk0jeste";
    repo = "mwc";
    rev = "9b9d4256be440b511e6c37165e01a6c2686e606f";
    hash = "sha256-rTI28cEQPulpku/F9NeuY9KZza89G+S1r/W3hQr3I14";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wayland-scanner
    makeWrapper
    pkg-config
    meson
    cmake
    ninja
  ];

  outputs = [
    "out"
  ];

  buildInputs = [
    wayland-protocols
    libxkbcommon
    wlroots_0_18
    libinput
    wayland
    libxcb
    libdrm
    pixman
    scenefx
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=wayland-scanner"
    "MANDIR=$out/share/man"
    "PREFIX=$out"
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  postInstall = ''
    wrapProgram $out/bin/mwc --set MWC_DEFAULT_CONFIG_PATH "$out/share/default.conf"
  '';

  buildPhase = ''
    meson setup build
    ninja -C build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp -r build/mwc $out/bin/
    cp -r build/mwc-ipc $out/bin/
    cp -r default.conf $out/share/
  '';
  # HUUUUUUUUUGE thanks to https://github.com/dqrk0jeste ^^^

  __structuredAttrs = true;

  meta = {
    description = "tiling wayland compositor based on wlroots and scenefx.";
    homepage = "https://github.com/dqrk0jeste/mwc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
    platforms = with lib; [ "x86_64-linux" ];
  };
}
