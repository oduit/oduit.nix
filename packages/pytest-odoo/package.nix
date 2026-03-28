{
  lib,
  flake,
  fetchurl,
  python3,
  python3Packages,
  writeShellApplication,
}:

let
  version = "2.1.3";

  plugin = python3Packages.buildPythonPackage rec {
    pname = "pytest-odoo";
    inherit version;
    format = "setuptools";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/84/c3/430684a80c0448f241397341d361801c901846c947f79815e639572d3585/pytest_odoo-${version}.tar.gz";
      hash = "sha256-eI1sxQDTNiSniecp9ByZXo+Cmz7oWWzvDUtIAJgQWOw=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages."setuptools-scm"
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
