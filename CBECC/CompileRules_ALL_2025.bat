if not exist "Data\Rulesets" mkdir "Data\Rulesets"
if not exist "Data\Rulesets\T24_2025" mkdir "Data\Rulesets\T24_2025"
if not exist "Data\Rulesets\CA Res 2025" mkdir "Data\Rulesets\CA Res 2025"
if exist BEMCompiler25c.exe BEMCompiler25c.exe --sharedPath1="../RulesetSrc/shared/" --bemBaseTxt="../RulesetSrc/BEMBase.txt" --bemEnumsTxt="../RulesetSrc/T24NRMF/T24N_2025 BEMEnums.txt" --bemBaseBin="Data/Rulesets/T24_2025/T24_2025 BEMBase.bin" --rulesTxt="../RulesetSrc/T24NRMF/T24N_2025.txt" --rulesBin="Data/Rulesets/T24_2025.bin" --rulesLog="_T24-2025 Rules Log.out" --compileDM --compileRules
echo OFF
echo BEMCompiler25c.exe returned (%ERRORLEVEL%) for T24N_2025
if %ERRORLEVEL%==0 goto :copyfiles
goto :error
:copyfiles
copy "..\RulesetSrc\T24NRMF\T24N_2025 Screens.txt"  "..\CBECC\Data\Rulesets\T24_2025\T24_2025 Screens.txt"
copy "..\RulesetSrc\T24NRMF\T24N ToolTips.txt" "..\CBECC\Data\Rulesets\T24_2025\T24_2025 ToolTips.txt"
copy "..\RulesetSrc\T24NRMF\*.jpg" "..\CBECC\Data\Rulesets\T24_2025\*.*"
copy "..\RulesetSrc\T24NRMF\RTF\*.*" "..\CBECC\Data\Rulesets\T24_2025\RTF\*.*"
copy "..\RulesetSrc\shared\RTF\*.*" "..\CBECC\Data\Rulesets\T24_2025\RTF\*.*"
copy "..\RulesetSrc\shared\Screens_Res_2025.txt" "..\CBECC\Data\Rulesets\T24_2025\*.*"
copy "..\RulesetSrc\shared\*.jpg" "..\CBECC\Data\Rulesets\T24_2025\*.*"
rem copy "..\RulesetSrc\CEC 2013 Nonres\CEC 2013 NonRes Defaults.dbd" "..\CBECC-Com\Data\Rulesets\T24_2025\T24_2025 Defaults.dbd"
rem copy "..\RulesetSrc\T24NRMF\DHWDU2.txt" "..\CBECC\CSE\*.*"
goto :done
:error
echo -
echo ----------------------------------
echo --- Errors occurred.
echo --- For more information, review:
echo ---   _T24-2025 Rules Log.out
echo ----------------------------------
echo -
  pause
:done
echo off
  echo --------------------------------------------
  echo Compiling 2025 SFam ruleset...
if exist BEMCompiler25c.exe BEMCompiler25c.exe --bemBaseTxt="../RulesetSrc/BEMBase-SFam.txt" --bemEnumsTxt="../RulesetSrc/T24SFam/CAR25 BEMEnums.txt" --bemBaseBin="Data/Rulesets/CA Res 2025/CAR25 BEMBase.bin" --rulesTxt="../RulesetSrc/T24SFam/Rules-2025.txt" --rulesBin="Data/Rulesets/CA Res 2025.bin" --rulesLog="_Rules-SFam-2025 Log.out" --compileDM --compileRules
echo BEMCompiler25c.exe returned (%ERRORLEVEL%) for CA Res 2025
if %ERRORLEVEL%==0 goto :copyfiles2
goto :error2
:copyfiles2
copy "..\RulesetSrc\T24SFam\CAR25 Screens.txt"  "Data\Rulesets\CA Res 2025\*.*"
copy "..\RulesetSrc\T24SFam\T24R ToolTips.txt" "Data\Rulesets\CA Res 2025\CAR25 ToolTips.txt"
copy "..\RulesetSrc\T24SFam\RTF\*.*" "Data\Rulesets\CA Res 2025\RTF\*.*"
rem copy "..\RulesetSrc\T24SFam\DHWDU2.txt" "CSE\*.*"
goto :finalDone
:error2
  echo --------------------------------------------
  echo Rule compilation errors occurred.
  echo See log file for details:  _Rules-SFam-2025 Log.out
  echo --------------------------------------------
  pause
:finalDone
