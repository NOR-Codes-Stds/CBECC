echo off
  echo --------------------------------------------
  echo Compiling 2019.1.3 ruleset...
BEMCompiler19r.exe --bemBaseTxt="../RulesetDev/Rulesets/CA Res/BEMBase_19-1-2.txt" --bemEnumsTxt="../RulesetDev/Rulesets/CA Res/CAR19 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2019/CAR19 BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/CA Res/Rules/Rules-2019-1-2.txt" --rulesBin="Data/Rulesets/CA Res 2019.bin" --rulesLog="../RulesetDev/Rulesets/CA Res/Rules/Rules-2019-1-3 Log.out" --compileDM --compileRules
echo BEMCompiler19r.exe returned (%ERRORLEVEL%) for CA Res 2019
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetDev\Rulesets\CA Res\CAR19 Screens.txt"  "Data\Rulesets\CA Res 2019\*.*"
copy "..\RulesetDev\Rulesets\CA Res\CAR13 ToolTips.txt" "Data\Rulesets\CA Res 2019\CAR19 ToolTips.txt"
copy "..\RulesetDev\Rulesets\CA Res\RTF\*.*" "Data\Rulesets\CA Res 2019\RTF\*.*"
copy "..\RulesetDev\Rulesets\CA Res\DHWDU.txt" "CSE\*.*"
goto :done2
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  RulesetDev/Rulesets/CA Res/Rules/Rules-2019-1-3 Log.out
  echo --------------------------------------------
  pause
:done2
