{
  lib,
  flake,
  fetchFromGitHub,
  writeShellApplication,
  coreutils,
}:

let
  rev = "4bd37324fb5ab4fe8e051eb2b71e5c754d1397fb";
  version = "unstable-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "initOS";
    repo = "dob";
    inherit rev;
    hash = "sha256-TkryIm/ItfojplbSJkRxPMxCnE7SO2JlQpPqVztXvK4=";
  };
in
writeShellApplication {
  name = "dob-init";

  runtimeInputs = [ coreutils ];

  text = ''
        set -euo pipefail

        show_help() {
          cat <<'EOF'
    Usage: dob-init [DEST]

    Copy the initOS/dob project scaffold into DEST.
    DEST defaults to the current directory and must be empty.
    EOF
        }

        case "${"$"}{1-}" in
          -h|--help)
            show_help
            exit 0
            ;;
        esac

        if [ "$#" -gt 1 ]; then
          show_help >&2
          exit 2
        fi

        dest="${"$"}{1:-.}"
        template=${src}

        if [ ! -e "$dest" ]; then
          mkdir -p "$dest"
        fi

        if [ -n "$(ls -A "$dest")" ]; then
          printf 'dob-init: destination is not empty: %s\n' "$dest" >&2
          exit 1
        fi

        cp -a "$template"/. "$dest"/
        chmod +x "$dest/setup.sh"
        if [ -f "$dest/bin/odoo" ]; then
          chmod +x "$dest/bin/odoo"
        fi

        printf 'Initialized dob project in %s\n' "$dest"
        printf 'Next steps:\n'
        printf '  cd %s\n' "$dest"
        printf '  ./setup.sh\n'
        printf '  docker compose build\n'
  '';

  passthru.category = "Packaging";

  meta = with lib; {
    description = "Project scaffold for bootstrapping Odoo instances with Docker Compose";
    homepage = "https://github.com/initOS/dob";
    changelog = "https://github.com/initOS/dob/commit/${rev}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "dob-init";
    platforms = platforms.unix;
  };
}
