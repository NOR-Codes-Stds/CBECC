echo off
  echo --------------------------------------------
  echo Compiling 2022 ruleset...
BEMCompiler22r.exe --bemBaseTxt="../RulesetDev/Rulesets/CA Res/CAR13 BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/CA Res/CAR22 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2022/CAR22 BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/CA Res/Rules/Rules-2022.txt" --rulesBin="Data/Rulesets/CA Res 2022.bin" --rulesLog="../RulesetDev/Rulesets/CA Res/Rules/Rules-2022 Log.out" --compileDM --compileRules
echo BEMCompiler19r.exe returned (%ERRORLEVEL%) for CA Res 2022
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetDev\Rulesets\CA Res\CAR22 Screens.txt"  "Data\Rulesets\CA Res 2022\*.*"
copy "..\RulesetDev\Rulesets\CA Res\CAR13 ToolTips.txt" "Data\Rulesets\CA Res 2022\CAR22 ToolTips.txt"
copy "..\RulesetDev\Rulesets\CA Res\RTF\*.*" "Data\Rulesets\CA Res 2022\RTF\*.*"
copy "..\RulesetDev\Rulesets\CA Res\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  RulesetDev/Rulesets/CA Res/Rules/Rules-2022 Log.out
  echo --------------------------------------------
  pause
:finalDone
