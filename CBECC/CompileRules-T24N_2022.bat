if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\T24N_2022" mkdir "Data\Rulesets\T24N_2022"
if exist BEMCompiler22c.exe BEMCompiler22c.exe --sharedPath1="../RulesetSrc/shared/" --bemBaseTxt="../RulesetSrc/BEMBase.txt" --bemEnumsTxt="../RulesetSrc/T24NRMF/T24N_2022 BEMEnums.txt" --bemBaseBin="Data/Rulesets/T24N_2022/T24N_2022 BEMBase.bin" --rulesTxt="../RulesetSrc/T24NRMF/T24N_2022.txt" --rulesBin="Data/Rulesets/T24N_2022.bin" --rulesLog="_T24N-2022 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler22c.exe returned (%ERRORLEVEL%) for T24N_2022
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetSrc\T24NRMF\T24N_2022 Screens.txt"  "..\CBECC\Data\Rulesets\T24N_2022\T24N_2022 Screens.txt"
copy "..\RulesetSrc\T24NRMF\T24N ToolTips.txt" "..\CBECC\Data\Rulesets\T24N_2022\T24N_2022 ToolTips.txt"
copy "..\RulesetSrc\T24NRMF\*.jpg" "..\CBECC\Data\Rulesets\T24N_2022\*.*"
copy "..\RulesetSrc\T24NRMF\RTF\*.*" "..\CBECC\Data\Rulesets\T24N_2022\RTF\*.*"
copy "..\RulesetSrc\shared\RTF\*.*" "..\CBECC\Data\Rulesets\T24N_2022\RTF\*.*"
copy "..\RulesetSrc\shared\Screens_Res-2022.txt" "..\CBECC\Data\Rulesets\T24N_2022\Screens_Res.txt"
copy "..\RulesetSrc\shared\*.jpg" "..\CBECC\Data\Rulesets\T24N_2022\*.*"
rem copy "..\RulesetSrc\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\T24N_2022\T24N_2022 Defaults.dbd"
rem copy "..\RulesetSrc\T24NRMF\DHWDU2.txt" "..\CBECC\CSE\*.*"
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
