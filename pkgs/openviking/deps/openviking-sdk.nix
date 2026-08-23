{
  fetchurl,
  buildPythonPackage,
  httpx,
  ...
}:

buildPythonPackage rec {
  pname = "openviking-sdk";
  version = "0.1.8";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/14/4b/70125f8f773b1bbf3977986d409f0533ed3f086e37cfe2ec558d2256e42f/openviking_sdk-0.1.8-py3-none-any.whl";
    hash = "sha256:9735fdd5425203124fa6e27bbe114f850bde9b36d4d132d68adf76556b90107c";
  };

  dependencies = [ httpx ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
