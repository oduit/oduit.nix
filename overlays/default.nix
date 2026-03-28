{
  packages,
}:
final: _prev: {
  oduit = packages.${final.stdenv.hostPlatform.system} or { };
}
