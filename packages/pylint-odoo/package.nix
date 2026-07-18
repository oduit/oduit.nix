{
  lib,
  flake,
  fetchurl,
  python3,
  python3Packages,
  writeShellApplication,
}:

let
  version = "10.0.8";

  plugin = python3Packages.buildPythonPackage rec {
    pname = "pylint-odoo";
    inherit version;
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/7b/84/ccc6549b536a0188cec056b4e1c8c53e2ab4d0038d30fec8f521ccb94321/pylint_odoo-${version}.tar.gz";
      hash = "sha256-zSY7em2jZ1LckepUX7J45Icsgtv1ZYZKrohJzTdc970=";
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
