echo off
  echo --------------------------------------------
  echo Compiling 2022 ruleset...
BEMCompiler22r.exe --sharedPath1="../RulesetSrc/shared/" --bemBaseTxt="../RulesetSrc/BEMBase-SFam.txt" --bemEnumsTxt="../RulesetSrc/T24SFam/CAR22 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2022/CAR22 BEMBase.bin" --rulesTxt="../RulesetSrc/T24SFam/Rules-2022.txt" --rulesBin="Data/Rulesets/CA Res 2022.bin" --rulesLog="_Rules-2022 Log.out" --compileDM --compileRules
echo BEMCompiler22r.exe returned (%ERRORLEVEL%) for CA Res 2022
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetSrc\T24SFam\CAR22 Screens.txt"  "Data\Rulesets\CA Res 2022\*.*"
copy "..\RulesetSrc\T24SFam\T24R_2022 ToolTips.txt" "Data\Rulesets\CA Res 2022\CAR22 ToolTips.txt"
copy "..\RulesetSrc\T24SFam\RTF\*.*" "Data\Rulesets\CA Res 2022\RTF\*.*"
copy "..\RulesetSrc\T24SFam\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  _Rules-2022 Log.out
  echo --------------------------------------------
  pause
:finalDone
