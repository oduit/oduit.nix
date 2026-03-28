# Shared patches

Patches used by more than one package. Reference them from
`packages/<name>/package.nix` with a relative path:

```nix
patch -p1 -d $out/lib/foo < ${../../patches/<file>.patch}
```
