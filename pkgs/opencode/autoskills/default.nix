{ lib, stdenv, fetchurl }:

# autoskills.sh — one command to install production-ready agent skills
# for your whole tech stack, based on the project's detected stack.
#
# LICENCE (quan trong): CC-BY-NC-4.0 — non-commercial, NOT OSI. Only
# suitable for personal use. This derivation only holds a fetchurl recipe;
# the NC-licensed tarball lands in the Nix store, nothing is committed to
# this repo. Do NOT vendor skills-registry/* contents into the repo.
# Requires Node >=22.6 on PATH at runtime (present on this system: v22.x).

stdenv.mkDerivation {
  pname = "autoskills";
  version = "0.3.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/autoskills/-/autoskills-0.3.6.tgz";
    hash = "sha256-hM/aqBig8vQnjsIDNDiOninDvp4SoMq+wL8+4X7m13Q=";
    name = "autoskills-0.3.6.tgz";
  };

  # Tarball is self-contained (index.mjs + dist/ + skills-registry/index.json,
  # zero runtime deps) → plain copy, no npm needed.
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/node_modules/autoskills" "$out/bin"
    cp -r . "$out/lib/node_modules/autoskills/"
    chmod +x "$out/lib/node_modules/autoskills/index.mjs"
    ln -s "$out/lib/node_modules/autoskills/index.mjs" "$out/bin/autoskills"
    runHook postInstall
  '';

  meta = {
    description = "Install production-ready agent skills for your whole tech stack with one command (CC-BY-NC-4.0, personal use)";
    homepage = "https://www.autoskills.sh/";
    license = lib.licenses.cc-by-nc-40;
    platforms = lib.platforms.linux;
  };
}