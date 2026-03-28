{
  lib,
  writeShellApplication,
  fzf,
  nix,
  util-linux,
  packageList,
}:

let
  packageListFile = builtins.toFile "oduit-packages.tsv" packageList;
in
writeShellApplication {
  name = "oduit-launcher";

  runtimeInputs = [
    fzf
    nix
    util-linux # column
  ];

  text = ''
    # Format for fzf: "name  description" (tab-aligned)
    entries=$(column -t -s $'\t' < "${packageListFile}")

    if [[ -z $entries ]]; then
      echo "No packages found" >&2
      exit 1
    fi

    # Let user pick with fzf
    selected=$(echo "$entries" | fzf \
      --header="Select an AI tool to run (ESC to cancel)" \
      --preview-window=hidden \
      --no-multi \
      --height=~40% \
      --layout=reverse) || exit 0

    # Extract package name (first word)
    pkg_name=$(echo "$selected" | awk '{print $1}')

    if [[ -z $pkg_name ]]; then
      exit 0
    fi

    echo "→ Running: nix run github:oduit/oduit.nix#$pkg_name"
    exec nix run "github:oduit/oduit.nix#$pkg_name"
  '';

  meta = with lib; {
    description = "Interactive fzf launcher for oduit.nix packages";
    license = licenses.mit;
    mainProgram = "oduit-launcher";
    platforms = platforms.all;
  };

  passthru = {
    hideFromDocs = true;
  };
}
