{
  lib,
  flake,
  fetchFromGitHub,
  python3Packages,
}:

let
  rev = "32eb96e534727ad4ea482828a2ae0568cbae8319";
  version = "unstable-${lib.substring 0 7 rev}";
in
python3Packages.buildPythonApplication rec {
  pname = "odoo-module-migrator";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OCA";
    repo = "odoo-module-migrator";
    inherit rev;
    hash = "sha256-Ge1Bb95vzaYIZcsr4Yv76RP3ubfTcbaSsXDIb1hPIIE=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    python3Packages.argcomplete
    python3Packages.colorama
    python3Packages.lxml
    python3Packages.pyyaml
    python3Packages.requests
  ];

  pythonImportsCheck = [ "odoo_module_migrate" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/odoo-module-migrate --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "CLI to migrate Odoo modules between major versions";
    homepage = "https://github.com/OCA/odoo-module-migrator";
    changelog = "https://github.com/OCA/odoo-module-migrator/commit/${rev}";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ HolgerNahrstaedt ];
    mainProgram = "odoo-module-migrate";
    platforms = platforms.unix;
  };
}
