if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\T24N_2022" mkdir "Data\Rulesets\T24N_2022"
if exist BEMCompiler22c.exe BEMCompiler22c.exe --sharedPath1="../RulesetDev/Rulesets/shared/" --bemBaseTxt="../RulesetDev/Rulesets/BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/T24N/T24N_2022 BEMEnums.txt" --bemBaseBin="Data/Rulesets/T24N_2022/T24N_2022 BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/T24N/Rules/T24N_2022.txt" --rulesBin="Data/Rulesets/T24N_2022.bin" --rulesLog="_T24N-2022 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler22c.exe returned (%ERRORLEVEL%) for T24N_2022
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetDev\Rulesets\T24N\T24N_2022 Screens.txt"  "..\CBECC\Data\Rulesets\T24N_2022\T24N_2022 Screens.txt"
copy "..\RulesetDev\Rulesets\T24N\T24N ToolTips.txt" "..\CBECC\Data\Rulesets\T24N_2022\T24N_2022 ToolTips.txt"
copy "..\RulesetDev\Rulesets\T24N\*.jpg" "..\CBECC\Data\Rulesets\T24N_2022\*.*"
copy "..\RulesetDev\Rulesets\T24N\RTF\*.*" "..\CBECC\Data\Rulesets\T24N_2022\RTF\*.*"
copy "..\RulesetDev\Rulesets\shared\Screens*.txt" "..\CBECC\Data\Rulesets\T24N_2022\*.*"
copy "..\RulesetDev\Rulesets\shared\*.jpg" "..\CBECC\Data\Rulesets\T24N_2022\*.*"
rem copy "..\RulesetDev\Rulesets\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\T24N_2022\T24N_2022 Defaults.dbd"
rem copy "..\RulesetDev\Rulesets\T24N\DHWDU2.txt" "..\CBECC\CSE\*.*"
goto :done
:error
echo -
echo ----------------------------------
echo --- Errors occurred.
echo --- For more information, review:
echo ---   _T24N-2022 Rules Log.out
echo ----------------------------------
echo -
  pause
:done
