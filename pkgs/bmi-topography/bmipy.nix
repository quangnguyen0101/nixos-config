{ lib, fetchurl, buildPythonPackage, click, jinja2, numpy, black }:

buildPythonPackage rec {
  pname = "bmipy";
  version = "2.0.1";
  format = "setuptools";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/de/22/4af81bc6c8546b3a1e2cd69bebb8f41644bdd1306361d8c32799a1115ad7/bmipy-${version}.tar.gz";
    hash = "sha256-BviVcRu6azQMKpJBHKikCl64Ij6hjyC2x9j1x9w0mz0=";
  };

  propagatedBuildInputs = [ click jinja2 numpy black ];

  pythonImportsCheck = [ "bmipy" ];

  meta = {
    description = "Python tools for building next-generation Basic Model Interfaces";
    license = lib.licenses.mit;
    homepage = "https://github.com/csdms/bmipy";
  };
}