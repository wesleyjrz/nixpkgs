{
  callPackage,
  lib,
  stdenv,
  fetchurl,
  nixos,
  testers,
  versionCheckHook,
  hello,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    hash = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
  };

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Give hello some install checks for testing purpose.
  postInstallCheck = ''
    stat "''${!outputBin}/bin/${finalAttrs.meta.mainProgram}"
  '';

  passthru.tests = {
    version = testers.testVersion { package = hello; };
  };

  passthru.tests.run = callPackage ./test.nix { hello = finalAttrs.finalPackage; };

  meta = {
    description = "Program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ stv0g ];
    mainProgram = "hello";
    platforms = lib.platforms.all;
  };
})
