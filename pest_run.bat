@echo OFF

set R_exe="C:\Program Files\R\R-3.2.3\bin\RScript.exe"

:: path to this script
set TOP_DIR=%~dp0
:: replace backslash
set "TOP_DIR=%TOP_DIR:\=/%"

:: path from top directory to heat source model input directory
set MOD_DIR="Obs_Effective_Shade_v1/hs_inputs/"

:: path from top directory to directory where pest writes the dummy input
set DUM_DIR="/"

:: Apply the information PEST wrote to th edummy inputs into the heat source inputs
:: The R scripts do this work but they are executed from here
::
:: Arguments passed to R script:
:: 1. R executable
:: 2. path from top directory to the R script being executed
:: 3. TOP_DIR (see above)
:: 4. MOD_DIR (see above)
:: 5. DUM_DIR (see above)
:: 6. the name of the input dummy file PEST writes (based on template file)- located in DUM_DIR
:: 7. the name of the starting heat source input file
:: 8. the name of the input file heat source will read
:: last three args are pest dummy input file name and heat source input file name
%R_exe% R\lccodes_dummy.R %TOP_DIR% %MOD_DIR% %DUM_DIR% ptf_lccodes_dummy.csv start_lccodes_emergent.csv lccodes_emergent.csv
%R_exe% R\lcdata_dummy.R %TOP_DIR% %MOD_DIR% %DUM_DIR% ptf_lcdata_dummy.csv start_lcdata_emergent.csv lcdata_emergent.csv

:: run heat source
python Obs_Effective_Shade_v1\HS9_Run_Solar_Only.py

