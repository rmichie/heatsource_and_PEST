@echo OFF

set R_Script="C:\Program Files\R\R-3.0.3\bin\RScript.exe"

:: path to this script
set MYPATH=%~dp0

:: replace backslash
set "MYPATH=%MYPATH:\=/%"

%R_Script% csv2txt_outputs.R %MYPATH%
