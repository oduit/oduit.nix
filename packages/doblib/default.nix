{
  pkgs,
  flake,
  ...
}:
pkgs.callPackage ./package.nix {
  inherit flake;
  gitAggregator = pkgs.git-aggregator;
}
