{
  fetchurl,
  buildPythonPackage,
  ps,
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-asyncio";
  version = "0.55b0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/82/71/64ed9dc18c278fd153a09af240c46dbbcf13244b76c256c9c6798c2faf1d/opentelemetry_instrumentation_asyncio-0.55b0-py3-none-any.whl";
    hash = "sha256:3278ff8964877ce16388bbaf64657aa6dfa3e5ec07175583ed720d37cf4a5691";
  };

  dependencies = with ps; [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
