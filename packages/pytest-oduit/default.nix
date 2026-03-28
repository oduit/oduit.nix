{
  pkgs,
  flake,
  ...
}:
pkgs.callPackage ./package.nix {
  inherit flake;
  oduit = pkgs.callPackage ../oduit/package.nix { inherit flake; };
}
