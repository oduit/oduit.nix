{
  lib,
  flake,
  fetchurl,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "click-odoo";
  version = "1.8.0";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/9a/8e/6f91dd9a5ec5116c6f791ae123111a9d3a4961529afe304b4cf733811820/click_odoo-${version}.tar.gz";
    hash = "sha256-DXLwoCZw+nHxwOeojZ5GKyLHBOUn6k+w2COHvCzDWJs=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [ python3Packages.click ];

  doInstallCheck = false;

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Beautiful, robust CLI for Odoo";
    homepage = "https://github.com/acsone/click-odoo";
    changelog = "https://github.com/acsone/click-odoo/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ sbidoul ];
    mainProgram = "click-odoo";
    platforms = platforms.unix;
  };
}
