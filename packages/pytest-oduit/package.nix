{
  lib,
  flake,
  fetchurl,
  oduit,
  python3,
  python3Packages,
  writeShellApplication,
}:

let
  version = "0.4.5";

  plugin = python3Packages.buildPythonPackage rec {
    pname = "pytest-oduit";
    inherit version;
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/19/b6/13008d0ced4be1143757996b1e8ad1d2ef9c0a41bf363382c9af2d60223a/pytest_oduit-${version}.tar.gz";
      hash = "sha256-FdPVkhG4c6P7zyGPyM2m9Zx+kAf8UnPTHkJx761qpvA=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages."setuptools-scm"
    ];

    propagatedBuildInputs = [
      oduit
      python3Packages.pytest
    ];

    doCheck = false;
  };

  pythonEnv = python3.withPackages (_: [
    oduit
    plugin
  ]);
in
writeShellApplication {
  name = "pytest-oduit";

  runtimeInputs = [ pythonEnv ];

  text = ''
        case "${"$"}{1-}" in
          ""|-h|--help)
            cat <<'EOF'
    Usage: pytest-oduit [pytest args...]

    Runs pytest with the pytest_oduit plugin enabled.
    Requires an Odoo Python environment when executing tests.
    EOF
            exit 0
            ;;
        esac

        exec pytest -p pytest_oduit "$@"
  '';

  passthru.category = "Testing";

  meta = with lib; {
    description = "pytest wrapper for running Odoo tests with pytest-oduit";
    homepage = "https://github.com/oduit/pytest-oduit";
    changelog = "https://github.com/oduit/pytest-oduit/tree/v${version}";
    license = licenses.agpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "pytest-oduit";
    platforms = platforms.unix;
  };
}
