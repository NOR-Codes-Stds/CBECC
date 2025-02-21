if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\T24_2025" mkdir "Data\Rulesets\T24_2025"
if exist BEMCompiler25c.exe BEMCompiler25c.exe --sharedPath1="../RulesetDev/Rulesets/shared/" --bemBaseTxt="../RulesetDev/Rulesets/BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/T24N/T24N_2025 BEMEnums.txt" --bemBaseBin="Data/Rulesets/T24_2025/T24_2025 BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/T24N/Rules/T24N_2025.txt" --rulesBin="Data/Rulesets/T24_2025.bin" --rulesLog="_T24-2025 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler25c.exe returned (%ERRORLEVEL%) for T24N_2025
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetDev\Rulesets\T24N\T24N_2025 Screens.txt"  "..\CBECC\Data\Rulesets\T24_2025\T24_2025 Screens.txt"
copy "..\RulesetDev\Rulesets\T24N\T24N ToolTips.txt" "..\CBECC\Data\Rulesets\T24_2025\T24_2025 ToolTips.txt"
copy "..\RulesetDev\Rulesets\T24N\*.jpg" "..\CBECC\Data\Rulesets\T24_2025\*.*"
copy "..\RulesetDev\Rulesets\T24N\RTF\*.*" "..\CBECC\Data\Rulesets\T24_2025\RTF\*.*"
copy "..\RulesetDev\Rulesets\shared\Screens*.txt" "..\CBECC\Data\Rulesets\T24_2025\*.*"
copy "..\RulesetDev\Rulesets\shared\*.jpg" "..\CBECC\Data\Rulesets\T24_2025\*.*"
rem copy "..\RulesetDev\Rulesets\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\T24_2025\T24_2025 Defaults.dbd"
rem copy "..\RulesetDev\Rulesets\T24N\DHWDU2.txt" "..\CBECC\CSE\*.*"
goto :done
:error
echo -
echo ----------------------------------
echo --- Errors occurred.
echo --- For more information, review:
echo ---   _T24-2025 Rules Log.out
echo ----------------------------------
echo -
  pause
:done
