{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  buildPythonPackage,
  ps,
}:

buildPythonPackage rec {
  pname = "openviking";
  version = "0.4.16";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/f7/65/f80154b1319f86762866fd3ef921de9e99325e936a29ed74b83ba144151d/openviking-0.4.16-cp310-abi3-manylinux_2_31_x86_64.whl";
    hash = "sha256:99bad4764a9be94c500073e0e96424607f478df901847419bf2fedb85ddd67ae";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  pythonRelaxDeps = [
    "urllib3"
    "python-multipart"
    "cryptography"
    "pathspec"
    "opentelemetry-instrumentation-asyncio"
  ];

  pythonRemoveDeps = [
    "tree-sitter-python"
    "tree-sitter-javascript"
    "tree-sitter-typescript"
    "tree-sitter-java"
    "tree-sitter-cpp"
    "tree-sitter-rust"
    "tree-sitter-go"
    "tree-sitter-c-sharp"
    "tree-sitter-php"
    "tree-sitter-lua"
  ];

  dependencies = with ps; [
    openviking-sdk
    pydantic
    typing-extensions
    pyyaml
    httpx
    pdfplumber
    scrapy
    trafilatura
    feedparser
    defusedxml
    openai
    requests
    charset-normalizer
    python-docx
    olefile
    xlrd
    python-pptx
    openpyxl
    ebooklib
    json-repair
    apscheduler
    volcengine
    volcengine-python-sdk
    fastapi
    uvicorn
    xxhash
    jinja2
    tabulate
    urllib3
    protobuf
    pdfminer-six
    typer
    litellm
    python-multipart
    tree-sitter
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-otlp-proto-http
    loguru
    cryptography
    argon2-cffi
    lark-oapi
    mcp
    pathspec
    grep-ast
    tree-sitter-language-pack
    opentelemetry-instrumentation-asyncio
  ];

  doCheck = false;
  pythonImportsCheck = [ ];
}
