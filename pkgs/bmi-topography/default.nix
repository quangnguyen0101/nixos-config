{ lib, fetchurl, buildPythonPackage, setuptools, requests, numpy, click, pyyaml, xarray, rioxarray, bmipy }:

buildPythonPackage rec {
  pname = "bmi-topography";
  version = "0.9.0";
  format = "pyproject";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/13/7b/f1d33479b8f3e49d50ab44209239cd319277e2893a431e59a5b21dd8beca/bmi_topography-${version}.tar.gz";
    hash = "sha256-KereTF5gXwI1ZSf+ia6BhfenKepQabRWRSnmbrzszoU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    numpy
    click
    pyyaml
    xarray
    rioxarray
    bmipy
  ];

  pythonImportsCheck = [ "bmi_topography" ];

  meta = {
    description = "Fetch and cache land elevation data from OpenTopography";
    license = lib.licenses.mit;
    homepage = "https://github.com/csdms/bmi-topography";
  };
}