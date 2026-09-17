{
  fetchurl,
  buildPythonPackage,
  ps,
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-asyncio";
  version = "0.64b0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/48/91/d35ff82558e7de1fc53b9ed4465d672f2f872ec1225402bdfc0e95f24cc3/opentelemetry_instrumentation_asyncio-0.64b0-py3-none-any.whl";
    hash = "sha256:837e8538aee0f4def1b4b085408f187daff847fa27903049a6d3d3c34c4dda25";
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
