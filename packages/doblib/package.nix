{
  lib,
  flake,
  fetchFromGitHub,
  python3Packages,
  gitAggregator,
}:

python3Packages.buildPythonApplication rec {
  pname = "doblib";
  version = "0.20.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "initOS";
    repo = "dob-lib";
    rev = "v${version}";
    hash = "sha256-QygZ//eyttiogeP8OckcuCQMYVxRr6KCsh9whvIZ8Wc=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "  pytest-odoo" ""
  '';

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    python3Packages.coverage
    gitAggregator
    python3Packages.ipython
    python3Packages."pylint-odoo"
    python3Packages."python-dateutil"
    python3Packages.pytest
    python3Packages."pytest-cov"
    python3Packages.pyyaml
  ];

  pythonImportsCheck = [ "doblib" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/dob --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Management tool for Odoo installations";
    homepage = "https://github.com/initOS/dob-lib";
    changelog = "https://github.com/initOS/dob-lib/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "dob";
    platforms = platforms.unix;
  };
}
