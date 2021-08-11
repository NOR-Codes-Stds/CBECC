echo off
  echo --------------------------------------------
  echo Compiling 2019.2.0 ruleset...
BEMCompiler19r.exe --sharedPath1="../../branches/RulesetDev_MFamRestruct/Rulesets/shared/" --bemBaseTxt="../../branches/RulesetDev_MFamRestruct/Rulesets/CA Res/CAR13 BEMBase.txt" --bemEnumsTxt="../../branches/RulesetDev_MFamRestruct/Rulesets/CA Res/CAR19 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2019/CAR19 BEMBase.bin" --rulesTxt="../../branches/RulesetDev_MFamRestruct/Rulesets/CA Res/Rules/Rules-2019-2-0.txt" --rulesBin="Data/Rulesets/CA Res 2019.bin" --rulesLog="../../branches/RulesetDev_MFamRestruct/Rulesets/CA Res/Rules/Rules-2019 Log.out" --compileDM --compileRules
echo BEMCompiler19r.exe returned (%ERRORLEVEL%) for CA Res 2019
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\..\branches\RulesetDev_MFamRestruct\Rulesets\CA Res\CAR19 Screens.txt"  "Data\Rulesets\CA Res 2019\*.*"
copy "..\..\branches\RulesetDev_MFamRestruct\Rulesets\CA Res\CAR13 ToolTips.txt" "Data\Rulesets\CA Res 2019\CAR19 ToolTips.txt"
copy "..\..\branches\RulesetDev_MFamRestruct\Rulesets\CA Res\RTF\*.*" "Data\Rulesets\CA Res 2019\RTF\*.*"
copy "..\..\branches\RulesetDev_MFamRestruct\Rulesets\CA Res\DHWDU2.txt" "CSE\*.*"
goto :done2
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  RulesetDev/Rulesets/CA Res/Rules/Rules-2019 Log.out
  echo --------------------------------------------
  pause
:done2