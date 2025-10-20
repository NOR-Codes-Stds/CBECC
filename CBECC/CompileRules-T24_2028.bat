if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\T24_2028" mkdir "Data\Rulesets\T24_2028"
if exist BEMCompiler25.exe BEMCompiler25.exe --sharedPath1="../RulesetSrc/shared/" --bemBaseTxt="../RulesetSrc/BEMBase.txt" --bemEnumsTxt="../RulesetSrc/T24NRMF/T24N_2025 BEMEnums.txt" --bemBaseBin="Data/Rulesets/T24_2028/T24_2028 BEMBase.bin" --rulesTxt="../RulesetSrc/T24NRMF/T24N_2028.txt" --rulesBin="Data/Rulesets/T24_2028.bin" --rulesLog="_T24-2028 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler25.exe returned (%ERRORLEVEL%) for T24N_2028
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetSrc\T24NRMF\T24N_2025 Screens.txt"  "..\CBECC\Data\Rulesets\T24_2028\T24_2028 Screens.txt"
copy "..\RulesetSrc\T24NRMF\T24N ToolTips.txt" "..\CBECC\Data\Rulesets\T24_2028\T24_2028 ToolTips.txt"
copy "..\RulesetSrc\T24NRMF\*.jpg" "..\CBECC\Data\Rulesets\T24_2028\*.*"
copy "..\RulesetSrc\T24NRMF\RTF\*.*" "..\CBECC\Data\Rulesets\T24_2028\RTF\*.*"
copy "..\RulesetSrc\shared\RTF\*.*" "..\CBECC\Data\Rulesets\T24_2028\RTF\*.*"
copy "..\RulesetSrc\shared\Screens_Res_2025.txt" "..\CBECC\Data\Rulesets\T24_2028\Screens_Res_2025.txt"
copy "..\RulesetSrc\shared\*.jpg" "..\CBECC\Data\Rulesets\T24_2028\*.*"
rem copy "..\RulesetSrc\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\T24_2028\T24_2028 Defaults.dbd"
rem copy "..\RulesetSrc\T24NRMF\DHWDU2.txt" "..\CBECC\CSE\*.*"
goto :done
:error
echo -
echo ----------------------------------
echo --- Errors occurred.
echo --- For more information, review:
echo ---   _T24-2028 Rules Log.out
echo ----------------------------------
echo -
  pause
:done
