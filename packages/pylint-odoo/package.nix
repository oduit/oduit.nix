{
  lib,
  flake,
  fetchurl,
  python3,
  python3Packages,
  writeShellApplication,
}:

let
  version = "10.0.2";

  plugin = python3Packages.buildPythonPackage rec {
    pname = "pylint-odoo";
    inherit version;
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4b/c2/0219110040e22a539c6e1bb6676963f45a906b2a9a430cfebd188c31400a/pylint_odoo-${version}.tar.gz";
      hash = "sha256-RaHg0TanNQFAgGhzfbeklmRZ55ZAdBodcWADR6Hbjlw=";
    };

    nativeBuildInputs = [ python3Packages.setuptools ];

    propagatedBuildInputs = [
      python3Packages.pylint
      python3Packages."pylint-plugin-utils"
    ];

    doCheck = false;
    pythonImportsCheck = [ "pylint_odoo" ];
  };

  pythonEnv = python3.withPackages (_: [ plugin ]);
in
writeShellApplication {
  name = "pylint-odoo";

  runtimeInputs = [ pythonEnv ];

  text = ''
    exec pylint --load-plugins=pylint_odoo "$@"
  '';

  passthru.category = "Testing";

  meta = with lib; {
    description = "Pylint plugin and wrapper for Odoo codebases";
    homepage = "https://github.com/OCA/pylint-odoo";
    changelog = "https://github.com/OCA/pylint-odoo/tree/v${version}";
    license = licenses.agpl3Only;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "pylint-odoo";
    platforms = platforms.unix;
  };
}
