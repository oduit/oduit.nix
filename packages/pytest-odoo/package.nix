{
  lib,
  flake,
  fetchurl,
  python3,
  python3Packages,
  writeShellApplication,
}:

let
  version = "2.2.0";

  plugin = python3Packages.buildPythonPackage rec {
    pname = "pytest-odoo";
    inherit version;
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/06/8b/f683d2358a8e8c6ffe2340ad44133ada36b96952c384770d0a79435666cb/pytest_odoo-${version}.tar.gz";
      hash = "sha256-0kE6moJXJrwyVcML7utxXHIShJVlZeyAReIrKqlOpBY=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages."setuptools-scm"
      python3Packages.wheel
    ];

    propagatedBuildInputs = [ python3Packages.pytest ];

    doCheck = false;
  };

  pythonEnv = python3.withPackages (_: [ plugin ]);
in
writeShellApplication {
  name = "pytest-odoo";

  runtimeInputs = [ pythonEnv ];

  text = ''
        case "${"$"}{1-}" in
          ""|-h|--help)
            cat <<'EOF'
    Usage: pytest-odoo [pytest args...]

    Runs pytest with the pytest_odoo plugin enabled.
    Requires an Odoo Python environment when executing tests.
    EOF
            exit 0
            ;;
        esac

        exec pytest -p pytest_odoo "$@"
  '';

  passthru.category = "Testing";

  meta = with lib; {
    description = "pytest wrapper for running Odoo tests with pytest-odoo";
    homepage = "https://github.com/camptocamp/pytest-odoo";
    changelog = "https://github.com/camptocamp/pytest-odoo/tree/${version}";
    license = licenses.agpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "pytest-odoo";
    platforms = platforms.unix;
  };
}
