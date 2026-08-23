{
  fetchurl,
  buildPythonPackage,

  google,
  protobuf,
  pycryptodome,
  pytz,
  requests,
  retry,
  six,
  tenacity,
  ...
}:

buildPythonPackage rec {
  pname = "volcengine";
  version = "1.0.228";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/d8/f0/c7f88b79a299ecc30629f07bf80cbef4ba8d2ca259593e10a5038daac4cc/volcengine-1.0.228-py3-none-any.whl";
    hash = "sha256:e1f09cff11123a922dea6eb530de5359021050b02ccfdbe1e8c316f498e7e5a7";
  };

  dependencies = [
    google
    protobuf
    pycryptodome
    pytz
    requests
    retry
    six
    tenacity
  ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
