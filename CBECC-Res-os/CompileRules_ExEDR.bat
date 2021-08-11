echo off
  echo --------------------------------------------
  echo Compiling ExEDR ruleset...
BEMCompiler16r.exe --bemBaseTxt="../RulesetDev/Rulesets/CA Res/CAR13 BEMBase.txt" --bemEnumsTxt="../RulesetDev/Rulesets/CA Res/CAR-ExEDR BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res ExEDR/CAR-ExEDR BEMBase.bin" --rulesTxt="../RulesetDev/Rulesets/CA Res/Rules/Rules-ExEDR.txt" --rulesBin="Data/Rulesets/CA Res ExEDR.bin" --rulesLog="../RulesetDev/Rulesets/CA Res/Rules/Rules-ExEDR Log.out" --compileDM --compileRules
echo BEMCompiler16r.exe returned (%ERRORLEVEL%) for CA Res ExEDR
if %ERRORLEVEL%==0 goto :copyfiles1
goto :error1
:copyfiles1
copy "..\RulesetDev\Rulesets\CA Res\CAR-ExEDR Screens.txt"  "Data\Rulesets\CA Res ExEDR\*.*"
copy "..\RulesetDev\Rulesets\CA Res\CAR13 ToolTips.txt" "Data\Rulesets\CA Res ExEDR\CAR-ExEDR ToolTips.txt"
copy "..\RulesetDev\Rulesets\CA Res\RTF\*.*" "Data\Rulesets\CA Res ExEDR\RTF\*.*"
copy "..\RulesetDev\Rulesets\CA Res\DHWDU.txt" "CSE\*.*"
goto :done1
:error1
  echo --------------------------------------------
  echo ExEDR ruleset compilation errors occurred.
  echo See log file for details:  RulesetDev/Rulesets/CA Res/Rules/Rules-ExEDR Log.out
  echo --------------------------------------------
  pause
:done1
