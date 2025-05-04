echo off
  echo --------------------------------------------
  echo Compiling 2028 ruleset...
BEMCompiler28r.exe --bemBaseTxt="../RulesetSrc/BEMBase-SFam.txt" --bemEnumsTxt="../RulesetSrc/T24SFam/CAR25 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2028/CAR28 BEMBase.bin" --rulesTxt="../RulesetSrc/T24SFam/Rules-2028.txt" --rulesBin="Data/Rulesets/CA Res 2028.bin" --rulesLog="_Rules-2028 Log.out" --compileDM --compileRules
echo BEMCompiler28r.exe returned (%ERRORLEVEL%) for CA Res 2028
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetSrc\T24SFam\CAR25 Screens.txt"  "Data\Rulesets\CA Res 2028\CAR28 Screens.txt"
copy "..\RulesetSrc\T24SFam\T24R ToolTips.txt" "Data\Rulesets\CA Res 2028\CAR28 ToolTips.txt"
copy "..\RulesetSrc\T24SFam\RTF\*.*" "Data\Rulesets\CA Res 2028\RTF\*.*"
copy "..\RulesetSrc\T24SFam\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  _Rules-2028 Log.out
  echo --------------------------------------------
  pause
:finalDone
