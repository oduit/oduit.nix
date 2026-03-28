{
  pkgs,
  flake,
  ...
}:
pkgs.callPackage ./package.nix {
  inherit flake;
  manifestoo = pkgs.python3Packages.manifestoo;
}
