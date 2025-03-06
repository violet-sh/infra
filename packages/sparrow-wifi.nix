{
  fetchFromGitHub,
  pkgs,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "sparrow-wifi";
  version = "b6018c5";

  src = fetchFromGitHub {
    owner = "ghostop14";
    repo = "sparrow-wifi";
    rev = "b6018c5";
    hash = "sha256-0CWk6YQgbnwF5NWJsZEpHGlZ6DdH/lcGamBxHg2pa+Y=";
  };

  propagatedBuildInputs = with pkgs; [
    iw
    qt5.qtbase
    wirelesstools
  ];

  nativeBuildInputs = with pkgs; [ qt5.wrapQtAppsHook ];

  dependencies = with python3Packages; [
    gps3
    manuf
    matplotlib
    numpy
    requests
    pyqtchart
    python-dateutil
    qscintilla
    tkinter
  ];

  dontWrapQtApps = true;

  preBuild = ''
        cat > setup.py << EOF
    from setuptools import setup, find_packages

    setup(
      name='sparrow-wifi',
      version='0.1.0',
      packages=find_packages(),
      scripts=[
        'sparrow-wifi.py'
      ],
      py_modules=[
        'sparrowbluetooth',
        'sparrowcommon',
        'sparrowdialogs',
        'sparrowdrone',
        'sparrowgps',
        'sparrowhackrf',
        'sparrowmap',
        'sparrowrpi',
        'sparrowtablewidgets',
        'sparrowwifiagent',
        'telemetry',
        'wirelessengine'
      ]
    )
    EOF
  '';

  postInstall = ''
    mv -v $out/bin/sparrow-wifi.py $out/bin/sparrow-wifi
  '';

  preFixup = ''
    wrapQtApp "$out/bin/sparrow-wifi" --prefix PATH : /path/to/bin
  '';
}
