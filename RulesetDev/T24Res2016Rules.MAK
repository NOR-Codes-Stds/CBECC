# NMAKE file: runs BEMPCmpl as required to compile rule source for CBECC-Res

TARGET_BEMBIN = "..\CBECC-Res\Data\Rulesets\CA Res 2016\CAR16 BEMBase.bin"
TARGET_RULEBIN = "..\CBECC-Res\Data\Rulesets\CA Res 2016.bin"
TARGET = $(TARGET_BEMBIN) $(TARGET_RULEBIN)

RULESET_PATH = {"Rulesets\CA Res"}
RULESET_SRC = \
       $(RULESET_PATH)"CAR13 BEMBase.txt" \
       $(RULESET_PATH)"CAR16 BEMEnums.txt" \
       $(RULESET_PATH)"CAR13 Defaults.dbd" \
       $(RULESET_PATH)"CAR16 Screens.txt" \
       $(RULESET_PATH)"CAR13 ToolTips.txt"

RULES_PATH = {"Rulesets\CA Res\Rules"}
RULES_SRC = \
       $(RULES_PATH)"CA Res 2013 Tables.xlsx" \
       $(RULES_PATH)CA13ClimateZoneDesignDay.csv \
       $(RULES_PATH)CA13CoolingEquipment.csv \
       $(RULES_PATH)CA13DistributionSystems.csv \
       $(RULES_PATH)CA13HeatingEquipment.csv \
       $(RULES_PATH)CA13SlabEdgeInsulation.csv \
       $(RULES_PATH)CAResFileHashes.csv \
       $(RULES_PATH)CAResKey.csv \
       $(RULES_PATH)"CEC 2016 Res TDV by CZ and Fuel.csv" \
       $(RULES_PATH)ClimateZone.txt \
       $(RULES_PATH)Datatype.txt \
       $(RULES_PATH)Library.txt \
       $(RULES_PATH)Location.txt \
       $(RULES_PATH)MaxChild.txt \
       $(RULES_PATH)Ranges.txt \
       $(RULES_PATH)Resets.txt \
       $(RULES_PATH)Rules.txt \
       $(RULES_PATH)Rules_BudgetConversion.rule \
       $(RULES_PATH)Rules_CSE_Simulation.rule \
       $(RULES_PATH)Rules_Default.rule \
       $(RULES_PATH)Rules_Default_Construction.rule \
       $(RULES_PATH)Rules_Default_HVAC.rule \
       $(RULES_PATH)Rules_ModelChecks.rule \
       $(RULES_PATH)Rules_ProposedModelPrep.rule \
       $(RULES_PATH)Rules_Results.rule \
       $(RULES_PATH)Rules_Rpt_BuildingSummaryCSV.rule \
       $(RULES_PATH)Symbols.txt \
       $(RULES_PATH)UniqueAssignments.txt

RTF_PATH = {"Rulesets\CA Res\RTF"}
RTF_SRC = \
       $(RTF_PATH)blank.rtf \
       $(RTF_PATH)HT_AWHP.rtf \
       $(RTF_PATH)HT_B.rtf \
       $(RTF_PATH)Ht_CF.rtf \
       $(RTF_PATH)Ht_CH.rtf \
       $(RTF_PATH)Ht_DHP.rtf \
       $(RTF_PATH)Ht_E.rtf \
       $(RTF_PATH)Ht_FF.rtf \
       $(RTF_PATH)Ht_GSHP.rtf \
       $(RTF_PATH)Ht_H.rtf \
       $(RTF_PATH)Ht_LPHP.rtf \
       $(RTF_PATH)Ht_PHP.rtf \
       $(RTF_PATH)Ht_RH.rtf \
       $(RTF_PATH)Ht_RHP.rtf \
       $(RTF_PATH)Ht_SHP.rtf \
       $(RTF_PATH)Ht_WFF.rtf \
       $(RTF_PATH)Ht_WFG.rtf

$(TARGET) : $(RULESET_SRC) $(RULES_SRC) $(RTF_SRC)
#	"..\CBECC-Res\CompileRules_CA2016_noUI.bat" $(ConfigurationName)
	"..\CBECC-Res\CompileRules_CA2016_noUI.bat"

clean :
	@del $(TARGET_BEMBIN)
	@del $(TARGET_RULEBIN)

rebuild : clean $(TARGET)

# T24Res2016Rules.MAK end
