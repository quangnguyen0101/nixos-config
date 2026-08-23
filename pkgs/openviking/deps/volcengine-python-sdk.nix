{
  fetchurl,
  buildPythonPackage,
  ps,
}:

buildPythonPackage rec {
  pname = "volcengine-python-sdk";
  version = "5.0.46";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e4/f0/171e760424849eabfe735c4b37e29949b2279555dd1654819db973ee7be7/volcengine_python_sdk-5.0.46-py2.py3-none-any.whl";
    hash = "sha256:f73e8f675f9ff545d0fec54b7057436dba0f1c420fcb235848a76a5120e5bf18";
  };

  dependencies = with ps; [
    certifi
    python-dateutil
    six
    urllib3
    pydantic
    httpx
    anyio
    cryptography
  ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
