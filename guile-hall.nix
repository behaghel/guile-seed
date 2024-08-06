{ lib, stdenv, fetchFromGitLab,
  autoreconfHook, pkg-config, texinfo, makeWrapper,
  guile, guile-config, guile-lib }:
stdenv.mkDerivation rec {
  pname = "guile-hall";
  version = "0.5.0";
  src = fetchFromGitLab {
    owner = "a-sassmannshausen";
    repo = "guile-hall";
    rev = "cc0c9016220de42084f9b61f7353edeb62dbff82";
    hash = "sha256:149plgjlm43wp8nch6afw7dp35yjhply0ap9jnzkclvfa849z66g";
  };
  nativeBuildInputs = [ autoreconfHook pkg-config texinfo makeWrapper ];
  buildInputs = [ guile guile-config guile-lib ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/hall \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$TMPDIR
    $out/bin/hall --version | grep ${version} > /dev/null
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Project manager for GNU Guile";
    homepage    = "https://gitlab.com/a-sassmannshausen/guile-hall";
    license     = licenses.gpl3Plus;
    platforms   = guile.meta.platforms;
    maintainers = [ maintainers.sikmir ];
  };
}