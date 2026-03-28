{
  lib,
  flake,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "odoo-lsp";
  version = "nightly-20260206";

  src = fetchFromGitHub {
    owner = "Desdaemon";
    repo = "odoo-lsp";
    rev = version;
    hash = "sha256-laGLt9Pw5czRZXzX909ZPVDaNQc+PvpXm0Q1cA9YiQA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/version.rs \
      --replace-fail \
        'git_version::git_version!(args = ["--tags", "--candidates=0"], fallback = "")' \
        'match option_env!("GIT_VERSION") { Some(v) => v, None => "" }' \
      --replace-fail \
        'git_version::git_version!()' \
        'match option_env!("GIT_TAG") { Some(v) => v, None => concat!("v", env!("CARGO_PKG_VERSION")) }'
  '';

  GIT_VERSION = "v${version}";
  GIT_TAG = "v${version}";

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    outputHashes = {
      "tree-sitter-scheme-0.23.0" = "sha256-FK3F7v2LqAtXZM/CKCijWfXTF6TUhLmiVXScZqt46Io=";
    };
  };

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Language server for Odoo Python, JavaScript, and XML";
    homepage = "https://github.com/Desdaemon/odoo-lsp";
    changelog = "https://github.com/Desdaemon/odoo-lsp/releases/tag/${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ sbidoul ];
    mainProgram = "odoo-lsp";
    platforms = platforms.unix;
  };
}
