echo off
  echo --------------------------------------------
  echo Compiling 2028 ruleset...
BEMCompiler25r.exe --bemBaseTxt="../RulesetDev/Rulesets/CA Res/CAR13 BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/CA Res/CAR25 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2028/CAR28 BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/CA Res/Rules/Rules-2028.txt" --rulesBin="Data/Rulesets/CA Res 2028.bin" --rulesLog="../RulesetDev/Rulesets/CA Res/Rules/Rules-2028 Log.out" --compileDM --compileRules
echo BEMCompiler25r.exe returned (%ERRORLEVEL%) for CA Res 2028
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetDev\Rulesets\CA Res\CAR25 Screens.txt"  "Data\Rulesets\CA Res 2028\CAR28 Screens.txt"
copy "..\RulesetDev\Rulesets\CA Res\T24R ToolTips.txt" "Data\Rulesets\CA Res 2028\CAR28 ToolTips.txt"
copy "..\RulesetDev\Rulesets\CA Res\RTF\*.*" "Data\Rulesets\CA Res 2028\RTF\*.*"
copy "..\RulesetDev\Rulesets\CA Res\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  RulesetDev/Rulesets/CA Res/Rules/Rules-2028 Log.out
  echo --------------------------------------------
  pause
:finalDone
