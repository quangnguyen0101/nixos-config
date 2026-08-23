{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  buildPythonPackage,
  ps,
}:

buildPythonPackage rec {
  pname = "tree-sitter-language-pack";
  version = "1.15.7";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/70/f6/783b62285b123a0734e7736fec86fce6c29e15f14058e78e258156de67cd/tree_sitter_language_pack-1.15.7-cp310-abi3-manylinux_2_34_x86_64.whl";
    hash = "sha256:9b23570bdb5f57f32cc1dc8970a8771b2fb54e0f2f2a25c365d7c19af1d690a2";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dependencies = with ps; [ tree-sitter ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
