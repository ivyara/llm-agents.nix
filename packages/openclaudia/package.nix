{
  lib,
  flake,
  fetchFromGitHub,
  rustfmt,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "openclaudia";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "dollspace-gay";
    repo = "OpenClaudia";
    rev = "7a35a581b2b135de259ecb2e3822dbf6b1a5bbd7";
    hash = "sha256-iIQ1u3ApGapLeFJKzLitHjYZix8aDrZKqV7dWzeB9mI=";
  };

  # Tests require a writable filesystem
  doCheck = false;

  cargoHash = "sha256-z183ihwi506cOxHA1oQ3sP76WAgOn7Av6aSvTZ5pUXM=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";
  # Upstream has no tagged release yet; we track an unstable rev. The binary
  # reports the Cargo workspace.package.version (e.g. 0.1.0), so compare
  # against that rather than our `0-unstable-<date>` derivation version.
  preVersionCheck = ''
    version=$(sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -n1)
  '';

  nativeBuildInputs = [
    rustfmt
  ];

  passthru.category = "AI Coding Agents";

  meta = with lib; {
    description = "Open Source Agentic Coding Harness";
    homepage = "https://github.com/dollspace-gay/OpenClaudia";
    changelog = "https://github.com/dollspace-gay/OpenClaudia/blob/main/CHANGELOG.md";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ Chickensoupwithrice ];
    mainProgram = "openclaudia";
    platforms = platforms.all;
  };
}
