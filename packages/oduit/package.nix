{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "oduit";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gDXZQY2WvtJO8+8w53lmdTEcO1K/KoL8GZhdg3ya+eY=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
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
    maintainers = with flake.lib.maintainers; [ HolgerNahrstaedt ];
    mainProgram = "oduit";
    platforms = platforms.unix;
  };
}
