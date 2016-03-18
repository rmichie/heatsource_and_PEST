@echo OFF

set R_exe="C:\Program Files\R\R-3.2.3\bin\RScript.exe"
set py_exe="C:\Python27\python.exe"

:: path to this script
set TOP_DIR=%~dp0

:: replace backslash
set "TOP_DIR=%TOP_DIR:\=/%"

:: convert inputs so heat source can read
set IN_NAME="lccodes_current.txt"
set MODEL_DIR="Obs_Effective_Shade_v1/inputs/"
set OUT_NAME="lccodes_current.csv"
%R_exe% csv2txt.R %TOP_DIR% %MODEL_DIR% %IN_NAME% %OUT_NAME%

:: run heat heatsource
python Obs_Effective_Shade_v1\HS9_Run_Solar_Only.py

:: convert outputs to text so PEST can read
set IN_NAME="Shade.csv"
set MODEL_DIR="Obs_Effective_Shade_v1/outputs/"
set OUT_NAME="Shade.txt"
%R_exe% csv2txt.R %TOP_DIR% %MODEL_DIR% %IN_NAME% %OUT_NAME%
