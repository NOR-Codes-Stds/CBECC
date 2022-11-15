if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\CEC 2016 Nonres" mkdir "Data\Rulesets\CEC 2016 Nonres"
if exist BEMCompiler16c.exe BEMCompiler16c.exe --bemBaseTxt="../RulesetDev/Rulesets/BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/T24N/T24N_2016 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CEC 2016 NonRes/CEC 2016 NonRes BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/T24N/Rules/T24N_2016.txt" --rulesBin="Data/Rulesets/CEC 2016 NonRes.bin" --rulesLog="_T24N-2016 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler16c.exe returned (%ERRORLEVEL%) for CEC 2016 NonRes
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetDev\Rulesets\T24N\T24N_2016 Screens.txt"  "..\CBECC-Com\Data\Rulesets\CEC 2016 Nonres\CEC 2016 NonRes Screens.txt"
copy "..\RulesetDev\Rulesets\T24N\T24N ToolTips.txt" "..\CBECC-Com\Data\Rulesets\CEC 2016 Nonres\CEC 2016 NonRes ToolTips.txt"
copy "..\RulesetDev\Rulesets\T24N\*.jpg" "..\CBECC-Com\Data\Rulesets\CEC 2016 Nonres\*.*"
rem copy "..\RulesetDev\Rulesets\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\CEC 2016 Nonres\CEC 2016 NonRes Defaults.dbd"
copy "..\RulesetDev\Rulesets\T24N\DHWDU.txt" "..\CBECC-Com\CSE\*.*"
goto done
:error
echo -
echo ----------------------------------
echo --- Errors occurred.
echo --- For more information, review:
echo ---   _T24N-2016 Rules Log.out
echo ----------------------------------
echo -
  pause
:done