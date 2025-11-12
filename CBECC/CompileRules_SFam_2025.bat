echo off
  echo --------------------------------------------
  echo Compiling 2025 SFam ruleset...
BEMCompiler25.exe --sharedPath1="../RulesetSrc/shared/" --bemBaseTxt="../RulesetSrc/BEMBase-SFam.txt" --bemEnumsTxt="../RulesetSrc/T24SFam/CAR25 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2025/CAR25 BEMBase.bin" --rulesTxt="../RulesetSrc/T24SFam/Rules-2025.txt" --rulesBin="Data/Rulesets/CA Res 2025.bin" --rulesLog="_Rules-SFam-2025 Log.out" --compileDM --compileRules
echo BEMCompiler25.exe returned (%ERRORLEVEL%) for CA Res 2025
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetSrc\T24SFam\CAR25 Screens.txt"  "Data\Rulesets\CA Res 2025\*.*"
copy "..\RulesetSrc\T24SFam\T24R ToolTips.txt" "Data\Rulesets\CA Res 2025\CAR25 ToolTips.txt"
copy "..\RulesetSrc\T24SFam\RTF\*.*" "Data\Rulesets\CA Res 2025\RTF\*.*"
copy "..\RulesetSrc\shared\*.jpg" "Data\Rulesets\CA Res 2025\*.*"
copy "..\RulesetSrc\shared\*.png" "Data\Rulesets\CA Res 2025\*.*"
rem copy "..\RulesetSrc\T24SFam\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  _Rules-SFam-2025 Log.out
  echo --------------------------------------------
  pause
:finalDone
