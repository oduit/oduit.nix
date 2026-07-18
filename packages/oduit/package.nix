{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "oduit";
  version = "0.4.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vs8Zy/dFlbZnkgnLmuzJLeIWfWnhn9FgSMkP6uQuj88=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  postPatch = ''
    substituteInPlace oduit/cli/agent/documentation.py \
      --replace-fail "from typer._click.core import ParameterSource" "from click.core import ParameterSource"
  '';

  propagatedBuildInputs = [
    python3Packages.click
    python3Packages.pyyaml
    python3Packages.tomli
    python3Packages."tomli-w"
    python3Packages.typer
    python3Packages."manifestoo-core"
  ];

  pythonImportsCheck = [ "oduit" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/oduit --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "CLI and library for running, updating, installing, and testing Odoo modules";
    homepage = "https://github.com/oduit/oduit";
    changelog = "https://github.com/oduit/oduit/releases/tag/v${version}";
    license = licenses.mpl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "oduit";
    platforms = platforms.unix;
  };
}
