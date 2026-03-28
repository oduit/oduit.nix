{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "whool";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F0TVb8DeZf/25PykzV5xH/ChDPQfxwLb1UN6kpm0Avs=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
    python3Packages."hatch-vcs"
  ];

  propagatedBuildInputs = [
    python3Packages."importlib-metadata"
    python3Packages."manifestoo-core"
    python3Packages.tomli
    python3Packages.wheel
  ];

  pythonImportsCheck = [ "whool" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/whool --version > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Packaging";

  meta = with lib; {
    description = "Build backend and CLI for Odoo addons";
    homepage = "https://github.com/sbidoul/whool";
    changelog = "https://github.com/sbidoul/whool/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "whool";
    platforms = platforms.unix;
  };
}
