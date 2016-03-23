@echo OFF

set R_exe="C:\Program Files\R\R-3.2.3\bin\RScript.exe"

:: path to this script
set TOP_DIR=%~dp0
:: replace backslash
set "TOP_DIR=%TOP_DIR:\=/%"

:: path from top directory to model directory
set MOD_DIR="Obs_Effective_Shade_v1/inputs/"

:: path from top directory to dummy directory
set DUM_DIR="/"

:: apply PEST dummy inputs to heat source inputs
:: last two args are pest dummy file name and heat source input name
%R_exe% R\lccodes_dummy.R %TOP_DIR% %MOD_DIR% %DUM_DIR% lccodes_dummy.csv start_lccodes_emergent.csv lccodes_emergent.csv
%R_exe% R\lcdata_dummy.R %TOP_DIR% %MOD_DIR% %DUM_DIR% lcdata_dummy.csv start_lcdata_emergent.csv lcdata_emergent.csv

:: run heat heatsource
python Obs_Effective_Shade_v1\HS9_Run_Solar_Only.py

