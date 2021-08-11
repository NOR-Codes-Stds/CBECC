<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:date="http://exslt.org/dates-and-times" xmlns:str="http://exslt.org/strings"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" extension-element-prefixes="date str">
	<xsl:output indent="no" encoding="utf-8"/>


	<!--
		This stylesheet was generated for a 'en_US' Translation ID. 
		The Translation ID applies to both the whole text in a document and the locale-long and locale-short date formats.
	  -->

	<!-- ============================ GROUPING KEYS =============================== -->
	<!-- ============================ RAW XSL =============================== -->
	<!-- Parameters passed by Report Generator -->
	<xsl:param name="draft" select="'NotCertified'"/>
	<xsl:param name="AtVersion">560</xsl:param>
	<xsl:param name="VersionDate">05262016</xsl:param>
	<xsl:param name="Expiry">2014-12-31</xsl:param>
	<!-- Check if the Expiry date has passed 1 = true; 0 = false-->
	<xsl:variable name="isExpired">
		<!-- Need a function for this tied to a parameter that is passed:  can do this after deployment -->
		0
	</xsl:variable>

	<!-- Global Variables -->
	<!-- Check the DevMode Flag -->
	<xsl:variable name="useDebug" select="//SDDXML/Model[@Name='Proposed']/Proj/DevMode"/>
	<!-- Code Year -->
	<xsl:variable name="energyCodeYear" select="//Model[@Name='Proposed']/Proj/EnergyCodeYear"/>
	<!-- MultiFamily Flag -->
	<xsl:variable name="isMF" select="//Model[@Name='Proposed']/Proj/IsMultiFamily"/>
	<!-- RunScope -->
	<xsl:variable name="runScope" select="//Model[@Name='Proposed']/Proj/RunScope"/>
	<!-- Detect NoCooling -->
	<xsl:variable name="noCooling" select="//SDDXML/Model[@Name='Proposed']/SpeclFtr/NoCooling"/>
	<!-- EDR Variable -->
	<xsl:variable name="hasEDR" select="//Model[@Name='Proposed']/Proj/DesignRatingCalcs"/>

	<!-- General PV Input variables -->
	<xsl:variable name="pvRowCount" select="//Model[@Name='Proposed']/Proj/PVWLastRow"/>
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="pvInputType" select="//Model[@Name='Proposed']/Proj/PVWInputs"/>

	<!-- CFI Variables -->
	<xsl:variable name="cfi1" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=0]"/>
	<xsl:variable name="cfi2" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=1]"/>
	<xsl:variable name="cfi3" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=2]"/>
	<xsl:variable name="cfi4" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=3]"/>
	<xsl:variable name="cfi5" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=4]"/>

	<!-- PVWSysSize Variables -->
	<xsl:variable name="sysSize1" select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=0]"/>
	<xsl:variable name="sysSize2" select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=1]"/>
	<xsl:variable name="sysSize3" select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=2]"/>
	<xsl:variable name="sysSize4" select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=3]"/>
	<xsl:variable name="sysSize5" select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=4]"/>
	<!-- Get the HERS Other features -->
	<xsl:variable name="has_feature" select="sum(//SDDXML/Model[@Name='Proposed']/HERSOther/*[.=1])"/>
	<!-- Fan is not included with Cooling measures in the HERSCool nodeset -->
	<xsl:variable name="test_fan">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef]/HERSCheck]/AHUFanEff=1">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef]/HERSCheck]/AHUFanEff)"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef]/HERSCheck]/AHUFanEff=1">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef]/HERSCheck]/AHUFanEff)"
				/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<!-- The rest of the cooling measures -->
	<xsl:variable name="test_cool">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<!--<xsl:when test="not($noCooling=1) and //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]
				 or not($noCooling=1) and //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]) 
					or sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"/>
			</xsl:when>
			<xsl:when test="not($noCooling=1) and //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]
				 or not($noCooling=1) and //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]) 
					or sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"/>
			</xsl:when>-->
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Move test for Distribution System modification so that HVAC box change only does not trigger HERS for Airflow and Fan Watt Draw -->
	<xsl:variable name="test_dist">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Are there existing ducts -->
	<xsl:variable name="doDuctsExist">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/IsExisting">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/IsExisting)"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/IsExisting">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/IsExisting)"
				/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Is there less than 40 ft of duct -->
	<xsl:variable name="isLessThanFortyFt">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/IsLessThanFortyFt">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/IsLessThanFortyFt)"
				/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/IsLessThanFortyFt">
				<xsl:value-of
					select="sum(//SDDXML/Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/IsLessThanFortyFt)"
				/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Combine duct exclusions -->
	<xsl:variable name="excludeDucts">
		<xsl:choose>
			<xsl:when test="$doDuctsExist > 0 or $isLessThanFortyFt > 0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Water Heating HERS Measure Variable to indicate if there re HERS MEasures for DHW -->
	<xsl:variable name="test_dhw">
		<xsl:choose>
			<xsl:when
				test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<!-- For SF we only need to test DHWSys1 -->
			<xsl:when
				test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="sum(//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Variables to toggle messages in top summary and cooling tables and watermark-->
	<!-- Other HERS Cooling Measures are included -->
	<xsl:variable name="hasAirflow">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow=1">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow)"/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow=1">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow)"/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow=1">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow)"/>
			</xsl:when>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow=1">
				<xsl:value-of select="sum(//SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow)"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Get the SHowNotWatermark flag (Yoda) -->
	<xsl:variable name="getYodaFlag"
		select="//SDDXML/Model[@Name='Proposed']/Proj/ShowNotRegWatermark"/>
	<!-- Count the cooling measures so we can compare -->
	<xsl:variable name="coolItemCount">
		<xsl:choose>
			<xsl:when test="($test_cool > 0 and $hasAirflow > 0) and ($test_cool = $hasAirflow)"> </xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="boxOnly">
		<xsl:choose>
			<xsl:when test="($test_fan > 0 or $hasAirflow > 0) and $excludeDucts=1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Test of other HERS Measures exist -->
	<xsl:variable name="otherCool">
		<xsl:choose>
			<xsl:when test="$test_cool > $hasAirflow">
				<xsl:value-of select="$test_cool - $hasAirflow"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Check if there are other measures -->
	<xsl:variable name="hasHERS">
		<xsl:choose>
			<xsl:when test="$otherCool > 0 or $has_feature > 0 or $test_dhw > 0 or $test_dist > 0">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Show the watermark -->
	<xsl:variable name="showWatermark">
		<xsl:choose>
			<xsl:when test="$hasHERS = 0 and $boxOnly = 0 and $getYodaFlag = 0">0</xsl:when>
			<xsl:when test="$hasHERS = 0 and $boxOnly = 1 and $getYodaFlag = 1">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- END - Global Variables -->
	<!-- =========================== SCRIPTS ================================ -->

	<!--  every table   -->
	<xsl:attribute-set name="table">
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		<xsl:attribute name="margin-top">5pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tableLast">
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="cell">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- fix for document declaration cell spacing to align the signatures	-->
	<xsl:attribute-set name="cellD">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt 2pt 3pt 2pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="cellD2">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt 2pt 4pt 2pt</xsl:attribute>
	</xsl:attribute-set>
	<!--  end fix -->

	<xsl:attribute-set name="cellB">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="cellC">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="cellAC">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="padding">2pt</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="headerRow">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="titleRow">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>
	

	<xsl:attribute-set name="numberCellB">
		<xsl:attribute name="padding">2pt 2pt 2pt 2pt</xsl:attribute>
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="numberCell">
		<xsl:attribute name="padding">2pt 2pt 2pt 2pt</xsl:attribute>
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="right">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="bold">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="lastBlockBelowTable">
		<xsl:attribute name="font-size">7pt</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="sup6">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size">6pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- ========================= ROOT TEMPLATE =========================== -->
	<xsl:template match="/">

		<fo:root font-family="Arial" font-size="8pt">

			<fo:layout-master-set>
				<fo:simple-page-master master-name="Letter Page" page-width="11in"
					page-height="8.5in">
					<fo:region-body region-name="xsl-region-body" margin="1in 0.5in 0.8in 0.5in"/>
					<fo:region-before region-name="xsl-region-before" display-align="after"
						extent="0.3in"/>
					<fo:region-after region-name="xsl-region-after" extent="0.8in"/>
					<fo:region-start region-name="xsl-region-start" extent="0.5in"/>
					<fo:region-end region-name="xsl-region-end" extent="0.5in"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

			<fo:page-sequence master-reference="Letter Page">
				<fo:static-content flow-name="xsl-region-after">
					<fo:block>
						<xsl:call-template name="CF1R_Footer">
							<xsl:with-param name="AtVersion" select="$AtVersion"/>
							<xsl:with-param name="VersionDate" select="$VersionDate"/>
						</xsl:call-template>
					</fo:block>
				</fo:static-content>

				<fo:static-content flow-name="xsl-region-before">
					<fo:block>
						<fo:block>
							<xsl:call-template name="CF1R_Header">
								<xsl:with-param name="draft" select="$draft"/>
							</xsl:call-template>
						</fo:block>
					</fo:block>
				</fo:static-content>

				<fo:static-content flow-name="xsl-region-end">
					<fo:block> </fo:block>
				</fo:static-content>

				<fo:static-content flow-name="xsl-region-start">
					<fo:block> </fo:block>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body">
					<!-- Debugging flags with DevMode -->
					<xsl:if test="$useDebug = 9">
						<fo:table xsl:use-attribute-sets="table">
							<fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
							<fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
							<fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
							<fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
							<fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
							<fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell><fo:block>Debug Flags</fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$test_cool-',$test_cool)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$hasAirflow-',$hasAirflow)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$test_fan-',$test_fan)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$doDuctsExist-',$doDuctsExist)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$isLessThanFortyFt-',$isLessThanFortyFt)"/></fo:block></fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$excludeDucts-',$excludeDucts)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$boxOnly-',$boxOnly)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$otherCool-',$otherCool)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$hasHERS-', $hasHERS)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$getYodaFlag-', $getYodaFlag)"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block><xsl:value-of select="concat('$showWaterMark-', $showWatermark)"/></fo:block></fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>		
					</xsl:if>
					<fo:block>
						<!--General-->
						<xsl:call-template name="General"/>
						<!--Single Orientation Results-->
						<xsl:call-template name="Single_Orientation_Results"/>
						<!-- Special Features    -->
						<xsl:apply-templates select="//SDDXML/Model[@Name='Proposed']/SpeclFtr"
							mode="SpecialFeaturesList"/>
						<!-- HERS Features    -->
						<xsl:apply-templates select="//SDDXML/Model[@Name='Proposed']"
							mode="HERSFeatureSummary"/>
						<!--<!-\-SpecialFeaturesList)-\->
						<xsl:call-template name="SpecialFeaturesList"/>
						<!-\-EAA_HERSFeatureSummary-\->
						<xsl:call-template name="HERSFeatureSummary"/>-->
						<!--CalGreenSummary
						<xsl:call-template name="CalGreenSummary"/>-->
						<!-- Multifamily Tables -->
						<xsl:choose>
							<xsl:when test="$isMF=1">
								<!--BuildingFeatures-MF-->
								<xsl:call-template name="BuildingFeatures-MF"/>
								<!--COM_Zone Features-MF-->
								<xsl:call-template name="Zone_Features-MF"/>
								<!--Dwelling Unit Table-->
								<xsl:call-template name="Dwelling_Unit_Table"/>
								<!--Dwelling Unit Types-->
								<xsl:call-template name="Dwelling_Unit_Types"/>
							</xsl:when>
							<xsl:otherwise>
								<!--BuildingFeatures-SF-->
								<xsl:call-template name="BuildingFeatures-SF"/>
								<!--Zone Features-SF-->
								<xsl:call-template name="Zone_Features-SF"/>
							</xsl:otherwise>
						</xsl:choose>
						<!--EAA_Opaque Surfaces-->
						<xsl:call-template name="EAA_Opaque_Surfaces"/>
						<!--EAA_Opaque-Cathedral Ceilings-->
						<xsl:if test="//Model[@Name='Proposed']/Proj/Zone/CathedralCeiling">
							<xsl:call-template name="EAA_Opaque-Cathedral_Ceilings"/>
						</xsl:if>
						<!--EAA_Attic-->
						<xsl:if test="//Model[@Name='Proposed']/Proj/Attic">
							<xsl:call-template name="EAA_Attic"/>
						</xsl:if>
						<!-- EAA_Windows -->
						<xsl:call-template name="EAA_Windows"/>
						<!--EAA_Doors-->
						<xsl:if
							test="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Door | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door | //Model[@Name='Proposed']/Proj/Garage/ExtWall/Door">
							<xsl:call-template name="EAA_Doors"/>
						</xsl:if>
						<!--Overhangs-Fins-->
						<xsl:if
							test="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[ShowFinsOverhang=1]">
							<xsl:call-template name="Overhangs-Fins"/>
						</xsl:if>
						<!-- Opaque Surface Constructions -->
						<xsl:call-template name="Opaque_Surface_Constructions"/>
						<!-- EAA_Slab Floor -->
						<xsl:if
							test="//Model[@Name='Proposed']/Proj/Zone/SlabFloor | //Model[@Name='Proposed']/Proj/Zone/UndFloor">
							<xsl:call-template name="EAA_Slab_Floor"/>
						</xsl:if>
						<!--Building Envelope HERS-->
						<xsl:call-template name="Building_Envelope_HERS"/>
						<!-- DHW Tables -->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/IsMultiFamily=1">
								<!--EAA_WaterHeatingSystems-MultiFamily-->
								<xsl:call-template name="EAA_WaterHeatingSystems-MultiFamily"/>
							</xsl:when>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/IsMultiFamily!=1 and count(//Model[@Name='Proposed']/DHWSys/DHWSysRpt)>0">
								<!--EAA_WaterHeatingSystems-SingleFamily-->
								<xsl:call-template name="EAA_WaterHeatingSystems-SingleFamily"/>
							</xsl:when>
						</xsl:choose>
					<!--	<!-\-EAA_WaterHeaters-\->
						<xsl:call-template name="EAA_WaterHeaters-SF-2016-V2"/>
						-->
						<!-- REVISED WATERHEATER TABLES -->
						<xsl:choose>
							<xsl:when test="$isMF=1">
<!--								<xsl:call-template name="WaterHeaters_MF"></xsl:call-template>-->
								<xsl:call-template name="Waterheaters_MF_UEF"></xsl:call-template>
							</xsl:when>
							<!--<xsl:otherwise>
								<xsl:call-template name="WaterHeaters_SF4"></xsl:call-template>
							</xsl:otherwise>-->
						</xsl:choose>
						<!-- Water Heater from NC Template -->
						<!--Water Heaters SF-->
						<xsl:choose>
							<xsl:when test="count(//Model[@Name='Proposed']/DHWSys/DHWSysRpt) > 0">
<!--								<xsl:call-template name="WaterHeaters_SF4"/>-->
								<xsl:call-template name="Waterheaters_SF_UEF"/>
<!--								<xsl:apply-templates select="//SDDXML/Model[@Name='Proposed']/DHWSys[NumDUsServed > 0]" mode="Waterheaters_SF"/>-->
							</xsl:when>
						</xsl:choose>
						
						
						<!-- DHW HERS ONLY WHEN $test_dhw = 1 -->
						<xsl:if test="$test_dhw >= 1">
							<xsl:choose>
								<xsl:when test="//Model[@Name='Proposed']/DHWSys/DHWSysRpt">
									<xsl:call-template name="DHWHERS"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						
						<!--EAA_HVAC Systems-->
						<!--<xsl:call-template name="EAA_HVAC_Systems"/>-->
						<xsl:call-template name="SC_Systems_SF"/>
						
						
						<!-- Revised HVAC Heat, Pump, Cool -->
						<!-- Heat Types SF-->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal!=2]">
								<xsl:call-template name="HVAC_Heat_SF3"/>
							</xsl:when>
						</xsl:choose>
						<!-- Heat Pump Systems SF-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]">
								<xsl:call-template name="HVAC_HP_SF2"/>
							</xsl:when>
						</xsl:choose>
						<!-- Cooling NOT HP SF-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/SCSysRpt[not(contains(CoolingType,'HeatPump'))]">
								<xsl:call-template name="HVAC_Cool_SF2"/>
							</xsl:when>
						</xsl:choose>
						<!-- HERS Cooling SF-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]">
								<xsl:call-template name="HERS_Cool_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- END REVISED -->
						<!--EAA_HERS Cooling-->
						<!--<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0 and Status !='Existing' and not(TypeAbbrev='NoCooling')]/CoolSystem]/HERSCheck] | //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0 and Status !='Existing']/HtPumpSystem]/HERSCheck]">
								<xsl:call-template name="EAA_HERS_Cooling"/>
							</xsl:when>
						</xsl:choose>-->
						<!--EAA_HVAC Distribution-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[FloorAreaServed &gt; 0 and not(DuctsCreatedForAnalysis=1)]">
								<xsl:call-template name="EAA_HVAC_Distribution"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_HERS HVAC Distrubution.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and Status='New' or (Status ='Existing + New' and IsLessThanFortyFt=0) or Status = 'Altered' and DuctsCreatedForAnalysis=0 ]/HERSCheck]">
								<xsl:call-template name="EAA_HERS_Dist_SF"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_HVAC Fans.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//SDDXML/Model[@Name='Proposed']/HVACFan[(Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/Fan) and TypeRpt=1 and Status != 'Existing']">
								<xsl:call-template name="EAA_HVAC_Fans"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Fan IAQ Vent.xfc)-->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/IAQVentRpt">
								<xsl:call-template name="EAA_Fan_IAQ_Vent"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Fan CoolVent.xfc)-->  <xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/ClVentFan[NumAssignments&gt;0]">
								<xsl:call-template name="CoolingVentilation"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Replaced Components.xfc)-->
						<xsl:choose>
							<xsl:when
								test="(//IsVerified=1 and //IsAltered=1) and //SDDXML/Model[@Name='Proposed']/Proj/RunScope!='Newly Constructed'">
								<fo:block keep-with-next.within-page="always">
									<fo:table xsl:use-attribute-sets="table" keep-with-previous.within-page="always">
										<fo:table-column column-width="proportional-column-width(100)" column-number="1"/>
										<fo:table-body>
											<fo:table-row>
												<fo:table-cell xsl:use-attribute-sets="titleRow">
													<fo:block>HERS RATER VERIFICATION OF EXISTING CONDITIONS </fo:block>
												</fo:table-cell>
											</fo:table-row>
										</fo:table-body>
									</fo:table>
									<!--<xsl:call-template name="EAA_Replaced_Components"/>-->
								</fo:block>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Opaque Surfaces-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/ExtWall[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/IntWall[IsVerified=1]/exConstruction | 
								//Model[@Name='Proposed']/Proj/Zone/CeilingBelowAttic[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/ExteriorFloor[IsVerified=1]/exConstruction | 
								//Model[@Name='Proposed']/Proj/Zone/FloorOverCrawl[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/InteriorFloor[IsVerified=1]/exConstruction | 
								//Model[@Name='Proposed']/Proj/Garage/ExtWall[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Garage/IntWall[IsVerified=1]/exConstruction | 
								//Model[@Name='Proposed']/Proj/Attic[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling[IsVerified=1]/exConstruction">
								<xsl:call-template name="EAA_Opaque_Surfaces-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Windows-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[Status='Altered' and IsVerified=1] | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling/Skylt[Status='Altered' and IsVerified=1]">
								<xsl:call-template name="EAA_Windows-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Doors-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//SDDXML/Model[@Name='Proposed']/Proj/Zone/ExtWall/Door[Status='Altered' and IsVerified=1] | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door[Status='Altered' and IsVerified=1]">
								<xsl:call-template name="EAA_Doors-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Slab Floor-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/SlabFloor[IsAltered=1 and IsVerified=1]">
								<xsl:call-template name="EAA_Slab_Floor-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_Building Envelope Leakage - Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj[Status='Altered' and IsVerified=1]">
								<xsl:call-template name="EAA_Building_Envelope_Leakage-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_HVAC Systems-Altered.xfc)-->   <xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACSys[Name=//Model[@Name='Proposed']/Proj/Zone[HVACSysStatus='Altered' and HVACSysVerified=1]/exHVACSystem]">
								<xsl:call-template name="EAA_HVAC_Systems-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_HVAC Distribution-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Status='Altered' and IsVerified=1]">
								<xsl:call-template name="EAA_HVAC_Distribution-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\EAA\EAA_WaterHeatingSystems-SingleFamily-Altered.xfc)-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys1Status='Altered' and DHWSys1Verified=1]/exDHWSys1] | //Model[@Name='Proposed']/DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys2Status='Altered' and DHWSys2Verified=1]/exDHWSys2]">
								<xsl:call-template
									name="EAA_WaterHeatingSystems-SingleFamily-Altered"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\Common\COM_Notes.xfc)-->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/Notes">
								<xsl:call-template name="COM_Notes"/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(.\Common\COM_CF1R Declarations.xfc)-->
						<fo:block break-before="page">
							<xsl:call-template name="CF1R_Declarations"/>
						</fo:block>
						<fo:block>
							<xsl:if test="string(/SDDXML/Model[@Name='Proposed']/Proj/SoftwareNote)">
								<xsl:value-of
									select="/SDDXML/Model[@Name='Proposed']/Proj/SoftwareNote"/>
							</xsl:if>
						</fo:block>  <fo:block id="last-page">
							<xsl:attribute name="id">last-page</xsl:attribute>
						</fo:block>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
	<!--CF1R FOOTER-->
	<xsl:template name="CF1R_Footer">
		<fo:table xsl:use-attribute-sets="table" margin-top="11pt">
			<fo:table-column column-width="proportional-column-width(38.59)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(37.749)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(23.66)" column-number="3"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell padding="2pt">
						<fo:block>Registration Number:</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block>Registration Date/Time:</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block>HERS Provider:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell padding="2pt">
						<fo:block>CA Building Energy Efficiency Standards - <xsl:value-of
								select="//Model[@Name='Proposed']/Proj/EnergyCodeYear"/> Residential
							Compliance</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block>Report Version - CF1R-<xsl:value-of
								select="concat($VersionDate,'-',$AtVersion)"/></fo:block>
					</fo:table-cell>
					<fo:table-cell text-align="left" display-align="before" padding="2pt">
						<fo:block>Report Generated at: <xsl:if
								test="string(//Payload/@processedDate)">
								<xsl:value-of select="//Payload/@processedDate"/>
							</xsl:if></fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--CF1R HEADER-->
	<xsl:template name="CF1R_Header">
		<fo:table xsl:use-attribute-sets="table" margin-top="16pt">
			<fo:table-column column-width="proportional-column-width(25)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(22.5)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(34.375)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(18.125)" column-number="4"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="3" padding="2pt">
						<fo:block font-size="9pt" font-weight="bold">CERTIFICATE OF COMPLIANCE -
							RESIDENTIAL PERFORMANCE COMPLIANCE METHOD</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block text-align="right" font-size="9pt" font-weight="bold"
							>CF1R-PRF-01</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" padding="2pt">
						<fo:block font-size="9pt" font-weight="bold">Project Name: <xsl:if
								test="string(//Model[@Name='Proposed']/Proj/Name)">
								<fo:inline font-weight="normal">
									<xsl:value-of select="//Model[@Name='Proposed']/Proj/Name"/>
								</fo:inline>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block font-size="9pt" font-weight="bold">Calculation Date/Time: <xsl:if
								test="string(//Model[@Name='Proposed']/Proj/RunDateFmt)">
								<fo:inline font-weight="normal">
									<xsl:value-of select="//Model[@Name='Proposed']/Proj/RunDateFmt"
									/>
								</fo:inline>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt">
						<fo:block text-align="right" font-size="9pt" font-weight="bold"
								>Page <fo:page-number format="1"/> of <fo:page-number-citation
								format="1" ref-id="last-page"/></fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" padding="2pt">
						<fo:block font-size="9pt" font-weight="bold">Calculation Description:
								<xsl:if test="string(//Model[@Name='Proposed']/Proj/RunTitle)">
								<fo:inline font-weight="normal">
									<xsl:value-of select="//Model[@Name='Proposed']/Proj/RunTitle"/>
								</fo:inline>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" padding="2pt">
						<fo:block font-size="9pt" font-weight="bold">Input File Name: <xsl:if
								test="string(//Model[@Name='Proposed']/Proj/ProjFileName)">
								<fo:inline font-weight="normal">
									<xsl:value-of
										select="//Model[@Name='Proposed']/Proj/ProjFileName"/>
								</fo:inline>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
		<fo:block>
			<xsl:choose>
				<xsl:when test="$draft='NotRegistered'">
					<fo:block>
						<fo:block-container z-index="-1" position="absolute" left="5pt" top="5pt"
							width="100%" height="100%">
							<fo:block>
								<fo:instream-foreign-object>
									<svg xmlns="http://www.w3.org/2000/svg" width="680" height="920">
										<text font-family="Arial Black" font-size="20pt"
											style="fill:rgb(192,192,192)" x="-10" y="300"
											width="680" text-anchor="middle"
											transform="rotate(-54, 340, 15)"> This Certificate of
											Compliance is not registered </text>
									</svg>
								</fo:instream-foreign-object>
							</fo:block>
						</fo:block-container>
					</fo:block>
				</xsl:when>
				<xsl:when test="$draft='NotCertified'">
					<fo:block>
						<fo:block-container z-index="-1" position="absolute" left="5pt" top="5pt"
							width="100%" height="100%">
							<fo:block>
								<fo:instream-foreign-object>
									<svg xmlns="http://www.w3.org/2000/svg" width="680" height="920">
										<text font-family="Arial Black" font-size="30pt"
											style="fill:rgb(192,192,192)" x="-10" y="300"
											width="680" text-anchor="middle"
											transform="rotate(-54, 340, 15)"> Not useable for
											compliance </text>
									</svg>
								</fo:instream-foreign-object>
							</fo:block>
						</fo:block-container>
					</fo:block>
				</xsl:when>
				<xsl:when test="$draft='NotAuthorized'">
					<fo:block>
						<fo:block-container z-index="-1" position="absolute" left="5pt" top="5pt"
							width="100%" height="100%">
							<fo:block>
								<fo:instream-foreign-object>
									<svg xmlns="http://www.w3.org/2000/svg" width="680" height="920">
										<text font-family="Arial Black" font-size="30pt"
											style="fill:rgb(192,192,192)" x="-10" y="300"
											width="680" text-anchor="middle"
											transform="rotate(-54, 340, 15)"> Not Authorized for
											Compliance </text>
									</svg>
								</fo:instream-foreign-object>
							</fo:block>
						</fo:block-container>
					</fo:block>
				</xsl:when>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<!--General Section-->
	<!--General Section-->
	<xsl:template name="General">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(4.375)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(22.952)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(22.674)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(4.271)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(23.541)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(22.187)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>GENERAL INFORMATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Project Name </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/Name"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Calculation Description </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/Description"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Project Location</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/Address"/>
							 </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>City</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/City"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Standards Version</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/StandardsVersion"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Zip Code</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/ZipCode"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Compliance Manager Version </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/CompMgrVersion"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Climate Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of
								select="substring(//Model[@Name='Proposed']/Proj/ClimateZone,1,4)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Software Version </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Standard']/Proj/SoftwareVersion"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Building Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="v727"
								select="substring('YN',              2 - boolean(//SDDXML/Model[@Name='Proposed']/Proj/BuildingTypeRpt),              1)"/>
							<!-- Method from #727 beyond -->
							<xsl:if test="$v727='Y'">
								<xsl:variable name="bldg_type"
									select="//SDDXML/Model[@Name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:choose>
									<xsl:when test="$bldg_type &lt; 0.5">Single Family</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//SDDXML/Model[@Name='Proposed']/Proj/BuildingTypeRpt"
										/>
									</xsl:otherwise>
								</xsl:choose>
								<!-- Old method -->
							</xsl:if>
							<xsl:if test="$v727='N'">
								<xsl:variable name="bldg_type"
									select="//SDDXML/Model[@Name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:choose>
									<xsl:when test="$bldg_type = '1'">Multifamily</xsl:when>
									<xsl:otherwise>Single Family</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>11</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Front Orientation (deg/Cardinal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="front_orientation"
								select="//Model[@Name='User Input']/Proj/AllOrientations"/>
							<xsl:choose>
								<xsl:when test="$front_orientation = 1">Cardinal</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="//Model[@Name='Proposed']/Proj/FrontOrientation"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>12</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Project Scope</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="runscope"
								select="//Model[@Name='Proposed']/Proj/RunScope"/>
							<xsl:variable name="isadd"
								select="//Model[@Name='Proposed']/Proj/IsAddAlone"/>
							<xsl:choose>
								<xsl:when test="$runscope='Newly Constructed' and $isadd=1">
									<xsl:value-of
										select="concat(//Model[@Name='Proposed']/Proj/RunScope,' (Addition Alone)')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="//Model[@Name='Proposed']/Proj/RunScope"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>13</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Number of Dwelling Units </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/NumDwellingUnits"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>14</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Total Cond. Floor Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of
								select="sum(//SDDXML/Model[@Name='Proposed']/Proj/Zone/FloorArea)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>15</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Number of Zones </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="count(//SDDXML/Model[@Name='Proposed']/Proj/Zone)"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>16</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Slab Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of
								select="sum(//SDDXML/Model[@Name='Proposed']/Proj/Zone/SlabFloorArea)"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>17</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Number of Stories </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of select="//Model[@Name='Proposed']/Proj/NumStories"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>18</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Addition Cond. Floor Area (ft<fo:inline baseline-shift="super"
							font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="runscope"
								select="//Model[@Name='Proposed']/Proj/RunScope"/>
							<xsl:variable name="isadd"
								select="//Model[@Name='Proposed']/Proj/IsAddAlone"/>
							<xsl:choose>
								<xsl:when test="$runscope='Newly Constructed' and $isadd=1">
									<xsl:value-of
										select="sum(//Model[@Name='Proposed']/Proj/Zone[Status='New']/AdditionCFA)"
									/>
								</xsl:when>
								<xsl:when test="$runscope!='Newly Constructed' and $isadd=0">
									<xsl:value-of
										select="sum(//Model[@Name='Proposed']/Proj/Zone[Status='New']/AdditionCFA)"
									/>
								</xsl:when>
								<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>19</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Natural Gas Available </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="nat_gas"
								select="(//SDDXML/Model[@Name='Proposed']/Proj/NatGasAvailable/text())"/>
							<xsl:choose>
								<xsl:when test="$nat_gas = '1'">Yes</xsl:when>
								<xsl:otherwise>No</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>20</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Addition Slab Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="runscope"
								select="//Model[@Name='Proposed']/Proj/RunScope"/>
							<xsl:variable name="isadd"
								select="//Model[@Name='Proposed']/Proj/IsAddAlone"/>
							<xsl:choose>
								<xsl:when test="$runscope='Newly Constructed' and $isadd=1">
									<xsl:value-of
										select="sum(//Model[@Name='Proposed']/Proj/Zone[Status='New']/SlabFloorArea)"
									/>
								</xsl:when>
								<xsl:when test="$runscope!='Newly Constructed' and $isadd=0">
									<xsl:value-of
										select="sum(//Model[@Name='Proposed']/Proj/Zone[Status='New']/SlabFloorArea)"
									/>
								</xsl:when>
								<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>21</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellB right">
						<fo:block>Glazing Percentage (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:value-of
								select="format-number(sum(//SDDXML/Model[@Name='Proposed']/Proj/Zone/RptTotCondZoneWinArea) div sum(//SDDXML/Model[@Name='Proposed']/Proj/Zone/FloorArea),'0.0%')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Single Orientation Results-->
	<xsl:template name="Single_Orientation_Results">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(7.442)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.693)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(13.269)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.388)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.018)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(13.424)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>COMPLIANCE RESULTS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" border="1pt solid black"
						display-align="center" font-weight="bold" padding="2pt">
						<fo:block>
							<xsl:variable name="compliance_result"
								select="(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/PassFail/text())"/>
							<xsl:choose>
								<xsl:when test="$compliance_result = 'PASS'">Building Complies with
									Computer Performance</xsl:when>
								<xsl:otherwise>Building Does Not Comply</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" border="1pt solid black"
						display-align="center" font-weight="bold" padding="2pt">
						<fo:block>
							<xsl:variable name="showHERS"
								select="//Model[@Name='Proposed']/Proj/ShowNotRegWatermark"/>
							<xsl:choose>
								<xsl:when test="$showHERS=1">This building incorporates features
									that require field testing and/or verification by a certified
									HERS rater under the supervision of a CEC-approved HERS
									provider. </xsl:when>
								<xsl:otherwise>This building DOES NOT require HERS
									Verification</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:variable name="spcFeature1"
								select="sum(//Model[@Name='Proposed']/SpeclFtr/*[.=1])"/>
							<xsl:choose>
								<xsl:when test="$spcFeature1&gt;=1">03</xsl:when>
								<xsl:otherwise> </xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" border="1pt solid black"
						display-align="center" font-weight="bold" padding="2pt">
						<fo:block>
							<xsl:variable name="spcFeature1"
								select="sum(//Model[@Name='Proposed']/SpeclFtr/*[.=1])"/>
							<xsl:choose>
								<xsl:when test="$spcFeature1&gt;=1">This building incorporates one
									or more Special Features shown below</xsl:when>
								<xsl:otherwise> </xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6">
						<fo:block text-align="center">
							<xsl:if
								test="//Model[@Name='Proposed']/Proj/StandardsVersion='Compliance 2014'"
								>This compliance analysis is valid only for permit applications
								through December 31, 2014</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row border-left-width="0pt" border-right-width="0pt" height="0.224in">
					<fo:table-cell number-columns-spanned="6">
						<fo:block font-size="0pt">.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block text-align="center"> ENERGY USE SUMMARY</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCell">
						<fo:block>Energy Use (kTDV/ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>-yr)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Standard Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Proposed Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Compliance Margin</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Percent Improvement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block> Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Photovoltaic Offset</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>----</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse13[@index=3]">
									<xsl:value-of
										select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse13[@index=7]">
									<xsl:value-of
										select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Compliance Energy Total</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:comment>
					&lt;fo:table-row height="0.181in" overflow="hidden"&gt;
						&lt;fo:table-cell class="cell Vcenter Hcenter Bold" number-columns-spanned="2"&gt;
							&lt;fo:block&gt;Total Energy (*including AMEU)&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
						&lt;fo:table-cell class="cell Hcenter  Bold"&gt;
							&lt;fo:block&gt;&lt;fo:inline&gt;
									&lt;xfd:field xpath="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]"/&gt;
								&lt;/fo:inline&gt;&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
						&lt;fo:table-cell class="cell Hcenter  Bold"&gt;
							&lt;fo:block&gt;&lt;fo:inline&gt;
									&lt;xfd:field xpath="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3]"/&gt;
								&lt;/fo:inline&gt;&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
						&lt;fo:table-cell class="cell Hcenter  Bold"&gt;
							&lt;fo:block&gt;&lt;fo:inline&gt;
									&lt;xfd:field xpath="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=7]"/&gt;
								&lt;/fo:inline&gt;&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
						&lt;fo:table-cell class="cell Hcenter  Bold"&gt;
							&lt;fo:block&gt;
								&lt;xfd:inline-xslt&gt;
									&lt;xfd:xslt&gt;
										&lt;xsl:choose&gt;
											&lt;xsl:when test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]=0"&gt;
0.0%
&lt;/xsl:when&gt;
											&lt;xsl:otherwise&gt;
												&lt;xsl:value-of select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]),'0.0%')"/&gt;
											&lt;/xsl:otherwise&gt;
										&lt;/xsl:choose&gt;
									&lt;/xfd:xslt&gt;
								&lt;/xfd:inline-xslt&gt;
							&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
					&lt;/fo:table-row&gt;
					&lt;fo:table-row height="0.097in" overflow="hidden"&gt;
						&lt;fo:table-cell class="cellNB Vcenter Hleft" number-columns-spanned="6"&gt;
							&lt;fo:block&gt;* calculated Appliances and Miscellaneous Energy Use&lt;/fo:block&gt;
						&lt;/fo:table-cell&gt;
					&lt;/fo:table-row&gt;
				</xsl:comment>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!-- Template for writing Special and HERS Feature Messages -->
	<xsl:template name="featureMessage">
		<xsl:param name="message"/>
		<fo:block>
			<fo:list-block provisional-distance-between-starts="0.3cm"
				provisional-label-separation="0.15cm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>•</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:value-of select="concat($message,'&#10;')"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>

	<!-- Special Feature Listing -->
	<xsl:template match="SpeclFtr" mode="SpecialFeaturesList">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>REQUIRED SPECIAL FEATURES</fo:block>
						
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" padding="2pt">
						<fo:block>The following are features that must be installed as condition for
							meeting the modeled energy performance for this computer
							analysis. </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" padding="2pt">
						<fo:block>
							<fo:block font-weight="bold">
								<xsl:variable name="has_feature" select="count(*[.>=1])"/>
								<xsl:if test="$useDebug = 9">
							<fo:block>
								<xsl:value-of select="concat('$has_feature: ',$has_feature)"/>
							</fo:block>
						</xsl:if>
								<xsl:choose>
									<xsl:when test="$has_feature&gt;=1">
										<xsl:if test="ZonalControl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="ZonalControlMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="PVSysCredit=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="PVSysCreditMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="BatterySystem=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
													select="BatterySystemMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="CoolVent=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="CoolVentRptMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="VarCFIClVent=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="VarCFIClVentRptMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="FixCFIClVent=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="FixCFIClVentRptMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DuctInsul=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="DuctInsulMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="RHTruss=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="RHTrussMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="CoolRoof&gt;0">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="CoolRoofMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="NonStdCeilBelowAttic=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="NonStdCeilBelowAtticMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="NonStdFloor=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="NonStdFloorMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="AboveDeckRoofIns=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="AboveDeckRoofInsMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="BelowDeckRoofIns=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="BelowDeckRoofInsMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="ExtShade=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="ExtShadeMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="WinOVerHngFin=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="WinOVerHngFinMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="ExposedSlab=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="ExposedSlabMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="NoCooling=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="NoCoolingMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="AddedShortDuct=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="AddedShortDuctMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="AWFWalls=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="AWFWallsMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="MetalFramedWalls=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="MetalFramedWallsMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="SIPAssembly=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="SIPAssemblyMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DuctsInCrawlSpc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DuctsInCrawlSpcMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="NonStdDuctLoc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="NonStdDuctLocMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="SFamSolarWH=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="SFamSolarWHMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="MFamSolarWH=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="MFamSolarWHMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="SlabEdgeInsul=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="SlabEdgeInsulMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="HeatedSlab=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="HeatedSlabMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWMFRecircDemCtrl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWMFRecircDemCtrlMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWMFRecircNDemCtrl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWMFRecircNDemCtrlMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWMFRecircTempMod=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWMFRecircTempModMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWMFNLpNRecirc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWMFNLpNRecircMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWMFRecircTempModMon=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWMFRecircTempModMonMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWParaPipeCntrl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWParaPipeCntrlMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWPipeInsul=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWPipeInsulMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWPointOfUse=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWPointOfUseMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWRecircDemOcc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWRecircDemOccMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWRecircDemPBtn=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWRecircDemPBtnMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="DHWRecircNDemCtrl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="DHWRecircNDemCtrlMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="NEEAHtPumpWtrHtr=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
													select="NEEAHtPumpWtrHtrMsg"/>
											</xsl:call-template>
										</xsl:if>	
									</xsl:when>
									<xsl:otherwise>NO SPECIAL FEATURES REQUIRED</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!-- HERS FEATURE TEMPLATES -->
	<xsl:variable name="isNone">-- None --</xsl:variable>
	<!-- HERS Other -->
	<xsl:template match="HERSOther" mode="OtherItems">
		<xsl:variable name="has_feature" select="sum(*[.=1])"/>
		<fo:block>Building-level Verifications:</fo:block>
		<xsl:choose>
			<xsl:when test="$has_feature&gt;=1">
				<xsl:if test="QII=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="QIIRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="LowBldgLkg=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="LowBldgLkgRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="IAQFan=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="IAQFanRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="CentralIAQ=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="CIAQRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<!--This may be removed on confirmation that this is not a HERS-Inspected measure
													<xsl:if test="ZonalCoolSys=1">
														<xsl:call-template name="featureMessage">
															<xsl:with-param name="message"
																select="ZonalRptMsg"/>
														</xsl:call-template>
													</xsl:if>-->

				<xsl:if test="SprayFoamHighR=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="SprayFoamRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="VerifyExistCond=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="ExCondRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="ZonalSysBypassDuct=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="ZonalSysBypassDuctRptMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="VerifyClVent=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message" select="VerifyClVentRptMsg"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="featureMessage">
					<xsl:with-param name="message">--None--</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- HERS Cooling -->
	<xsl:template match="HERSCool" mode="CoolingItems"> </xsl:template>

	<!--HERS Feature Summary-->
	<xsl:template match="*" mode="HERSFeatureSummary">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>HERS FEATURE SUMMARY</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" padding="2pt">
						<fo:block>The following is a summary of the features that must be
							field-verified <fo:inline> by a certified HERS Rater</fo:inline> as
							a condition for meeting the modeled energy performance for this computer
							analysis.  Additional detail is provided in the building components
							tables below.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0.181in" overflow="hidden" font-weight="bold">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" padding="2pt">

						<xsl:apply-templates select="HERSOther" mode="OtherItems"/>
						<!-- Fan is not included with Cooling measures -->
						<!--<xsl:variable name="test_fan"
							select="HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef and not($noCooling=1)]/HERSCheck]/AHUFanEff
								or HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef and not($noCooling=1)]/HERSCheck]/AHUFanEff"/>-->
						<fo:block> </fo:block>
						<fo:block> Cooling System Verifications: </fo:block>
						<xsl:choose>
							<!-- MultiFamily -->
							<xsl:when test="$isMF=1">
								<!-- The rest of the cooling measures -->
								<xsl:variable name="test_cool">
									<xsl:choose>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem and not($noCooling=1)]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem and not($noCooling=1)]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem and not($noCooling=1)]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem and not($noCooling=1)]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
									<!--	<xsl:when test="HVACSys[Status='Existing' and sum(FloorAreaServed) > 0]">1</xsl:when>-->
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$test_cool &gt;=1 or $test_fan &gt;=1">
										<xsl:if
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow = 1 or 
													HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow = 1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Minimum
												Airflow</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/EER=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/EER=1 ">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Verified
												EER</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/SEER=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/SEER=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Verified
												SEER</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]/ACCharg=1 or 
											HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/ACCharg=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Verified Refrigerant Charge</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<!--<xsl:if
											test="HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1 or 
											HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/ACCharg=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACChargRptMsg |
													HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/AltACChargRptMsg
													"/>
											</xsl:call-template>
										</xsl:if>-->
										<xsl:if test="$test_fan=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Fan Efficacy
												Watts/CFM</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="(HVACSys[Status='Existing' and sum(FloorAreaServed) > 0]) and (HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/ACCharg=1)">
												<xsl:call-template name="featureMessage">
													<xsl:with-param name="message" select="HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACChargRptMsg |
														HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/AltACChargRptMsg
														"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="featureMessage">
											<xsl:with-param name="message">-- None
												--</xsl:with-param>
										</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										
									</xsl:otherwise>
								</xsl:choose>
								<!--  HERS DISTRIBUTION -->
								<xsl:variable name="low_leak"
									select="HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/LowLkgAH"/>
								<xsl:variable name="test_dist">
									<xsl:choose>
										<xsl:when
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<fo:block> </fo:block>
								<fo:block>HVAC Distribution System Verifications:</fo:block>
								<xsl:choose>
									<xsl:when test="$test_dist>=1 or $low_leak=1">
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLeakage=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct Sealing</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed > 0]/HERSCheck]/AltDuctLeakage=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed > 0]/HERSCheck]/AltDuctLkgRptMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SZone/DwellUnit/CSysRpt/HVACDistRef]/HERSCheck]/DuctLocation=1">
											<xsl:variable name="dLoc"
												select="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocRptMsg"/>
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="$dLoc"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/RetDuctDesign=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct
												Design-Return</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/SupDuctDesign=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct
												Design-Supply</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-siblingProj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/BuriedDucts=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct design specifies
												Buried Ducts</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/DeeplyBuriedDucts=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct design specifies
												Deeply Buried Ducts</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$low_leak=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Low-leakage Air
												Handling Unit</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="featureMessage">
											<xsl:with-param name="message">-- None
												--</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
								<!-- Water Heating -->
								<xsl:variable name="test_dhw"
									select="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1]"/>
								<fo:block> </fo:block>
								<fo:block>Domestic Hot Water System Verifications:<fo:block> <xsl:value-of select="concat('$test_dhw: ',$test_dhw)"/> </fo:block></fo:block>

								<xsl:choose>
									<xsl:when test="$test_dhw >=1">
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/AllPipesIns=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Pipe Insulation, All
												Lines</xsl:with-param>
											</xsl:call-template>
											<!--<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="PipeInsRptMsg"/>
												</xsl:call-template>-->
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/ParallelPipe=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Parallel
												Piping</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFCtrlRecircDualLp=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Central water heating
												recirculating dual loop design</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/PushBtnRecirc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Recirculation, Demand
												Control Push Button</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/OccRecirc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Recirculation, Demand
												Control Occupancy/Motion</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/PointOfUse=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Point of
												Use</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/Compact=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Compact
												Design</xsl:with-param>
											</xsl:call-template>"> </xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFNoControl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family Central
												Distribution: No control</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFDemandControl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Demand control</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFTempMod=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Temperture
												modulation</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFTempModMon=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Temperature modulation and
												monitoring</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="featureMessage">
											<xsl:with-param name="message">-- None
												--</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- SingleFamily -->
							<xsl:otherwise>
								<!-- The rest of the cooling measures -->
								<xsl:variable name="test_cool">
									<xsl:choose>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1] or //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem and not($noCooling=1)]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem and not($noCooling=1)]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem and not($noCooling=1)]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem and not($noCooling=1)]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:when test="HVACSys[Status='Existing' and sum(FloorAreaServed) > 0]">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable><fo:block> </fo:block> Cooling System Verifications: <fo:block>
									<xsl:choose>
										<xsl:when test="$test_cool &gt;=1 or $test_fan &gt;=1">
											<xsl:if
												test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow = 1 or 
													HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow = 1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Minimum
												Airflow</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/EER=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/EER=1 ">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Verified
												EER</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/SEER=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/SEER=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Verified
												SEER</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/ACCharg=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/ACCharg=1">
												<xsl:call-template name="featureMessage">
													<xsl:with-param name="message">Verified Refrigerant Charge</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1 or 
												HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1">
												<xsl:call-template name="featureMessage">
													<xsl:with-param name="message" select="HERSCool/AltACChargRptMsg"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$test_fan=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Fan Efficacy
												Watts/CFM</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">-- None
												--</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
								<!--  HERS DISTRIBUTION -->
								<xsl:variable name="low_leak"
									select="HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/LowLkgAH"/>
								<xsl:variable name="test_dist">
									<xsl:choose>
										<xsl:when
											test="HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed &gt; 0]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed &gt; 0]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<fo:block> </fo:block>
								<fo:block> HVAC Distribution System Verifications:</fo:block>
								<fo:block>
									<xsl:choose>
										<xsl:when test="$test_dist &gt;=1 or $low_leak=1">
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLeakage=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" >Duct Sealing</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed &gt; 0]/HERSCheck]/AltDuctLeakage=1">
												<xsl:call-template name="featureMessage">
													<xsl:with-param name="message" select="HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed &gt; 0]/HERSCheck]/AltDuctLkgRptMsg"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocation=1">
												<xsl:variable name="dLoc"
												select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocRptMsg"/>
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message" select="$dLoc"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/RetDuctDesign=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct
												Design-Return</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/SupDuctDesign=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct
												Design-Supply</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-siblingProj/SCSysRpt/HVACDistRef]/HERSCheck]/BuriedDucts=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct design
												specifies Buried Ducts</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DeeplyBuriedDucts=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct design
												specifies Deeply Buried Ducts</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$low_leak=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Low-leakage Air
												Handling Unit</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">-- None
												--</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
								<!-- Water Heating -->
								<xsl:variable name="test_dhw"
									select="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/*[.=1]"/>
								<fo:block> </fo:block>
								<fo:block> Domestic Hot Water System Verifications:</fo:block> 
								<xsl:if test="$useDebug = 9">
									<fo:block>
										<xsl:value-of select="concat('$test_dhw: ',$test_dhw)"/> 
									</fo:block>
								</xsl:if>
									
								<xsl:choose>
									<xsl:when test="$test_dhw >=1">
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/AllPipesIns=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Pipe Insulation, All
												Lines</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/ParallelPipe=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Parallel
												Piping</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/MFCtrlRecircDualLp=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Central water heating
												recirculating dual loop design</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/PushBtnRecirc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Recirculation, Demand
												Control Push Button</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/OccRecirc=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Recirculation, Demand
												Control Occupancy/Motion</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/PointOfUse=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Point of
												Use</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/Compact=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Compact
												Design</xsl:with-param>
											</xsl:call-template>"> </xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=HWSysRpt/DHWSysRef]/HERSCheck]/MFNoControl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family Central
												Distribution: No control</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/MFDemandControl=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Demand control</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/MFTempMod=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Temperture
												modulation</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=DHWSysRpt/DHWSysRef]/HERSCheck]/MFTempModMon=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Multi-Family
												Recirculation with Temperature modulation and
												monitoring</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="featureMessage">
											<xsl:with-param name="message">-- None
												--</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--SpecialFeaturesList-->
	<xsl:template name="SpecialFeaturesList">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cell">
						<fo:block>REQUIRED SPECIAL FEATURES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" padding="2pt">
						<fo:block>The following are features that must be installed as condition for
							meeting the modeled energy performance for this computer
							analysis. </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" padding="2pt">
						<fo:block font-weight="bold">
							<xsl:variable name="has_feature"
								select="sum(//Model[@Name='Proposed']/SpeclFtr/*[.=1])"/>
							<xsl:variable name="reducedVentArea"
								select="//Model[@Name='Proposed']/Proj/UnitClVentLowArea"/>
							<xsl:choose>
								<xsl:when test="$has_feature&gt;=1">
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/ZonalControl=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/ZonalControlMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Standard']/SpeclFtr/PVSysCredit=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Standard']/SpeclFtr/PVSysCreditMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/DuctInsul=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DuctInsulMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/RHTruss=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/RHTrussMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/CoolRoof&gt;0">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/CoolRoofMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/NonStdCeilBelowAttic=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/NonStdCeilBelowAtticMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/NonStdFloor=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/NonStdFloorMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/AboveDeckRoofIns=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/AboveDeckRoofInsMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/BelowDeckRoofIns=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/BelowDeckRoofInsMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/ExtShade=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/ExtShadeMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/WinOVerHngFin=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/WinOVerHngFinMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/ExposedSlab=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/ExposedSlabMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/NoCooling=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/NoCoolingMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/AddedShortDuct=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/AddedShortDuctMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/AWFWalls=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/AWFWallsMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/MetalFramedWalls=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/MetalFramedWallsMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/SIPAssembly=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/SIPAssemblyMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DuctsInCrawlSpc=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DuctsInCrawlSpcMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/NonStdDuctLoc=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/NonStdDuctLocMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/SFamSolarWH=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/SFamSolarWHMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/SlabEdgeInsul=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/SlabEdgeInsulMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/HeatedSlab=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/HeatedSlabMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/DHWPipeInsul=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWPipeInsulMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DHWParaPipeCntrl=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWParaPipeCntrlMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DHWParaPipeNCntrl=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWParaPipeNCntrlMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DHWRecircNDemCtrl=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWRecircNDemCtrlMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DHWRecircDemPBtn=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWRecircDemPBtnMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if
										test="//Model[@Name='Proposed']/SpeclFtr/DHWRecircDemOcc=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/DHWRecircDemOccMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/CoolVent=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/CoolVentRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/VarCFIClVent=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/VarCFIClVentRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="//Model[@Name='Proposed']/SpeclFtr/FixCFIClVent=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/SpeclFtr/FixCFIClVentRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="$reducedVentArea=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/Proj/ClVentAtticRelMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$reducedVentArea=1">
										<fo:list-block provisional-distance-between-starts="0.3cm"
											provisional-label-separation="0.15cm">
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/Proj/ClVentAtticRelMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</xsl:if>
									<xsl:if test="$reducedVentArea=0"> NO SPECIAL FEATURES REQUIRED
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERSFeatureSummary- DEPRECATED-->
	<xsl:template name="HERSFeatureSummary">
		<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<fo:table border-collapse="collapse" font-family="Arial Narrow" font-size="8pt"
				keep-together.within-column="always" margin-top="0in" table-layout="fixed"
				width="100%">
				<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
				<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
				<fo:table-body>
					<fo:table-row height="0.224in" overflow="hidden">
						<fo:table-cell number-columns-spanned="2" border="1pt solid black"
							display-align="center" font-weight="bold" line-height="115%"
							padding="2pt" text-align="left">
							<fo:block>HERS FEATURE SUMMARY</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell number-columns-spanned="2" border="1pt solid black"
							display-align="center" padding="2pt">
							<fo:block>The following is a summary of the features that must be
								field-verified <fo:inline> by a certified HERS Rater</fo:inline> as
								a condition for meeting the modeled energy performance for this
								computer analysis.  Additional detail is provided in the building
								components tables below.</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row font-weight="bold" overflow="hidden">
						<fo:table-cell number-columns-spanned="2" border="1pt solid black"
							display-align="center" padding="2pt">
							<fo:block>
								<fo:block><xsl:variable name="has_feature"
										select="sum(//Model[@Name='Proposed']/HERSOther/*[.=1])"/><fo:block>
										<fo:block>Building-level Verifications:</fo:block>
										<!--  HERS Other-->
										<xsl:choose>
											<xsl:when test="$has_feature&gt;=1">
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/QII=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('High Quality Insulation Installation (QII)','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/LowBldgLkg=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Building Envelope Air Leakage','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/IAQFan=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/HERSOther/IAQFanRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/CentralIAQ=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/HERSOther/CIAQRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<!--  This may be removed on confirmation that this is not a HERS-Inspected measure
													<xsl:if test="//Model[@Name='Proposed']/HERSOther/ZonalCoolSys=1">
														<fo:block>
															<fo:list-block provisional-distance-between-starts="0.3cm" provisional-label-separation="0.15cm">
																<fo:list-item>
																	<fo:list-item-label end-indent="label-end()">
																		<fo:block>&#8226;</fo:block>
																	</fo:list-item-label>
																	<fo:list-item-body start-indent="body-start()">
																		<fo:block>
																			<xsl:value-of select="concat('  ' ,//Model[@Name='Proposed']/HERSOther/ZonalRptMsg,'&#10;')"/>
																		</fo:block>
																	</fo:list-item-body>
																</fo:list-item>
															</fo:list-block>
														</fo:block>
													</xsl:if>
													-->
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/SprayFoamHighR=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/HERSOther/SprayFoamRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSOther/VerifyExistCond=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,//Model[@Name='Proposed']/HERSOther/ExCondRptMsg,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>-- None --</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</fo:block><!-- Cooling Measures: first get the no cooling special feature flag--><xsl:variable
										name="nocool"
										select="//Model[@Name='Proposed']/SpeclFtr/NoCooling"
										/><!-- Fan is not included with Cooling measures --><xsl:variable
										name="test_fan"
										select="//Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef and not($nocool=1)]/HERSCheck]/AHUFanEff"
										/><!-- The rest of the cooling measures --><xsl:variable
										name="test_cool">
										<xsl:choose>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem and not($nocool=1)]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem and not($nocool=1)]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem and not($nocool=1)]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem and not($nocool=1)]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable><fo:block> </fo:block> Cooling System
									Verifications: <fo:block>
										<xsl:choose>
											<xsl:when test="$test_cool &gt;=1 or $test_fan &gt;=1">
												<xsl:if
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/AHUAirFlow = 1 or //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AHUAirFlow = 1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ','Minimum  Airflow' ,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/EER=1 or //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/EER=1 ">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ','Verified EER','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/SEER=1 or //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/SEER=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ','Verified SEER' ,'&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/ACCharg=1 or //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/ACCharg=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ','Refrigerant Charge' ,'&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if test="$test_fan=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('  ','Fan Efficacy Watts/CFM','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>-- None --</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</fo:block>
									<!--  HERS DISTRIBUTION -->
									<xsl:variable name="low_leak"
										select="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/LowLkgAH"/>
									<xsl:variable name="test_dist">
										<xsl:choose>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<!--
<xsl:when test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1]">
<xsl:value-of select="sum(//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1])"/>
</xsl:when>
-->
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<fo:block> </fo:block> HVAC Distribution System Verifications: <fo:block>
										<xsl:choose>
											<xsl:when test="$test_dist &gt;=1 or $low_leak=1">
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or ((Status = 'Altered' or Status='Existing' or Status='New') and DuctsCreatedForAnalysis=0) ]/HERSCheck]/DuctLeakage=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Duct Sealing','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocation=1">
												<xsl:variable name="dLoc"
												select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocRptMsg"/>
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of select="$dLoc"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/RetDuctDesign=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Duct Design-Return','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/SupDuctDesign=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Duct Design-Supply','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/BuriedDucts=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>Duct design specifies Buried
												Ducts</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and (Status ='Existing + New' and (IsLessThanFortyFt=0 or not(IsLessThanFortyFt))) or Status = 'Altered' or Status='Existing' or Status='New' and DuctsCreatedForAnalysis=0 ]/HERSCheck]/DeeplyBuriedDucts=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>Duct design specifies Deeply Buried
												Ducts</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if test="$low_leak=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>Low-leakage Air Handling Unit</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>-- None --</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</fo:block>
									<!-- Water Heating -->
									<xsl:variable name="test_dhw">
										<xsl:choose>
											<xsl:when
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<!-- For SF we only need to test DHWSys1 -->
											<xsl:when
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1]">
												<xsl:value-of
												select="sum(//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1])"
												/>
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<fo:block> </fo:block> Domestic Hot Water System Verifications: <fo:block>
										<xsl:choose>
											<xsl:when test="$test_dhw&gt;=1">
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/AllPipesIns=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/AllPipesIns=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Pipe Insulation, All Lines','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/ParallelPipe=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/ParallelPipe=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Parallel Piping','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/BelowGrade=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/BelowGrade=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Below Grade Pipe','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/PushBtnRecirc=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/PushBtnRecirc=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Recirculation, Demand Control Push Button','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/OccRecirc=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/OccRecirc=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Recirculation, Demand Control Occupancy/Motion','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/PointOfUse=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/PointOfUse=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Point of Use','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/Compact=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/Compact=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Compact Design','&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFNoControl=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/MFNoControl=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Multi-Family Central Distribution: No control','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFDemandControl=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/MFDemandControl=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Multi-Family Recirculation with Demand control ','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFTempMod=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/MFTempMod=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Multi-Family Recirculation with Temperture modulation','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
												<xsl:if
												test="//Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/MFTempModMon=1 or //Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/MFTempModMon=1">
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of
												select="concat('Multi-Family Recirculation with Temperature modulation and monitoring','&#10;')"
												/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
												<fo:list-block
												provisional-distance-between-starts="0.3cm"
												provisional-label-separation="0.15cm">
												<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
												<fo:block>-- None --</fo:block>
												</fo:list-item-body>
												</fo:list-item>
												</fo:list-block>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</fo:block></fo:block>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!--CalGreenSummary-->
	<xsl:template name="CalGreenSummary">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.448)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.762)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(24.487)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(22.949)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(11.462)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(16.891)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" display-align="center"
						text-align="left" border="1pt solid black" font-weight="bold"
						line-height="115%" padding="2pt">
						<fo:block>ENERGY DESIGN RATING</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" border="1pt solid black" padding="2pt">
						<fo:block>This is the sum of the annual TDV energy consumption for energy
							use components included in the performance compliance approach for the
							Standard Design Building (Energy Budget) and the annual TDV energy
							consumption for lighting and components not regulated by Title 24, Part
							6 (such as domestic appliances and consumer electronics) and accounting
							for the annual TDV energy offset by an on-site renewable energy
							system.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCell">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<fo:block>Reference Energy Use</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell background-color="rgb(236,236,232)"
						xsl:use-attribute-sets="numberCell">
						<fo:block>Energy Design Rating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Margin</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>Percent Improvement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Total Energy (kTDV/ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>-yr)*</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell background-color="rgb(236,236,232)" border="1pt solid black"
						font-weight="bold" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=7])">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3] div //SDDXML/Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="6" display-align="center" padding="2pt">
						<fo:block>* includes calculated Appliances and Miscellaneous Energy Use
							(AMEU)</fo:block>
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--BuildingFeatures-MF-->
	<xsl:template name="BuildingFeatures-MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.066)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.563)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.389)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.389)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.567)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(16.591)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(12.435)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>BUILDING - FEATURES INFORMATION-MF</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Project Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Conditioned Floor Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Dwelling Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Bedrooms</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Zones</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Ventilation<fo:block/>  Cooling Systems</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Water Heating  Systems </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/Name)">
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/Name"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/CondFloorArea)">
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/CondFloorArea"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/NumDwellingUnits)">
								<xsl:value-of
									select="//Model[@Name='Proposed']/Proj/NumDwellingUnits"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(sum(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/TotalNumBedrooms))">
								<xsl:value-of
									select="sum(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/TotalNumBedrooms)"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of select="count(//SDDXML/Model[@Name='Proposed']/Proj/Zone)"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of
								select="count(//Model[@Name='Proposed']/ClVentFan[NumAssignments=1])"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:variable name="isCentral"
								select="//Model[2]/DHWSys[Name=//Model[2]/Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef]/CentralDHW"/>
							<xsl:choose>
								<xsl:when test="$isCentral=1">
									<xsl:value-of
										select="count(//Model[2]/DHWSys[Name=//Model[2]/Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef]/CentralDHW)"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt)"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--BuildingFeatures-SF-->
	<xsl:template name="BuildingFeatures-SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.066)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.563)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.389)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.389)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.567)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(16.591)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(12.435)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>BUILDING - FEATURES INFORMATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Project Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Conditioned Floor Area (ft<fo:inline baseline-shift="super"
							font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Dwelling Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Bedrooms</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Zones</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Ventilation<fo:block/>  Cooling Systems</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Water Heating  Systems </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(//SDDXML/Model[@Name='Proposed']/Proj/Name)">
								<xsl:value-of select="//SDDXML/Model[@Name='Proposed']/Proj/Name"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Proposed']/Proj/CondFloorArea/text())">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Proposed']/Proj/CondFloorArea/text()"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Proposed']/Proj/NumDwellingUnits)">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Proposed']/Proj/NumDwellingUnits"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if
								test="string(//SDDXML/Model[@Name='Proposed']/Proj/NumBedrooms/text())">
								<xsl:value-of
									select="//SDDXML/Model[@Name='Proposed']/Proj/NumBedrooms/text()"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of select="count(//SDDXML/Model[@Name='Proposed']/Proj/Zone)"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of
								select="count(//Model[@Name='Proposed']/ClVentFan[NumAssignments=1])"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of select="count(//Model[@Name='Proposed']/DHWSys/DHWSysRpt)"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--Zone Features-SF-->
	<xsl:template name="Zone_Features-SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.249)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(16.293)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(18.357)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.329)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.718)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(14.678)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(14.376)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>ZONE INFORMATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HVAC System Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Floor Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Avg. Ceiling Height</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heating System 1</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heating System 2</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone">
					<xsl:variable name="znStatus" select="Status"/>
					<xsl:variable name="hvacStatus" select="HVACSysStatus"/>
					<xsl:variable name="dhwStatus" select="DHWSys1Status"/>
					<xsl:variable name="dhw2Status" select="DHWSys2Status"/>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								
								<xsl:choose>
									<xsl:when test="$znStatus='Existing' and $hvacStatus='Existing'">
										<xsl:value-of select="exHVACSystem"/>
									</xsl:when>
									<xsl:when test="$znStatus='Existing' and $hvacStatus='Altered'">
										<xsl:value-of select="AltHVACSystem"/>
									</xsl:when>
									<xsl:when test="$znStatus='Altered' and $hvacStatus='Altered'">
										<xsl:value-of select="AltHVACSystem"/>
									</xsl:when>
									<xsl:when test="$znStatus='Altered' and $hvacStatus='New'">
										<xsl:value-of select="HVACSystem"/>
									</xsl:when>
									<xsl:when test="$znStatus='New' and $hvacStatus='Altered'">
										<xsl:value-of select="AltHVACSystem"/>
									</xsl:when>
									<xsl:when test="$znStatus='New' and $hvacStatus='Existing'">
										<xsl:value-of select="exHVACSystem"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HVACSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CondFloorArea/text())">
									<xsl:value-of select="CondFloorArea/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CeilingHeight/text())">
									<xsl:value-of select="CeilingHeight/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>	
								<xsl:choose>
									<xsl:when test="$znStatus='Existing' and $dhwStatus='Existing'">
										<xsl:value-of select="exDHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='Existing' and $dhwStatus='Altered'">
										<xsl:value-of select="AltDHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='Existing' and $dhwStatus='New'">
										<xsl:value-of select="DHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='Altered' and $dhwStatus='Altered'">
										<xsl:value-of select="AltDHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='Altered' and $dhwStatus='New'">
										<xsl:value-of select="DHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='New' and $dhwStatus='New'">
										<xsl:value-of select="DHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='New' and $dhwStatus='Altered'">
										<xsl:value-of select="AltDHWSys1"/>
									</xsl:when>
									<xsl:when test="$znStatus='New' and $dhwStatus='Existing'">
										<xsl:value-of select="exDHWSys1"/>
									</xsl:when>
									<xsl:otherwise>
										<!--<xsl:value-of select="exDHWSys1"/>-->
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
							<!--<fo:block>
								<xsl:if test="string(DHWSys1 | AltDHWSys1)">
									<xsl:value-of select="DHWSys1 | AltDHWSys1"/>
								</xsl:if>
							</fo:block>-->
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								
								<xsl:choose>
									<xsl:when test="($znStatus='Existing' and DHWSys2ExCondFloorArea > 0) and $dhw2Status='Existing'">
										<xsl:value-of select="exDHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='Existing' and DHWSys2ExCondFloorArea > 0) and $dhw2Status='Altered'">
										<xsl:value-of select="AltDHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='Existing' and DHWSys2ExCondFloorArea > 0) and $dhw2Status='New'">
										<xsl:value-of select="DHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='Altered' and DHWSys2AltCondFloorArea > 0) and $dhw2Status='Altered'">
										<xsl:value-of select="AltDHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='Altered'and DHWSys2AltCondFloorArea > 0) and $dhw2Status='New'">
										<xsl:value-of select="DHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='New' and DHWSys2NewCondFloorArea > 0) and $dhw2Status='New'">
										<xsl:value-of select="DHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='New' and DHWSys2NewCondFloorArea > 0) and $dhw2Status='Altered'">
										<xsl:value-of select="AltDHWSys2"/>
									</xsl:when>
									<xsl:when test="($znStatus='New' and DHWSys2NewCondFloorArea > 0) and $dhw2Status='Existing'">
										<xsl:value-of select="exDHWSys2"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="DHWSys2"/>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
							<!--<fo:block>
								<xsl:if test="string(DHWSys2  | AltDHWSys2)">
									<xsl:value-of select="DHWSys2  | AltDHWSys2"/>
								</xsl:if>
							</fo:block>-->
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Zone Features-MF-->
	<xsl:template name="Zone_Features-MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(24.156)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(24.221)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(15.355)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(15.799)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(20.468)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block>ZONE INFORMATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone Floor Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Avg. Ceiling Height</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Dwelling Units</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//SDDXML/Model[@Name='Proposed']/Proj/Zone">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CondFloorArea/text())">
									<xsl:value-of select="CondFloorArea/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CeilingHeight/text())">
									<xsl:value-of select="CeilingHeight/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(NumDwellingUnits)">
									<xsl:value-of select="NumDwellingUnits"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Dwelling Unit Table-->
	<xsl:template name="Dwelling_Unit_Table">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.187)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(16.814)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.318)" column-number="3"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cell">
						<fo:block>DWELLING UNIT INFORMATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dwelling Unit Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dwelling Unit Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DwellUnitRpt">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DwellUnitTypeRef)">
									<xsl:value-of select="DwellUnitTypeRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(ZoneRef)">
									<xsl:value-of select="ZoneRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Dwelling Unit Types-->
	<xsl:template name="Dwelling_Unit_Types">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.219)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(7.175)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.346)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.134)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(28.742)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(15.821)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(13.562)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>DWELLING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0.185in" overflow="hidden" font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>CFA (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Bedrooms</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number in Building</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Space Conditioning Systems Assigned</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>DHW System Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Vent Fan Name</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DwellUnitType">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CondFlrArea)">
									<xsl:value-of select="CondFlrArea"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(NumBedrooms)">
									<xsl:value-of select="NumBedrooms"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="dwellunit" select="Name"/>
								<xsl:value-of
									select="sum(//Model[@Name='Proposed']/Proj/Zone/DwellUnit[DwellUnitTypeRef=$dwellunit]/Count)"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:for-each select="SCSysRptRef">
									<xsl:variable name="sysrptindex" select="./@index"/>
									<!-- list start -->
									<fo:list-block>
										<!-- list item -->
										<fo:list-item>
											<!-- insert a bullet -->
											<fo:list-item-label end-indent="label-end()">
												<fo:block>
												<xsl:text/>
												</fo:block>
											</fo:list-item-label>
											<!-- list text -->
											<fo:list-item-body start-indent="0">
												<fo:block>
												<xsl:value-of select="current()"/>
												<!--<xsl:value-of
													select="concat('  ' ,current(),' (',../NumAssigningDUs,')')"
												/>-->
												</fo:block>
											</fo:list-item-body>
										</fo:list-item>
									</fo:list-block>
								</xsl:for-each>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysRef)">
									<xsl:value-of select="DHWSysRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="IAQNumFanRefs &gt; 0">
										<xsl:for-each select="IAQFanRef">
											<!-- list start -->
											<fo:list-block>
												<!-- list item -->
												<fo:list-item>
												<!-- insert a bullet -->
												<fo:list-item-label end-indent="label-end()">
												<fo:block>
												<xsl:text/>
												</fo:block>
												</fo:list-item-label>
												<!-- list text -->
												<fo:list-item-body start-indent="0">
												<fo:block>
												<xsl:value-of
												select="concat('  ' ,current(),'&#10;')"/>
												</fo:block>
												</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:for-each>
										<!-- End list -->
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="IAQOption"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Opaque Surfaces-->
	<xsl:template name="EAA_Opaque_Surfaces">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(15.892)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(16.766)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.728)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.657)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.657)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8.918)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.168)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.058)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(6.578)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(6.578)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>OPAQUE SURFACES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04 </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05 </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Construction</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Azimuth</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Orientation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Gross Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Window &amp; Door<fo:block/>Area (ft<fo:inline
								baseline-shift="super" font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tilt<fo:block/>(deg)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall | //Model[@Name='Proposed']/Proj/Zone/IntWall | //Model[@Name='Proposed']/Proj/Zone/CeilingBelowAttic | 
					//Model[@Name='Proposed']/Proj/Zone/ExteriorFloor | //Model[@Name='Proposed']/Proj/Zone/FloorOverCrawl | //Model[@Name='Proposed']/Proj/Zone/InteriorFloor | 
					//Model[@Name='Proposed']/Proj/Garage/ExtWall | //Model[@Name='Proposed']/Proj/Garage/IntWall | //Model[@Name='Proposed']/Proj/Garage/CeilingBelowAttic | 
					//Model[@Name='Proposed']/Proj/Garage/FloorOverCrawl | //Model[@Name='Proposed']/Proj/Garage/ExteriorFloor|//Model[@Name='Proposed']/Proj/Zone/InteriorFloor |
					//Model[@Name='Proposed']/Proj/Zone/InteriorCeiling | //Model[@Name='Proposed']/Proj/Zone/UndWall">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="Outside">
										<xsl:value-of select="concat(../Name, '&gt;&gt;',Outside)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="../Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Construction)">
									<xsl:value-of select="Construction"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Azimuth)">
									<xsl:value-of select="Azimuth"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="orient" select="Orientation"/>
								<xsl:choose>
									<xsl:when test="contains($orient,'specify')">
										<xsl:value-of select="OrientationValue"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$orient"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Area/text())">
									<xsl:value-of select="Area/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(ChildAreaSum)">
									<xsl:value-of select="ChildAreaSum"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Tilt/text())">
									<xsl:value-of select="Tilt/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:variable name="status" select="Status"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0 and $status='Existing'"> No </xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Opaque-Cathedral Ceilings-->
	<xsl:template name="EAA_Opaque-Cathedral_Ceilings">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.663)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.392)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.243)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.464)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.025)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.195)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(6.548)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(4.733)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(6.065)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(6.162)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(6.142)" column-number="11"/>
			<fo:table-column column-width="proportional-column-width(4.845)" column-number="12"/>
			<fo:table-column column-width="proportional-column-width(5.225)" column-number="13"/>
			<fo:table-column column-width="proportional-column-width(6.298)" column-number="14"/>
			<fo:table-body>
				<fo:table-row height="0.224in" overflow="hidden">
					<fo:table-cell number-columns-spanned="14" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>OPAQUE SURFACES – Cathedral Ceilings</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>11</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>12</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>13</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Orientation</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Area<fo:block/>(ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Skylight<fo:block/>Area (ft2)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Roof Rise<fo:block/>(x in 12)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Roof Pitch</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Roof Tilt(deg)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Roof Reflectance</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Roof Emittance</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Framing Factor</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Verified Existing Condifion </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/CathedralCeiling | //Model[@Name='Proposed']/Proj/Garage/CathedralCeiling">
					<fo:table-row>
						<xsl:variable name="isFirst_id5926404">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Construction/text())">
									<xsl:value-of select="Construction/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Orientation/text())">
									<xsl:value-of select="Orientation/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Area/text())">
									<xsl:value-of select="Area/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ChildAreaSum)">
									<xsl:value-of select="ChildAreaSum"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(RoofRise/text())">
									<xsl:value-of select="RoofRise/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="round(RoofPitch*100) div 100"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="round(RoofTilt*100) div 100"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(RoofSolReflect/text())">
									<xsl:value-of select="RoofSolReflect/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(RoofEmiss/text())">
									<xsl:value-of select="RoofEmiss/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(FramingFactor/text())">
									<xsl:value-of select="FramingFactor/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:variable name="status" select="Status"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0 and $status='Existing'"> No </xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--EAA_Attic-->
	<xsl:template name="EAA_Attic">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.433)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(17.126)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.937)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.742)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(8.159)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.532)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(6.616)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.564)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(10.31)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(9.58)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>ATTIC</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Construction</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof Rise</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof Reflectance</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof Emittance</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Radiant Barrier</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cool Roof</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Attic">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Construction)">
									<xsl:value-of select="Construction"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RoofRise)">
									<xsl:value-of select="RoofRise"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RoofSolReflect/text())">
									<xsl:value-of select="RoofSolReflect/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RoofEmiss/text())">
									<xsl:value-of select="RoofEmiss/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="getCons" select="Construction/text()"/>
								<xsl:variable name="getRadBar"
									select="//Model[@Name='Proposed']/Cons[Name=$getCons]/RadiantBarrier"/>
								<xsl:choose>
									<xsl:when test="$getRadBar=1"> Yes </xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SolReflSpclFtrs&gt;=2"> Yes </xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0"> No </xsl:when>
									<xsl:otherwise>NA</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--EAA_Windows-->
	<xsl:template name="EAA_Windows">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.298)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(18.228)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(6.305)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.145)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.08)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(6.037)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.356)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(4.878)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(13.302)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(6.587)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(7.783)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>FENESTRATION / GLAZING</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Surface (Orientation-Azimuth)</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block><fo:inline>Width (ft)</fo:inline> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Height (ft)</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Multiplier</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>U-factor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SHGC</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Exterior Shading</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling/Skylt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5927170">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block><fo:inline>
									<xsl:if
										test="string(concat(../Name,' (',../Orientation,'-',../Azimuth,')'))">
										<xsl:value-of
											select="concat(../Name,' (',../Orientation,'-',../Azimuth,')')"
										/>
									</xsl:if>
								</fo:inline> </fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Skylt or SpecMethod = 'Overall Window Area'"
										>----</xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(Width)) != 'NaN' ">
											<xsl:value-of select="format-number(Width,'#.0')"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Skylt or SpecMethod = 'Overall Window Area'">
										---- </xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(Height)) != 'NaN' ">
											<xsl:value-of select="format-number(Height,'#.0')"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Multiplier)">
									<xsl:value-of select="Multiplier"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of
									select="format-number(TotAreaInclMult/text(), &quot;#.0&quot;)"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of
									select="format-number(NFRCUfactor/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of
									select="format-number(NFRCSHGC/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Win">
										<xsl:value-of select="ExteriorShade"/>
									</xsl:when>
									<xsl:when test="../Skylt"> None </xsl:when>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:variable name="status" select="Status"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0 and $status='Existing'"> No </xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--EAA_Doors-->
	<xsl:template name="EAA_Doors">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.898)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(28.455)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.01)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.72)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(8.61)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(19.307)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>OPAQUE DOORS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Side of Building</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>U-factor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//SDDXML/Model[@Name='Proposed']/Proj/Zone/ExtWall/Door | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door">
					<fo:table-row>
						<xsl:variable name="isFirst_id10633326">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="format-number(Area, '0.0')"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of
									select="format-number(Ufactor/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0"> No </xsl:when>
									<xsl:otherwise>NA</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--Overhangs-Fins-->
	<xsl:template name="Overhangs-Fins">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(20.577)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(6.663)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(6.424)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5.904)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(6.42)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(6.812)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(6.703)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(6.443)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(5.726)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(6.027)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(5.876)" column-number="11"/>
			<fo:table-column column-width="proportional-column-width(6.179)" column-number="12"/>
			<fo:table-column column-width="proportional-column-width(5.425)" column-number="13"/>
			<fo:table-column column-width="proportional-column-width(4.821)" column-number="14"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="14" xsl:use-attribute-sets="cell">
						<fo:block>OVERHANGS AND FINS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>12</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>13</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>14</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cellAC">
						<fo:block>Overhang</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellAC">
						<fo:block>Left Fin</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellAC">
						<fo:block>Right Fin</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Window</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Depth</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dist Up</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Left Extent</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Right Extent</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Flap Ht.</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Depth</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Top Up</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dist L</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bot Up</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Depth</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Top Up</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dist R</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bot Up</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//SDDXML/Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[ShowFinsOverhang=1]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(OverhangDepth)">
									<xsl:value-of select="OverhangDepth"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(OverhangDistUp)">
									<xsl:value-of select="OverhangDistUp"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(OverhangExL)">
									<xsl:value-of select="OverhangExL"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(OverhangExR)">
									<xsl:value-of select="OverhangExR"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(OverhangFlap)">
									<xsl:value-of select="OverhangFlap"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(LeftFinDepth)">
									<xsl:value-of select="LeftFinDepth"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(LeftFinTopUp)">
									<xsl:value-of select="LeftFinTopUp"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(LeftFinDistL)">
									<xsl:value-of select="LeftFinDistL"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(LeftFinBotUp)">
									<xsl:value-of select="LeftFinBotUp"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RightFinDepth)">
									<xsl:value-of select="RightFinDepth"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block><xsl:if test="string(RightFinTopUp)">
									<xsl:value-of select="RightFinTopUp"/>
								</xsl:if>  </fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RightFinDistR)">
									<xsl:value-of select="RightFinDistR"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RightFinBotUp)">
									<xsl:value-of select="RightFinBotUp"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Opaque Surface Constructions-->
	<xsl:template name="Opaque_Surface_Constructions">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.334)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.576)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.611)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(18.194)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(8.907)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.252)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(24.126)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>OPAQUE SURFACE CONSTRUCTIONS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Construction Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Surface Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Construction Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Framing</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Total Cavity<fo:block/>R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Winter Design<fo:block/>U-factor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Assembly Layers</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Cons[AssignedSurfaceArea &gt; 0 and CanAssignTo='Exterior Walls'] | //Model[@Name='Proposed']/Cons[CanAssignTo='Cathedral Ceilings' and AssignedSurfaceArea &gt; 0] | 
					//Model[@Name='Proposed']/Cons[CanAssignTo='Interior Walls' and AssignedSurfaceArea &gt;0] | //Model[@Name='Proposed']/Cons[CanAssignTo='Attic Roofs' and AssignedSurfaceArea &gt;0] | 
					//Model[@Name='Proposed']/Cons[CanAssignTo='Floors Over Crawlspace' and AssignedSurfaceArea &gt;0] | //Model[@Name='Proposed']/Cons[CanAssignTo='Ceilings (below attic)' and AssignedSurfaceArea &gt;0] | 
					//Model[@Name='Proposed']/Cons[CanAssignTo='Exterior Floors' and AssignedSurfaceArea &gt;0]|//Model[@Name='Proposed']/Cons[CanAssignTo='Interior Floors' and AssignedSurfaceArea &gt;0] |
					//Model[@Name='Proposed']/Cons[CanAssignTo='Underground Walls' and AssignedSurfaceArea &gt;0] | //Model[@Name='Proposed']/Cons[CanAssignTo = &quot;Interior Ceilings&quot; and AssignedSurfaceArea &gt; 0]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(CanAssignTo)">
									<xsl:value-of select="CanAssignTo"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(FramingRpt)">
									<xsl:value-of select="FramingRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(CavityRRpt)">
									<xsl:value-of select="CavityRRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellAC">
							<fo:block>
								<xsl:if test="string(format-number(WinterDesUValue,'0.000'))">
									<xsl:value-of select="format-number(WinterDesUValue,'0.000')"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell font-style="italic" border="1pt solid black"
							display-align="before" padding="2pt">
							<fo:block>
								<xsl:variable name="newline">
									<xsl:text/>
								</xsl:variable>
								<fo:list-block provisional-distance-between-starts="0.3cm"
									provisional-label-separation="0.15cm">
									<xsl:for-each select="./AssemblyLayersRpt">
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block>•</fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<fo:block>
												<xsl:value-of select="concat(.,$newline)"/>
												</fo:block>
											</fo:list-item-body>
										</fo:list-item>
									</xsl:for-each>
								</fo:list-block>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Slab Floor-->
	<xsl:template name="EAA_Slab_Floor">		
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(22.382)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(16.046)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.75)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.21)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(17.793)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.003)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.231)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(6.098)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8.486)" column-number="9"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="9" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%"
						padding="2pt" text-align="left">
						<fo:block>SLAB FLOORS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04 </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05 </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>
							<fo:inline font-weight="bold">Perimeter (ft)</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Edge Insul. R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Carpeted Fraction</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Heated</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/SlabFloor | //Model[@Name='Proposed']/Proj/Zone/UndFloor">
					<fo:table-row>
						<xsl:variable name="isFirst_id5500692">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:if test="string(Area/text())">
									<xsl:value-of select="Area/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="Perimeter">
										<xsl:value-of select="Perimeter"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="EdgeInsulation=1">
										<xsl:value-of
											select="concat('R-',EdgeInsulRValue,', ',EdgeInsulDepth,' inches')"
										/>
									</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:if test="string(CarpetedFrac/text())">
									<xsl:value-of select="CarpetedFrac/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:variable name="slabheat" select="(HeatedSlab/text())"/>
								<xsl:choose>
									<xsl:when test="$slabheat = '1'">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center"
							padding="2pt" text-align="center">
							<fo:block>
								<xsl:variable name="slabStatus" select="IsAltered"/>
								<xsl:variable name="slabVerify" select="IsVerified"/>
								<xsl:choose>
									<xsl:when test="$slabStatus=1 and $slabVerify=1"> Yes </xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Building Envelope HERS-->
	<xsl:template name="Building_Envelope_HERS">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(28.784)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(26.723)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(23.244)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(21.249)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>BUILDING ENVELOPE - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Quality Insulation Installation (QII)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Quality Installation of Spray Foam Insulation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Building Envelope Air Leakage</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>CFM50</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/HERSOther">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="//Model[@Name='Proposed']/HERSOther/QII=1">
										Required </xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when
										test="//Model[@Name='Proposed']/HERSOther/SprayFoamHighR=1"
										>Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when
										test="//Model[@Name='Proposed']/HERSOther/LowBldgLkg=1">
										Required </xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when
										test="//Model[@Name='Proposed']/HERSOther/LowBldgLkg=1">
										<xsl:value-of select="format-number(LowBldgLkgRptMsg,'0.0')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_WaterHeatingSystems-MultiFamily-->
	<xsl:template name="EAA_WaterHeatingSystems-MultiFamily">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12.537)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.061)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.061)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.061)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10.519)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8.557)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8.55)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(7.843)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(7.901)" column-number="9"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="9" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number in Building</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Multi-Family Distribution Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heater</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation Loop</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation Pump Power (bhp)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation Pump Efficiency (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Solar Fraction (%)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DHWSys">
					<fo:table-row>
						<xsl:variable name="isFirst_id5928293">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(SystemType/text())">
									<xsl:value-of select="SystemType/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterMult)">
									<xsl:value-of select="HeaterMult"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(MFamDistType/text())">
									<xsl:value-of select="MFamDistType/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeater/text())">
									<xsl:value-of select="DHWHeater/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block> </fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RecircPumpHP/text())">
									<xsl:value-of select="RecircPumpHP/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(RecircPumpEff/text())">
									<xsl:value-of select="RecircPumpEff/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hasSolar">
									<xsl:value-of
										select="//SDDXML/Model[@Name='Proposed']/DHWSys[Name=//SDDXML/Model[@Name='Proposed']/Proj/Zone[DHWSys1Status='Existing' and DHWSys1ExCondFloorArea &gt; 0]/exDHWSys1]/SolFracAnnRpt | //SDDXML/Model[@Name='Proposed']/DHWSys[Name=//SDDXML/Model[@Name='Proposed']/Proj/Zone[DHWSys1Status='Altered' and DHWSys1AltCondFloorArea &gt; 0]/AltDHWSys1]/SolFracType | //SDDXML/Model[@Name='Proposed']/DHWSys[Name=//SDDXML/Model[@Name='Proposed']/Proj/Zone[DHWSys2Status='Existing' and DHWSys2ExCondFloorArea &gt; 0]/exDHWSys2]/SolFracAnnRpt | //SDDXML/Model[@Name='Proposed']/DHWSys[Name=//SDDXML/Model[@Name='Proposed']/Proj/Zone[DHWSys2Status='Altered' and DHWSys2AltCondFloorArea &gt; 0]/AltDHWSys2]/SolFracAnnRpt "
									/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($hasSolar,'none')">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="SolFracAnnRpt"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--WaterHeater Detail-->
	<xsl:template match="DHWSys" mode="Waterheaters_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(13)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Uniform Energy Factor / Energy Factor / Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating/Pilot</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss / Recovery Eff</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>NEEA Heat Pump Brand / Model</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="DHWSysRpt">
					<xsl:variable name="heaterName" select="DHWHeaterRef"/>
					<xsl:variable name="tankType" select="TankType"/>
					<xsl:variable name="isHydronic" select="../IsHydronic"/>
					<xsl:variable name="isHP">
						<xsl:choose>
							<xsl:when test="contains(HeaterElementType,'Heat Pump')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="isNEEA">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/HPWH_NEEARated"
						/>
					</xsl:variable>
					<xsl:variable name="isUEF">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/IsUEF"/>
					</xsl:variable>
					<xsl:variable name="hasLocation">
						<xsl:choose>
							<xsl:when test="TankLocation/text()">1</xsl:when>
							<xsl:when test="TankLocation[normalize-space(.)]=''">0</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="TankType='NA'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="TankType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="DHWHeaterCnt"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="TankVolume"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$isUEF=1">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="replace">EF</xsl:with-param>
											<xsl:with-param name="text" select="EfficiencyRpt"/>
											<xsl:with-param name="with">UEF</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="EfficiencyRpt"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if
									test="contains(TankType,'Residential-Duty Commercial Storage')">
									<fo:block>
										<xsl:text>&#xa;</xsl:text>
									</fo:block>
									
									<xsl:value-of select="concat('&#xa;',EfficiencyRpt)"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test=" InputRating and InputRating > 0 ">
										<xsl:value-of select="InputRatingRpt"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="ExtInsulRpt='NA'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ExtInsulRpt"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="contains($tankType,'Large Storage')">
										<xsl:choose>
											<xsl:when test="IsHydronic=1">
												<fo:block>
													<xsl:value-of
														select="concat(StandbyLossFrac,' / ',RecovEff)"/>
												</fo:block>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
													<xsl:value-of select="StandbyLossFrac"/>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="HasElecMiniTank=1">
										<fo:block>
											<xsl:value-of
												select="concat(ElecMiniTankPower,' Watts')"/>
										</fo:block>
										<fo:block> (Mini Tank Pwr) </fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$isNEEA = 1">
										<xsl:value-of select="MakeAndModel"/>
									</xsl:when>
									<xsl:otherwise>
										<!--<xsl:value-of select="$isNEEA"/>-->
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$hasLocation=1">
										<xsl:value-of select="TankLocation"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:value-of select="TankLocation"/>-->
								<!--<xsl:choose><xsl:when test="TankLocation[normalize-space(.)]">
									<xsl:call-template name="na"/>
								</xsl:when>
									<xsl:when test="TankLocation/text()">
										<xsl:value-of select="TankLocation"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--WaterHeater Detail-->
	<xsl:template name="Waterheaters_SF_UEF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(6)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="11"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="12"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="12" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>12</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Uniform Energy Factor / Energy Factor / Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating / Pilot / Thermal Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss / Recovery Eff</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>First Hour Rating / Flow Rate</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>NEEA Heat Pump Brand / Model</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//SDDXML/Model[@Name='Proposed']/DHWSys[NumDUsServed > 0]/DHWSysRpt">
					<xsl:variable name="heaterName" select="DHWHeaterRef"/>
					<xsl:variable name="tankType" select="TankType"/>
					<xsl:variable name="isHydronic" select="../IsHydronic"/>
					<xsl:variable name="isHP">
						<xsl:choose>
							<xsl:when test="contains(HeaterElementType,'Heat Pump')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="isNEEA">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/HPWH_NEEARated"
						/>
					</xsl:variable>
					<xsl:variable name="isUEF">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/IsUEF"/>
					</xsl:variable>
					<xsl:variable name="hasLocation">
						<xsl:choose>
							<xsl:when test="TankLocation/text()">1</xsl:when>
							<xsl:when test="TankLocation[normalize-space(.)]=''">0</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankType"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="DHWHeaterCnt"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankVolumeRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="EfficiencyRpt"/>
								</xsl:call-template>
								<!--<xsl:value-of select="EfficiencyRpt"/>-->
								<!--<xsl:choose>
									<xsl:when test="$isUEF=1">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="replace">EF</xsl:with-param>
											<xsl:with-param name="text" select="EfficiencyRpt"/>
											<xsl:with-param name="with">UEF</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="EfficiencyRpt"/>
									</xsl:otherwise>
								</xsl:choose-->
								<xsl:if
									test="contains(TankType,'Residential-Duty Commercial Storage')">
									<fo:block>
										<xsl:text>&#xa;</xsl:text>
									</fo:block>
									<xsl:value-of select="concat('&#xa;',RecovEffRpt,'(TE)')"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="InputRatingRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="ExtInsulRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="contains($tankType,'Large Storage')">
										<xsl:choose>
											<xsl:when test="IsHydronic=1">
												<fo:block>
													<xsl:value-of
														select="concat(StandbyLossFrac,' / ',RecovEff)"/>
												</fo:block>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
													<xsl:value-of select="StandbyLossFrac"/>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="HasElecMiniTank=1">
										<fo:block>
											<xsl:value-of
												select="concat(ElecMiniTankPower,' Watts')"/>
										</fo:block>
										<fo:block> (Mini Tank Pwr) </fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$isUEF=1">
										<xsl:choose>
											<xsl:when test="FirstHourRatingRpt != 'NA'">
												<xsl:value-of select="FirstHourRatingRpt"/>
											</xsl:when>
											<xsl:when test="RatedFlowRpt != 'NA'">
												<xsl:value-of select="RatedFlowRpt"/>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="MakeAndModel"/>
								</xsl:call-template>										
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankLocation"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:if test="$isUEF=1">
						<fo:table-row>
							<fo:table-cell>
								
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
					
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

		<!--WaterHeater Detail-->
	<xsl:template name="WaterHeaters_SF4">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(13)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Energy Factor or Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating/Pilot</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss / Recovery Eff</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>NEEA Heat Pump Brand / Model</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DHWHeater[FloorAreaServed > 0]">
					<xsl:variable name="heaterName" select="Name" />
					<xsl:variable name="tankType" select="TankType"/>
					<xsl:variable name="isHydronic" select="IsHydronic"/>
					<xsl:variable name="isHP">
						<xsl:choose>
							<xsl:when test="contains(HeaterElementType,'Heat Pump')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="TankType='NA'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="TankType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="sum(//Model[@Name='Proposed']/DHWSys/DHWSysRpt[DHWHeaterRef=$heaterName]/DHWHeaterCnt)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="TankVolume > 0 and HPWH_NEEARated = 0">
										<xsl:value-of select="TankVolume"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HPWH_NEEARated = 0">
										<xsl:value-of select="concat(EnergyFactor,' ',EfficiencyUnits)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test=" InputRating | InputRating > 0 ">
										<xsl:value-of select="concat(InputRating,' ',InputRatingUnits)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="IntInsulRVal > 0 or ExtInsulRVal > 0">
										<xsl:value-of select="concat('R-',IntInsulRVal,' / R-',ExtInsulRVal)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="contains($tankType,'Large Storage')">
										<xsl:choose>
											<xsl:when test="IsHydronic=1">
												<fo:block>
													<xsl:value-of select="concat(StandbyLossFrac,' / ',RecovEff)"/>
												</fo:block>												
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
													<xsl:value-of select="StandbyLossFrac"/>
												</fo:block>												
											</xsl:otherwise>
										</xsl:choose>										
									</xsl:when>
									<xsl:when test="HasElecMiniTank=1">
										<fo:block>
											<xsl:value-of select="concat(ElecMiniTankPower,' Watts')"/>
										</fo:block>
										<fo:block>
											(Mini Tank Pwr)
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HPWH_NEEARated = 1">
										<xsl:value-of select="concat(HPWHBrand,' / ',HPWHModel)"/>
<!--										<xsl:value-of select="ASHPType"/>-->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="ShowTankLocation=1">
										<xsl:call-template name="getTankLocation">
											<xsl:with-param name="isOutside" select="TankOutside"/>
											<xsl:with-param name="location" select="TankZone"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template name="isNA">
		<xsl:param name="input"/>
		<xsl:choose>
			<xsl:when test="$input='NA'">
				<xsl:call-template name="na"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--Special Water Heater display elements -->
	<xsl:template name="getTankLocation">
		<xsl:param name="isOutside"/>
		<xsl:param name="location"/>
		<xsl:choose>
			<xsl:when test="$isOutside=1">Outside</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$location"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<!--WaterHeater Detail-->
	<xsl:template name="Waterheaters_MF_UEF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(6)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="11"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="12"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="12" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>12</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Uniform Energy Factor / Energy Factor / Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating / Pilot / Thermal Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss / Recovery Eff</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>First Hour Rating / Flow Rate</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>NEEA Heat Pump Brand / Model</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[not(DHWHeaterRef = preceding::DHWSysRpt/DHWHeaterRef)]">
					<xsl:variable name="heaterName" select="DHWHeaterRef"/>
					<xsl:variable name="tankType" select="TankType"/>
					<xsl:variable name="isHydronic" select="../IsHydronic"/>
					<xsl:variable name="isHP">
						<xsl:choose>
							<xsl:when test="contains(HeaterElementType,'Heat Pump')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="isNEEA">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/HPWH_NEEARated"
						/>
					</xsl:variable>
					<xsl:variable name="isUEF">
						<xsl:value-of
							select="../following-sibling::DHWHeater[Name=$heaterName]/IsUEF"/>
					</xsl:variable>
					<xsl:variable name="hasLocation">
						<xsl:choose>
							<xsl:when test="TankLocation/text()">1</xsl:when>
							<xsl:when test="TankLocation[normalize-space(.)]=''">0</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankType"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="DHWHeaterCnt"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankVolumeRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="EfficiencyRpt"/>
								</xsl:call-template>
								<!--<xsl:value-of select="EfficiencyRpt"/>-->
								<!--<xsl:choose>
									<xsl:when test="$isUEF=1">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="replace">EF</xsl:with-param>
											<xsl:with-param name="text" select="EfficiencyRpt"/>
											<xsl:with-param name="with">UEF</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="EfficiencyRpt"/>
									</xsl:otherwise>
								</xsl:choose-->
								<xsl:if
									test="contains(TankType,'Residential-Duty Commercial Storage')">
									<fo:block>
										<xsl:text>&#xa;</xsl:text>
									</fo:block>
									<xsl:value-of select="concat('&#xa;',RecovEffRpt,'(TE)')"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="InputRatingRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="ExtInsulRpt"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="contains($tankType,'Large Storage')">
										<xsl:choose>
											<xsl:when test="IsHydronic=1">
												<fo:block>
													<xsl:value-of
														select="concat(StandbyLossFrac,' / ',RecovEff)"/>
												</fo:block>
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
													<xsl:value-of select="StandbyLossFrac"/>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="HasElecMiniTank=1">
										<fo:block>
											<xsl:value-of
												select="concat(ElecMiniTankPower,' Watts')"/>
										</fo:block>
										<fo:block> (Mini Tank Pwr) </fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$isUEF=1">
										<xsl:choose>
											<xsl:when test="FirstHourRatingRpt != 'NA'">
												<xsl:value-of select="FirstHourRatingRpt"/>
											</xsl:when>
											<xsl:when test="RatedFlowRpt != 'NA'">
												<xsl:value-of select="RatedFlowRpt"/>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="MakeAndModel"/>
								</xsl:call-template>										
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="TankLocation"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:if test="$isUEF=1">
						<fo:table-row>
							<fo:table-cell>
								
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
					
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--WaterHeater Detail MF-->
	<xsl:template name="WaterHeaters_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(13)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Energy Factor or Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating/Pilot</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss / Recovery Eff</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>NEEA Heat Pump Brand / Model</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DHWHeater[FloorAreaServed > 0]">
					<xsl:variable name="heaterName" select="Name" />
					<xsl:variable name="tankType" select="TankType"/>
					<xsl:variable name="isHydronic" select="IsHydronic"/>
					<xsl:variable name="isHP">
						<xsl:choose>
							<xsl:when test="contains(HeaterElementType,'Heat Pump')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TankType)">
									<xsl:value-of select="TankType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[DHWHeaterRef=$heaterName and preceding::DHWSysRpt/DHWHeaterRef!=$heaterName]/DHWHeaterCnt"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="TankVolume > 0 and HPWH_NEEARated = 0">
										<xsl:value-of select="TankVolume"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HPWH_NEEARated = 0">
										<xsl:value-of select="concat(EnergyFactor,' ',EfficiencyUnits)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test=" InputRating | InputRating > 0 ">
										<xsl:value-of select="concat(InputRating,' ',InputRatingUnits)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="IntInsulRVal > 0 or ExtInsulRVal > 0">
										<xsl:value-of select="concat('R-',IntInsulRVal,' / R-',ExtInsulRVal)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="contains($tankType,'Large Storage')">
										<xsl:choose>
											<xsl:when test="IsHydronic=1">
												<fo:block>
													<xsl:value-of select="concat(StandbyLossFrac,' / ',RecovEff)"/>
												</fo:block>												
											</xsl:when>
											<xsl:otherwise>
												<fo:block>
													<xsl:value-of select="StandbyLossFrac"/>
												</fo:block>												
											</xsl:otherwise>
										</xsl:choose>										
									</xsl:when>
									<xsl:when test="HasElecMiniTank=1 and $isHP=0">
										<fo:block>
											<xsl:value-of select="concat(ElecMiniTankPower,' Watts')"/>
										</fo:block>
										<fo:block>
											(Mini Tank Pwr)
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HPWH_NEEARated = 1">
										<xsl:value-of select="ASHPType"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="ShowTankLocation=1">
										<xsl:call-template name="getTankLocation">
											<xsl:with-param name="isOutside" select="TankOutside"/>
											<xsl:with-param name="location" select="TankZone"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--DHW HERS MEASURES-->
	<xsl:template name="DHWHERS">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12.672)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.191)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.633)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.651)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.929)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Pipe Insulation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Parallel Piping</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Compact Distribution</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Point-of Use</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation Control</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Central DHW Distribution</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt | //Model[@Name='Proposed']/DHWSys/DHWSysRpt">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysName)">
									<xsl:value-of select="DHWSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSAllPipesIns=1">
										<xsl:value-of select="HERSPipeInsRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSParallelPipe=1">
										<xsl:value-of select="HERSParaPipeRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSCompact=1">
										<xsl:value-of select="HERSCompactRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSPointOfUse=1">
										<xsl:value-of select="HERSPOURptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSPushBtnRecirc=1">
										<xsl:value-of select="HERSPushBtnRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSOccRecirc=1">
										<xsl:value-of select="HERSOccRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSMFNoControl=1">
										<xsl:value-of select="HERSMFNoCtrlRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFDemandControl=1">
										<xsl:value-of select="HERSMFDCRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFTempMod=1">
										<xsl:value-of select="HERSMFTmpModRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFTempModMon=1">
										<xsl:value-of select="HERSMFTmpModMonRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--EAA_WaterHeaters-SF-2016-V2-->
	<xsl:template name="EAA_WaterHeaters-MF-2016">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.35)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.19)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.45)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.652)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.667)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.239)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.878)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(7.466)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(15.382)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(10.724)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Energy Factor or Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Exterior Insulation <fo:block/>R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss (Fraction)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Make &amp; Model Number</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5924696">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankType)">
									<xsl:value-of select="TankType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankVolumeRpt)">
									<xsl:value-of select="TankVolumeRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(EfficiencyRpt)">
									<xsl:value-of select="EfficiencyRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(InputRatingRpt)">
									<xsl:value-of select="InputRatingRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ExtInsulRpt)">
									<xsl:value-of select="ExtInsulRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(StandbyLossRpt)">
									<xsl:value-of select="StandbyLossRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(MakeAndModel)">
									<xsl:value-of select="MakeAndModel"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankLocation)">
									<xsl:value-of select="TankLocation"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_WaterHeaters-SF-2016-V2-->
	<xsl:template name="EAA_WaterHeaters-SF-2016-V2">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.35)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.19)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.45)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.652)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.667)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.239)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.878)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(7.466)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(15.382)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(10.724)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Energy Factor or Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Exterior Insulation <fo:block/>R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss (Fraction)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Make &amp; Model Number</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5924696">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankType)">
									<xsl:value-of select="TankType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankVolumeRpt)">
									<xsl:value-of select="TankVolumeRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(EfficiencyRpt)">
									<xsl:value-of select="EfficiencyRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(InputRatingRpt)">
									<xsl:value-of select="InputRatingRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ExtInsulRpt)">
									<xsl:value-of select="ExtInsulRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(StandbyLossRpt)">
									<xsl:value-of select="StandbyLossRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(MakeAndModel)">
									<xsl:value-of select="MakeAndModel"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankLocation)">
									<xsl:value-of select="TankLocation"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HERS - WaterHeating-->
	<xsl:template name="EAA_HERS_-_WaterHeating">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12.672)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.191)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.633)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.651)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.929)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Pipe Insulation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Parallel Piping</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Compact Distribution</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Point-of Use</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation with Manual Control</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation with Sensor Control</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5928807">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name)">
									<xsl:value-of select="../Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSAllPipesIns=1">
										<xsl:value-of select="HERSPipeInsRptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSParallelPipe=1">
										<xsl:value-of select="HERSParaPipeRptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSCompact=1">
										<xsl:value-of select="HERSCompactRptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSPointOfUse=1">
										<xsl:value-of select="HERSPOURptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSPushBtnRecirc=1">
										<xsl:value-of select="HERSPushBtnRptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSOccRecirc=1">
										<xsl:value-of select="HERSOccRptMsg"/>
									</xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_WaterHeatingSystems-SingleFamily-->
	<xsl:template name="EAA_WaterHeatingSystems-SingleFamily">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.162)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.742)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(22.615)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.482)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.968)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(6.777)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(6.068)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.186)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Distribution Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heater</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Heaters</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Solar Fraction (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5928522">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name)">
									<xsl:value-of select="../Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DHWSysType)">
									<xsl:value-of select="DHWSysType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DwellUnitDistType)">
									<xsl:value-of select="DwellUnitDistType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DHWHeaterCnt)">
									<xsl:value-of select="DHWHeaterCnt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="hasSolar">
									<xsl:value-of
										select="../SolFracType"
									/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($hasSolar,'none')">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="../SolFracAnnRpt"/>
									</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:if test="string(../SolFracType)">
									<xsl:value-of select="../SolFracType"/>
								</xsl:if>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Status)">
									<xsl:value-of select="../Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../IsVerified =1 and ../IsAltered=1">
										Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>	

	<!--EAA_HVAC Systems-->
	<xsl:template name="EAA_HVAC_Systems">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.603)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.146)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.815)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.815)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.808)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.808)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8.415)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(6.605)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(9.662)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(9.662)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(9.662)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>SPACE CONDITIONING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" padding="2pt" text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" padding="2pt" text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Heating System</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling System</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC"> </fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Ducted</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Ducted</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Distribution System</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan System</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Floor Area Served</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//SDDXML/Model[@Name='Proposed']/HVACSys[FloorAreaServed &gt; 0 and Name=//SDDXML/Model[@Name='Proposed']/Proj/Zone/ActiveHVACSystem]">
					<fo:table-row>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACHeatType" select="Type/text()"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACHeatType,'Other Heating and Cooling System')">
										<xsl:value-of select="HeatSystem"/>
									</xsl:when>
									<xsl:when
										test="contains($HVACHeatType,'Heat Pump Heating and Cooling System')">
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACHeatType2" select="Type/text()"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACHeatType2,'Other Heating and Cooling System')">
										<xsl:if test="HeatDucted='1'">Yes</xsl:if>
										<xsl:if test="HeatDucted='0'">No</xsl:if>
									</xsl:when>
									<xsl:when
										test="contains($HVACHeatType2,'Heat Pump Heating and Cooling System')">
										<xsl:if test="HeatDucted='1'">Yes</xsl:if>
										<xsl:if test="HeatDucted='0'">No</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACCoolType" select="Type/text()"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACCoolType,'Other Heating and Cooling System')">
										<xsl:value-of select="CoolSystem"/>
									</xsl:when>
									<xsl:when
										test="contains($HVACCoolType,'Heat Pump Heating and Cooling System')">
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACCoolType2" select="Type/text()"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACCoolType2,'Other Heating and Cooling System')">
										<xsl:if test="CoolDucted='1'">Yes</xsl:if>
										<xsl:if test="CoolDucted='0'">No</xsl:if>
									</xsl:when>
									<xsl:when
										test="contains($HVACCoolType2,'Heat Pump Heating and Cooling System')">
										<xsl:if test="CoolDucted='1'">Yes</xsl:if>
										<xsl:if test="CoolDucted='0'">No</xsl:if>
									</xsl:when>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DistribSystem/text())">
									<xsl:value-of select="DistribSystem/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Fan/text())">
									<xsl:value-of select="Fan/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(FloorAreaServed/text())">
									<xsl:value-of select="FloorAreaServed/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0"> No </xsl:when>
									<xsl:otherwise>NA</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Heating-->
	<xsl:template name="EAA_HVAC_Heating">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(26.259)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(30.081)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(21.830)" column-number="3"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHeat[Name=preceding-sibling::HVACSys[Name=//Model[@Name='Proposed']/Proj/Zone/ActiveHVACSystem]/HeatSystem]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5930904">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="concat(MinHeatEffic,' ',HeatEfficType)"/>
								<!--<xsl:variable name="isAFUE" select="DisplayAFUE"/>
								<xsl:variable name="hType" select="TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="$isAFUE=1 or $hType='CombHydro'">
										<xsl:value-of select="concat(AFUE,' AFUE')"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Heat Pumps-->
	<xsl:template name="EAA_HVAC_Heat_Pumps">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.353)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.297)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.101)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.832)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.832)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.877)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.877)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING SYSTEMS: Heat Pumps</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cellAC">
						<fo:block>Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HSPF/COP</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cap 47</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cap 17</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>EER</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::HVACSys/HtPumpSystem]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5928755">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(HSPF)">
									<xsl:value-of select="HSPF"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Cap47/text())">
									<xsl:value-of select="Cap47/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Cap17/text())">
									<xsl:value-of select="Cap17/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(SEER)">
									<xsl:value-of select="SEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(EER)">
									<xsl:value-of select="EER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Cooling-V595-->
	<xsl:template name="EAA_HVAC_Cooling-V595">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.650)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.073)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(13.842)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - COOLING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Zonally Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Multi-speed Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]">
					<fo:table-row height="0.174in" overflow="hidden">
						<xsl:variable name="isFirst_id5924148">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<fo:block>
									<xsl:if test="string(TypeRpt)">
										<xsl:value-of select="TypeRpt"/>
									</xsl:if>
								</fo:block>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(EERRpt)">
									<xsl:value-of select="EERRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(SEERRpt)">
									<xsl:value-of select="SEERRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="zonal" select="IsZonal"/>
								<xsl:choose>
									<xsl:when test="$zonal=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="multispeed" select="IsMultiSpeed"/>
								<xsl:choose>
									<xsl:when test="$multispeed=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="cool_name" select="Name"/>
								<xsl:variable name="hers_check"
									select="preceding-sibling::HVACSys[CoolSystem=$cool_name]/Status"/>
								<xsl:choose>
									<xsl:when test="$hers_check !='Existing'">
										<xsl:value-of select="HERSCheck"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HERS Cooling-->
	<xsl:template name="EAA_HERS_Cooling">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.948)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>HVAC COOLING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Airflow</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Airflow Target</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified EER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Refrigerant Charge</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0]/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0]/HtPumpSystem]/HERSCheck]">
					<!--<xsl:for-each select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0 and Status !='Existing']/CoolSystem]/HERSCheck] | //SDDXML/Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::HVACSys[ClFlrAreaServed&gt;0 and Status !='Existing']/HtPumpSystem]/HERSCheck]">-->
					<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
					<fo:table-row>
						<xsl:variable name="isFirst_id5932536">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<!--<xsl:variable name="coolType"select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')"> Not Required </xsl:when>
									<xsl:when test="AHUAirFlow=1"> Required </xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<!--<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')"> ---- </xsl:when>
									<xsl:when test="AHUAirFlow='0'">
										<xsl:call-template name="na"/>								
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="AirFlowRptMsg"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="EER='1'"> Required </xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="$coolType"/>
								<xsl:choose>
									<xsl:when test="SEER='1'"> Required </xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')"> Not Requiredx </xsl:when>
									<xsl:when test="ACCharg=1"> Required </xsl:when>
									<xsl:when test="AltACCharg=1"> Required </xsl:when>
									<xsl:otherwise>Not Requiredx</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Distribution-->
	<xsl:template name="EAA_HVAC_Distribution">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(11.684)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.385)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(9.714)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.271)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.271)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.280)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.892)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9.584)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(11.686)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(8.230)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>HVAC -  DISTRIBUTION SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Leakage</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Insulation R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/HVACDist[FloorAreaServed &gt; 0]">
					<fo:table-row>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DuctLeakage/text()) or string(AltDuctLeakage/text())">
									<xsl:value-of select="DuctLeakage/text() | AltDuctLeakage/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(DuctInsRvalOpt)">
									<xsl:value-of select="DuctInsRvalOpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SupplyRptLocation">
										<xsl:value-of select="SupplyRptLocation"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="SupplyDuctLoc"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="ReturnRptLocation">
										<xsl:value-of select="ReturnRptLocation"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ReturnDuctLoc"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACHasByPass" select="HasBypassDuct"/>
								<xsl:choose>
									<xsl:when test="$HVACHasByPass=1"> Has Bypass Duct </xsl:when>
									<xsl:otherwise> None </xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0"> No </xsl:when>
									<xsl:otherwise>n/a</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="exist_flag" select="IsExisting"/>
								<xsl:variable name="lessthan40">
									<xsl:if test="IsLessThanFortyFt">
										<xsl:value-of select="IsLessThanFortyFt"/>
									</xsl:if>
									<xsl:if test="not(IsLessThanFortyFt)">
										<xsl:text>0</xsl:text>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when
										test="$exist_flag !=1 and ($lessthan40=0 or $lessthan40='')">
										<xsl:value-of select="HERSCheck"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HERS HVAC Distrubution-->
	<xsl:template name="EAA_HERS_HVAC_Distrubution">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.364)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.066)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.764)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(28.177)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.713)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.916)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>HVAC DISTRIBUTION - HERS VERIFICATION</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center"
						font-weight="bold" line-height="115%" padding="2pt" text-align="left">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center"
						font-weight="bold" line-height="115%" padding="2pt" text-align="left">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center"
						font-weight="bold" line-height="115%" padding="2pt" text-align="left">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center"
						font-weight="bold" line-height="115%" padding="2pt" text-align="left">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" text-align="center"
						border="1pt solid black" padding="2pt">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Duct Design</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> Verification</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block><fo:inline> Target</fo:inline> (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[FloorAreaServed&gt;0 and Status = 'New' or (Status ='Existing + New' and IsLessThanFortyFt=0) or Status = 'Altered' and DuctsCreatedForAnalysis=0 ]/HERSCheck]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5924912">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="ductLeak" select="DuctLeakage | AltDuctLeakage"/>
								<xsl:choose>
									<xsl:when test="$ductLeak=1"> Required </xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="ductLeak2" select="DuctLeakage | AltDuctLeakage"/>
								<xsl:choose>
									<xsl:when test="$ductLeak2=1">
										<xsl:value-of select="DuctLkgRptMsg | AltDuctLkgRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="ductLoc" select="DuctLocation"/>
								<xsl:choose>
									<xsl:when test="$ductLoc=1">
										<xsl:value-of select="DuctLocRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="ductRet" select="RetDuctDesign"/>
								<xsl:choose>
									<xsl:when test="$ductRet=1">
										<xsl:value-of select="concat(RetDuctRptMsg,' ft2')"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="ductSup" select="SupDuctDesign"/>
								<xsl:choose>
									<xsl:when test="$ductSup=1">
										<xsl:value-of select="concat(SupDuctRptMsg,' ft2')"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Fans-->
	<xsl:template name="EAA_HVAC_Fans">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(9.262)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.61)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.7)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.596)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - FAN  SYSTEMS &amp; HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0.185in" overflow="hidden" font-weight="bold">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan Power (Watts/CFM)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//SDDXML/Model[@Name='Proposed']/HVACFan[(Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/Fan) and TypeRpt=1 and Status != 'Existing']">
					<fo:table-row>
						<xsl:variable name="isFirst_id5933188">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(WperCFMCool)">
									<xsl:value-of select="WperCFMCool"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="hersfan" select="HERSCheck"/>
								<xsl:variable name="checkfan"
									select="following-sibling::HERSFan[Name=$hersfan]/AHUFanEff"/>
								<xsl:choose>
									<xsl:when test="$checkfan=1">Required </xsl:when>
									<xsl:otherwise> --- </xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--HERS Fan SF-->
	<xsl:template name="HERS_Fan_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cell">
						<fo:block>HVAC FAN SYSTEMS - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Fan Watt Draw</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Required Fan Efficiency (Watts/CFM)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/Fan]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="AHUFanEff='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="string(FanEffRptMsg)">
										<xsl:value-of select="FanEffRptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	

	<!--EAA_Fan IAQ Vent-->
	<xsl:template name="EAA_Fan_IAQ_Vent">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.659)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(21.376)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.807)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(14.822)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.822)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block>IAQ (Indoor Air Quality) FANS </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Fan Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Recovery Effectiveness(%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/IAQVentRpt">
					<fo:table-row>
						<xsl:variable name="isFirst_id5932981">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(round(IAQCFM))">
									<xsl:value-of select="round(IAQCFM)"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(IAQFanType)">
									<xsl:value-of select="IAQFanType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(IAQRecovEffect)">
									<xsl:value-of select="IAQRecovEffect"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="iaq_applies"
									select="sum(//Model[@Name='Proposed']/Proj/Zone[Status='New']/FloorArea)"/>
								<xsl:choose>
									<xsl:when test="$iaq_applies&gt;1000"> Required </xsl:when>
									<!--
												<xsl:when test="//Model[@Name=-'Proposed']/HERSOther/IAQFan=1">
Required
</xsl:when>
-->
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Fan CoolVent-->
	<xsl:template name="EAA_Fan_CoolVent">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.552)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(24.689)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>COOLING VENTILATION </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Vent CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Vent Watts/CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Fans</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/ClVentFan[NumAssignments&gt;0]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5933350">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(CoolingVent)">
									<xsl:value-of select="CoolingVent"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(WperCFMCool)">
									<xsl:value-of select="WperCFMCool"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(NumAssignments)">
									<xsl:value-of select="NumAssignments"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Replaced Components-->
	<xsl:template name="EAA_Replaced_Components">
		<fo:table border-collapse="collapse" width="100%" table-layout="fixed" keep-with-previous.within-page="always">
			<fo:table-column column-width="proportional-column-width(100)" column-number="1"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerRow">
						<fo:block>HERS RATER VERIFICATION OF EXISTING CONDITIONS </fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>  </xsl:template>

	<!--EAA_Opaque Surfaces-Altered-->
	<xsl:template name="EAA_Opaque_Surfaces-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(25.276)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(24.17)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(24.618)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(13.480)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.456)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block>OPAQUE SURFACES - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0.174in" overflow="hidden" font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Existing Construction</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Surface Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Total Cavity R-value</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/IntWall[IsVerified=1]/exConstruction | 
					//Model[@Name='Proposed']/Proj/Zone/CeilingBelowAttic[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/ExteriorFloor[IsVerified=1]/exConstruction | 
					//Model[@Name='Proposed']/Proj/Zone/FloorOverCrawl[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/InteriorFloor[IsVerified=1]/exConstruction | 
					//Model[@Name='Proposed']/Proj/Garage/ExtWall[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Garage/IntWall[IsVerified=1]/exConstruction | 
					//Model[@Name='Proposed']/Proj/Attic[IsVerified=1]/exConstruction | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling[IsVerified=1]/exConstruction">
					<fo:table-row>
						<xsl:variable name="isFirst_id5924110">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name)">
									<xsl:value-of select="../Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="Outside">
										<xsl:value-of select="concat(../Name, '&gt;&gt;',Outside)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="../../Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(.)">
									<xsl:value-of select="."/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="cons1" select=". "/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/Cons[Name=$cons1]/Type"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="cons" select=". "/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/Cons[Name=$cons]/CavityLayer"
								/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Windows-Altered-->
	<xsl:template name="EAA_Windows-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.298)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(18.228)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(5.22)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5.71)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.454)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(5.82)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(6.442)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.203)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(14.061)" column-number="9"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="9">
						<fo:block>FENESTRATION / GLAZING - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>09</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0.200in" overflow="hidden" font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Side of Building</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Width (ft)</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Height (ft)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Multiplier</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>U-factor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SHGC</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Exterior Shading</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[Status='Altered' and IsVerified=1] | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling/Skylt[Status='Altered' and IsVerified=1]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5933053">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Skylt or SpecMethod = 'Overall Window Area'"
										>----</xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(exWidth)) != 'NaN' ">
											<xsl:value-of select="format-number(exWidth,'#.0')"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Skylt or SpecMethod = 'Overall Window Area'">
										---- </xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(exHeight)) != 'NaN' ">
											<xsl:value-of select="format-number(exHeight,'#.0')"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Win">
										<xsl:value-of select="exMultiplier"/>
									</xsl:when>
									<xsl:when test="../Skylt">
										<xsl:value-of select="Multiplier"/>
									</xsl:when>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Win">
										<xsl:value-of
											select="format-number((exArea * exMultiplier), &quot;#.0&quot;)"
										/>
									</xsl:when>
									<xsl:when test="../Skylt">
										<xsl:value-of
											select="format-number((exArea * Multiplier), &quot;#.0&quot;)"
										/>
									</xsl:when>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of
									select="format-number(exNFRCUfactor/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of
									select="format-number(exNFRCSHGC/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:choose>
									<xsl:when test="../Win">
										<xsl:value-of select="exExteriorShade"/>
									</xsl:when>
									<xsl:when test="../Skylt"> None </xsl:when>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Doors-Altered-->
	<xsl:template name="EAA_Doors-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(23.415)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(30.426)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.773)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(11.462)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4">
						<fo:block>OPAQUE DOORS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Side of Building</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>U-factor</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Door[IsVerified=1 and IsAltered=1] | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door[IsVerified=1 and IsAltered=1] | //Model[@Name='Proposed']/Proj/Garage/ExtWall/Door[IsVerified=1 and IsAltered=1]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5935657">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name)">
									<xsl:value-of select="../Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of select="format-number(Area, '0.0')"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of
									select="format-number(exUfactor/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Slab Floor-Altered-->
	<xsl:template name="EAA_Slab_Floor-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(20.755)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.3)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.195)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(15.84)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>SLAB FLOORS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Edge Insul. R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Exposed Surface</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/SlabFloor[IsAltered=1 and IsVerified=1]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5932565">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(../Name)">
									<xsl:value-of select="../Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(exEdgeInsulRValue)">
									<xsl:value-of select="exEdgeInsulRValue"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(exSurface)">
									<xsl:value-of select="exSurface"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_Building Envelope Leakage - Altered-->
	<xsl:template name="EAA_Building_Envelope_Leakage-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(23.740)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(22.040)" column-number="2"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>BUILDING ENVELOPE LEAKAGE - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Verified Existing ACH 50</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Altered ACH 50 Requiring Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/exACH50)">
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/exACH50"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/ACH50)">
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/ACH50"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Systems-Altered-->
	<xsl:template name="EAA_HVAC_Systems-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(11.17)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.796)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.748)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.777)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.029)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(6.201)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.985)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9.228)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(9.507)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(10.559)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>HVAC SYSTEMS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" padding="2pt" text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" border="1pt solid black"
						display-align="center" padding="2pt" text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="" overflow="hidden" font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Heating System</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cooling System</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>
							<fo:block> </fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="" overflow="hidden" font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-style="solid" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-right-color="black" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-width="1pt"
						border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Duct Insulation</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Fan System</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Minumum<fo:block/>Air Flow (CFM)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACSys[Name=preceding-sibling::Proj/Zone[HVACSysStatus='Altered' and HVACSysVerified=1]/exHVACSystem]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5932152">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACHeatType" select="Type"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACHeatType,'Other Heating and Cooling System')">
										<xsl:value-of select="HeatSystem"/>
									</xsl:when>
									<xsl:when
										test="contains($HVACHeatType,'Heat Pump Heating and Cooling System')">
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACHeatType" select="Type"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACHeatType,'Other Heating and Cooling System')">
										<xsl:value-of select="concat(HtSysAFUE,' AFUE')"/>
									</xsl:when>
									<xsl:when
										test="contains($HVACHeatType,'Heat Pump Heating and Cooling System')">
										<xsl:value-of select="concat(HPSysHSPF,' HSPF')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="HVACCoolType" select="Type/text()"/>
								<xsl:choose>
									<xsl:when
										test="contains($HVACCoolType,'Other Heating and Cooling System')">
										<xsl:value-of select="CoolSystem"/>
									</xsl:when>
									<xsl:when
										test="contains($HVACCoolType,'Heat Pump Heating and Cooling System')">
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HtPumpSystem"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ClSysEER)">
									<xsl:value-of select="ClSysEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<fo:block>
									<xsl:if test="string(ClSysSEER)">
										<xsl:value-of select="ClSysSEER"/>
									</xsl:if>
								</fo:block>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="dist" select="DistribSystem"/>
								<xsl:value-of
									select=" concat('R-',//Model[@Name='Proposed']/HVACDist[Name=$dist]/exDuctInsRvalOpt)"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="fan" select="Fan"/>
								<xsl:value-of
									select="concat(following-sibling::HVACFan[Name=$fan]/WperCFMCool,' Watts/CFM')"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ClSysCFMperTon)">
									<xsl:value-of select="ClSysCFMperTon"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--EAA_HVAC Distribution-Altered-->
	<xsl:template name="EAA_HVAC_Distribution-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(11.684)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.385)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(9.714)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.271)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.271)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.280)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.892)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>HVAC DISTRIBUTION SYSTEMS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Duct Leakage</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Insulation R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Supply Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Return Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACDist[Status='Altered' and IsVerified=1]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5936288">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Type/text())">
									<xsl:value-of select="Type/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block><xsl:call-template name="na"/></fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(exDuctInsRvalOpt)">
									<xsl:value-of select="exDuctInsRvalOpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block><xsl:call-template name="na"/></fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block><xsl:call-template name="na"/></fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block><xsl:call-template name="na"/></fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--GEAA_WaterHeatingSystems-SingleFamily-Altered-->
	<xsl:template name="EAA_WaterHeatingSystems-SingleFamily-Altered">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(24.620)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(23.687)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(20.658)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(15.518)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4">
						<fo:block>WATER HEATING SYSTEMS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Distribution Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Number of Heaters</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Solar Fraction (%)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys1Status='Altered' and DHWSys1Verified=1]/exDHWSys1] | //Model[@Name='Proposed']/DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys2Status='Altered' and DHWSys2Verified=1]/exDHWSys2]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5932910">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(SystemType/text())">
									<xsl:value-of select="SystemType/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(NumDHWHeaters * HeaterMult)">
									<xsl:value-of select="NumDHWHeaters * HeaterMult"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:variable name="solfractype" select="SolFracType"/>
								<xsl:choose>
									<xsl:when test="contains($solfractype,'none')">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(SolFracAnnRpt,'.0%')"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(15.08)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(14.509)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(12.654)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.193)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10.789)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.257)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.506)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9.506)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8">
						<fo:block>WATER HEATERS - VERIFIED &amp; ALTERED</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Energy Factor or Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Input Rating</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Tank Exterior Insulation R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Standby Loss (Fraction)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWHeater[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys1Status='Altered' and DHWSys1Verified=1]/exDHWSys1]/DHWHeater] | //Model[@Name='Proposed']/DHWHeater[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone[DHWSys2Status='Altered' and DHWSys2Verified=1]/exDHWSys2]/DHWHeater]">
					<fo:table-row>
						<xsl:variable name="isFirst_id5932467">
							<xsl:choose>
								<xsl:when test="position() = 1">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(HeaterElementType/text())">
									<xsl:value-of select="HeaterElementType/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankType)">
									<xsl:value-of select="TankType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(TankVolume)">
									<xsl:value-of select="TankVolume"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(EnergyFactor)">
									<xsl:value-of select="EnergyFactor"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:value-of
									select="concat(format-number(InputRating,'#,###'),'-' ,InputRatingUnits/text())"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(ExtInsulRVal)">
									<xsl:value-of select="ExtInsulRVal"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
							text-align="center">
							<fo:block>
								<xsl:if test="string(StandbyLossFrac)">
									<xsl:value-of select="StandbyLossFrac"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>  </xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_DHW-MF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_DHW-MF_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.138)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(22.226)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.79)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(14.8)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.326)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(11.227)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.492)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Systems<fo:block/>in Building</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Multi-Family <fo:block/>Distribution Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heater</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Number of <fo:block/>Water Heaters/System</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Solar</fo:block>
						<fo:block>Fraction </fo:block>
						<fo:block>(%)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(SystemType)">
									<xsl:value-of select="SystemType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isCentral" select="CentralDHW"/>
								<xsl:choose>
									<xsl:when test="$isCentral=1">1</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="count(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt)"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(MFamDistType)">
									<xsl:value-of select="MFamDistType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeater)">
									<xsl:value-of select="DHWHeater"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TotNumDHWHeaters)">
									<xsl:value-of select="TotNumDHWHeaters"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(SolFracAnnRpt)">
									<xsl:value-of select="SolFracAnnRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_DHW-SF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_DHW-SF_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(19.111)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(18.386)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(18.386)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(16.035)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.082)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(13.998)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Distribution Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Water Heater</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Heaters</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Solar Fraction (%)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysName)">
									<xsl:value-of select="DHWSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysType)">
									<xsl:value-of select="DHWSysType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DwellUnitDistType)">
									<xsl:value-of select="DwellUnitDistType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterCnt)">
									<xsl:value-of select="DHWHeaterCnt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="solfractype" select="../SolFracType"/>
								<xsl:choose>
									<xsl:when test="contains($solfractype,'none')">
										<xsl:value-of select="$solfractype"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(../SolFracAnnRpt,'.0%')"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_WaterHeaters-SF-2016-V2.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_WaterHeaters-SF-2016-V2_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.35)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.19)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.45)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.652)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.667)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.239)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.878)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(7.466)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(15.382)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(10.724)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row xsl:use-attribute-sets="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heater Element Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Volume (gal)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Energy Factor/Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Input Rating/Pilot</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Insulation R-value (Int/Ext)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Standby Loss (Fraction)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heat Pump Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tank Location or Ambient Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt">
					<xsl:variable name="tankLoc" select="TankLocation"/>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWHeaterRef)">
									<xsl:value-of select="DHWHeaterRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeaterElementType)">
									<xsl:value-of select="HeaterElementType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TankType)">
									<xsl:value-of select="TankType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="TankVolume > 0">
										<xsl:value-of select="TankVolumeRpt"/>
									</xsl:when>
									<xsl:otherwise>NA</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(EfficiencyRpt)">
									<xsl:value-of select="EfficiencyRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(InputRatingRpt)">
									<xsl:value-of select="InputRatingRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(ExtInsulRpt)">
									<xsl:value-of select="ExtInsulRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(StandbyLossRpt)">
									<xsl:value-of select="StandbyLossRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(MakeAndModel)">
									<xsl:value-of select="MakeAndModel"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="normalize-space(string(TankLocation))">
										<xsl:value-of select="TankLocation"/>
									</xsl:when>
									<xsl:otherwise>NA</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_HERS _DHW-SF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_HERS__DHW-SF_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12.672)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(12.191)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.633)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.651)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.929)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.987)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>WATER HEATING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Pipe Insulation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Parallel Piping</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Compact Distribution</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Point-of Use</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Recirculation Control</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Central DHW Distribution</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt | //Model[@Name='Proposed']/DHWSys/DHWSysRpt">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysName)">
									<xsl:value-of select="DHWSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSAllPipesIns=1">
										<xsl:value-of select="HERSPipeInsRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSParallelPipe=1">
										<xsl:value-of select="HERSParaPipeRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSCompact=1">
										<xsl:value-of select="HERSCompactRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HERSPointOfUse=1">
										<xsl:value-of select="HERSPOURptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSPushBtnRecirc=1">
										<xsl:value-of select="HERSPushBtnRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSOccRecirc=1">
										<xsl:value-of select="HERSOccRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSMFNoControl=1">
										<xsl:value-of select="HERSMFNoCtrlRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFDemandControl=1">
										<xsl:value-of select="HERSMFDCRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFTempMod=1">
										<xsl:value-of select="HERSMFTmpModRptMsg"/>
									</xsl:when>
									<xsl:when test="HERSMFTempModMon=1">
										<xsl:value-of select="HERSMFTmpModMonRptMsg"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Space Conditioning Systems - SF -->
	<xsl:template name="SC_Systems_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(15)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(15)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>SPACE CONDITIONING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SC Sys Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heating Unit Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Unit Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Distribution Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Status</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Existing Condition</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/HVACSys[FloorAreaServed>0]">
					<!--<xsl:variable name="scSysName" select="Name"/>
					<xsl:variable name="hvacSys"
						select="../following-sibling::HVACSys[SCSysRptRef=$scSysName]/Name"/>
					<xsl:variable name="heatUnit" select="HeatSystem | HtPumpSystem"/>
					<xsl:variable name="coolUnit" select="CoolSystem | HtPumpSystem"/>
					<xsl:variable name="heatUnitIndex">
						<xsl:value-of
							select="../following-sibling::HVACSys[Name=$hvacSys]/HeatSystem[text()=$heatUnit]/@index | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystem[text()=$heatUnit]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="coolUnitIndex">
						<xsl:value-of
							select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystem[text()=$coolUnit]/@index | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystem[text()=$coolUnit]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="heatUnitCnt">
						<xsl:value-of
							select="../following-sibling::HVACSys[Name=$hvacSys]/HeatSystemCount[@index=$heatUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$heatUnitIndex]"
						/>
					</xsl:variable>
					<xsl:variable name="coolUnitCnt">
						<xsl:value-of
							select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystemCount[@index=$coolUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$coolUnitIndex]"
						/>
					</xsl:variable>-->
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="Name"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="Type"/>
								<!--<xsl:variable name="systype" select="SCSysTypeVal"/>
								<xsl:choose>
									<xsl:when test="$systype=1">Other Heating and Cooling
										System</xsl:when>
									<xsl:when test="$systype=2">Heat Pump Heating and Cooling
										System</xsl:when>
									<xsl:when test="$systype=3">Variable Outdoor Air Ventilation
										Central Heat/Cool System</xsl:when>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="HeatSystem">
										<xsl:for-each select="HeatSystem">
											<xsl:variable name="heatSysIndex" select="./@index"/>
											<!-- list start -->
											<fo:list-block>
												<!-- list item -->
												<fo:list-item>
													<!-- insert a bullet -->
													<fo:list-item-label end-indent="label-end()">
														<fo:block>
															<xsl:text/>
														</fo:block>
													</fo:list-item-label>
													<!-- list text -->
													<fo:list-item-body start-indent="0">
														<fo:block>
															<xsl:value-of select="current()"/>
															<!--<xsl:value-of select="concat('  ' ,current(),' (',../HeatSystemCount[@index=$heatSysIndex],')')"/>-->
														</fo:block>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:for-each>
										<!--<xsl:value-of
											select="concat($heatUnit, ' (',$heatUnitCnt,')')"/>-->
									</xsl:when>
									<xsl:when test="HtPumpSystem">
										<xsl:for-each select="HtPumpSystem">
											<xsl:variable name="heatSysIndex" select="./@index"/>
											<!-- list start -->
											<fo:list-block>
												<!-- list item -->
												<fo:list-item>
													<!-- insert a bullet -->
													<fo:list-item-label end-indent="label-end()">
														<fo:block>
															<xsl:text/>
														</fo:block>
													</fo:list-item-label>
													<!-- list text -->
													<fo:list-item-body start-indent="0">
														<fo:block>
															<xsl:value-of select="current()"/>
															<!--<xsl:value-of select="concat('  ' ,current(),' (',../HtPumpSystemCount[@index=$heatSysIndex],')')"/>-->
														</fo:block>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:for-each>
										<!--<xsl:value-of
											select="concat($heatUnit, ' (',$heatUnitCnt,')')"/>-->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolSystem">
										<xsl:for-each select="CoolSystem">
											<xsl:variable name="heatSysIndex" select="./@index"/>
											<!-- list start -->
											<fo:list-block>
												<!-- list item -->
												<fo:list-item>
													<!-- insert a bullet -->
													<fo:list-item-label end-indent="label-end()">
														<fo:block>
															<xsl:text/>
														</fo:block>
													</fo:list-item-label>
													<!-- list text -->
													<fo:list-item-body start-indent="0">
														<fo:block>
															<xsl:value-of select="current()"/>
															<!--<xsl:value-of select="concat('  ' ,current(),' (',../CoolSystemCount[@index=$heatSysIndex],')')"/>-->
														</fo:block>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:for-each>
										<!--<xsl:value-of
											select="concat($coolUnit, ' (',$coolUnitCnt,')')"/>-->
									</xsl:when>
									<xsl:when test="HtPumpSystem">
										<xsl:for-each select="HtPumpSystem">
											<xsl:variable name="heatSysIndex" select="./@index"/>
											<!-- list start -->
											<fo:list-block>
												<!-- list item -->
												<fo:list-item>
													<!-- insert a bullet -->
													<fo:list-item-label end-indent="label-end()">
														<fo:block>
															<xsl:text/>
														</fo:block>
													</fo:list-item-label>
													<!-- list text -->
													<fo:list-item-body start-indent="0">
														<fo:block>
															<xsl:value-of select="current()"/>
															<!--<xsl:value-of select="concat('  ' ,current(),' (',../HtPumpSystemCount[@index=$heatSysIndex],')')"/>-->
														</fo:block>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:for-each>
										<!--<xsl:value-of
											select="concat($coolUnit, ' (',$coolUnitCnt,')')"/>-->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="Fan">
										<xsl:value-of select="Fan"/>
									</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DistribSystem">
										<xsl:value-of select="DistribSystem"/>
									</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Status)">
									<xsl:value-of select="Status"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="item" select="."/>
								<xsl:variable name="verify" select="./IsVerified"/>
								<xsl:choose>
									<xsl:when test="$verify=1"> Yes </xsl:when>
									<xsl:when test="$verify=0"> No </xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--MultiFamily_SC_Systems-->
	<xsl:template name="SC_Systems_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(25.536)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.235)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(15.235)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(15.235)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(15.070)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(13.689)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>SPACE CONDITIONING SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>SC Sys Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heating Unit Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Unit Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Distribution Name</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<!--
				//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(substring-after(Name/text(),'|')=preceding::SCSysRpt[not(substring-after(Name/text(),'|'))])]
				
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[substring-after(Name,'|') and not(preceding-sibling::SCSysRpt[substring-after(Name,'|')])]">
				
					<xsl:when test="count(preceding::*[./@fn = current()/@fn]) = 0">\footnote{...}
					
				<xsl:for-each select="/books/book">
    <xsl:if test="self::node()[text()='1112']">
        Success
    </xsl:if>
</xsl:for-each>
				-->
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt">
					<xsl:variable name="scSysHvacName">
						<xsl:value-of select="substring-after(Name/text(),'|')"/>
					</xsl:variable>
					<xsl:if
						test="not($scSysHvacName = preceding-sibling::SCSysRpt[substring-after(Name,'|')])">


						<xsl:variable name="scSysName" select="Name"/>
						<xsl:variable name="hvacSys"
							select="../following-sibling::HVACSys[SCSysRptRef=$scSysName]/Name"/>
						<xsl:variable name="heatUnit" select="HeatSystem | HtPumpSystem"/>
						<xsl:variable name="coolUnit" select="CoolSystem | HtPumpSystem"/>
						<xsl:variable name="heatUnitIndex">
							<xsl:value-of
								select="../following-sibling::HVACSys[Name=$hvacSys]/HeatSystem[text()=$heatUnit]/@index | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystem[text()=$heatUnit]/@index"
							/>
						</xsl:variable>
						<xsl:variable name="coolUnitIndex">
							<xsl:value-of
								select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystem[text()=$coolUnit]/@index | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystem[text()=$coolUnit]/@index"
							/>
						</xsl:variable>
						<xsl:variable name="heatUnitCnt">
							<xsl:value-of
								select="../following-sibling::HVACSys[Name=$hvacSys]/HeatSystemCount[@index=$heatUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$heatUnitIndex]"
							/>
						</xsl:variable>
						<xsl:variable name="coolUnitCnt">
							<xsl:value-of
								select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystemCount[@index=$coolUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$coolUnitIndex]"
							/>
						</xsl:variable>
						<fo:table-row>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:value-of select="Name"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:variable name="systype" select="SCSysTypeVal"/>
									<xsl:choose>
										<xsl:when test="$systype=1">Other Heating and Cooling
											System</xsl:when>
										<xsl:when test="$systype=2">Heat Pump Heating and Cooling
											System</xsl:when>
										<xsl:when test="$systype=3">Variable Outdoor Air Ventilation
											Central Heat/Cool System</xsl:when>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:choose>
										<xsl:when test="HeatSystem">
											<xsl:value-of select="$heatUnit"/>
										</xsl:when>
										<xsl:when test="HtPumpSystem">
											<xsl:value-of select="$heatUnit"/>
										</xsl:when>
										<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:choose>
										<xsl:when test="CoolSystem">
											<xsl:value-of select="$coolUnit"/>
										</xsl:when>
										<xsl:when test="HtPumpSystem">
											<xsl:value-of select="$coolUnit"/>
										</xsl:when>
										<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:choose>
										<xsl:when test="HVACFanRef">
											<xsl:value-of select="HVACFanRef"/>
										</xsl:when>
										<xsl:otherwise>None</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:choose>
										<xsl:when test="HVACDistRef">
											<xsl:value-of select="HVACDistRef"/>
										</xsl:when>
										<xsl:otherwise>None</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--<!-\- Template with HVACSys node set -\->
	<xsl:template match="HVACSys"> </xsl:template>-->

	<!--Heating Units - SF - NOT USED-->
	<xsl:template name="HVAC_Heat_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(26.259)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(30.081)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(21.830)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHeat[Name=preceding-sibling::Proj/SCSysRpt/HeatSystem and not(preceding-sibling::SCSysRpt/HeatSystem)]">
					<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>
					<xsl:variable name="heatSysName" select="Name"/>
					<xsl:variable name="heatUnitIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys/HeatSystem[text()=$heatSysName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="sysCount">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys/HeatSystemCount[@index=$heatUnitIndex]"
						/>
					</xsl:variable>
					<!-- Setup retrieval -->
					<!--<xsl:variable name="scSysRptName" select="preceding-sibling::Proj/SCSysRpt/Name and not(preceding-sibling::SCSysRpt/Name)"/>
					<xsl:variable name="hvacSysName" select="../preceding-sibling::HVACSys[SCSysRptRef=$scSysName]/Name" />
					
					<xsl:variable name="heatUnit" select="HeatSystem | HtPumpSystem" />
					<xsl:variable name="coolUnit" select="CoolSystem | HtPumpSystem" />
					
					<xsl:variable name="coolUnitIndex">
						<xsl:value-of select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystem[text()=$coolUnit]/@index | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystem[text()=$coolUnit]/@index" />
					</xsl:variable>
					<xsl:variable name="heatUnitCnt">
						<xsl:value-of select="../following-sibling::HVACSys[Name=$hvacSys]/HeatSystemCount[@index=$heatUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$heatUnitIndex]"/>
					</xsl:variable>
					<xsl:variable name="coolUnitCnt">
						<xsl:value-of select="../following-sibling::HVACSys[Name=$hvacSys]/CoolSystemCount[@index=$coolUnitIndex] | ../following-sibling::HVACSys[Name=$hvacSys]/HtPumpSystemCount[@index=$coolUnitIndex]"/>
					</xsl:variable>-->
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="$heatSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<xsl:call-template name="GetHeatSysCount">
							<xsl:with-param name="heatName" select="$heatSysName"/>
							<xsl:with-param name="isMultiFamily" select="$isMF"/>
							<xsl:with-param name="hvacSysCnt" select="$sysCount"/>
						</xsl:call-template>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isAFUE" select="DisplayAFUE"/>
								<xsl:variable name="hType" select="TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="$isAFUE=1 or $hType='CombHydro'">
										<xsl:value-of select="concat(AFUE,' AFUE')"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Heating Units - SF-->
	<xsl:template name="HVAC_Heat_SF2">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(26.259)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(30.081)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(21.830)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal !=2]">
					<!--<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>-->
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="hvacSysName">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/Name"
						/>
					</xsl:variable>
					<xsl:variable name="scSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$hvacSysName]/SCSysRptRef[text()=$scSysRptName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="scSysRptCount">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$hvacSysName]/SCSysRptCount[@index=$scSysIndex]"
						/>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<!--<xsl:value-of select="concat(HeatSystem,'-',$hvacSysName,'-',$scSysIndex)"/>-->
									<xsl:value-of select="HeatSystem"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeatingType)">
									<xsl:value-of select="HeatingType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$scSysRptCount"/>
								<!--<xsl:value-of select="HeatSystem"/>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="isAFUE" select="DisplayAFUE"/>
								<xsl:variable name="hType" select="TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="$isAFUE=1 or $hType='CombHydro'">-->
								<xsl:value-of select="concat(MinHeatEffic,' AFUE')"/>
								<!--</xsl:when>
									<xsl:otherwise>-\-\-</xsl:otherwise>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Heating Units - SF-->
	<xsl:template name="HVAC_Heat_SF3">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(26.259)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(30.081)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(21.830)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal !=2]">
					<!--<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>-->
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="heatSysName" select="HeatSystem"/>
					<xsl:variable name="heatSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/HeatSystem[text()=$heatSysName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="heatSysCount">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/HeatSystemCount[@index=$heatSysIndex]"
						/>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<!--<xsl:value-of select="concat(HeatSystem,'-',$heatSysName,'-',$heatSysIndex)"/>-->
									<xsl:value-of select="$heatSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeatingType)">
									<xsl:value-of select="HeatingType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$heatSysCount"/>
								<!--<xsl:value-of select="HeatSystem"/>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="isAFUE" select="DisplayAFUE"/>
								<xsl:variable name="hType" select="TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="$isAFUE=1 or $hType='CombHydro'">-->
								<xsl:value-of select="concat(MinHeatEffic,' AFUE')"/>
								<!--</xsl:when>
									<xsl:otherwise>-\-\-</xsl:otherwise>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--GetHeatCount-->
	<xsl:template name="GetHeatSysCount">
		<xsl:param name="heatName"/>
		<xsl:param name="isMultiFamily"/>
		<xsl:param name="heatSysCnt"/>
		<xsl:param name="unitCount"/>
		<xsl:choose>
			<xsl:when test="$isMultiFamily=1">
				<fo:table-cell xsl:use-attribute-sets="numberCell">
					<fo:block>
						<xsl:value-of
							select="count(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[HeatSystem=$heatName]) * $unitCount"
						/>
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-cell xsl:use-attribute-sets="numberCell">
					<fo:block>
						<xsl:value-of select="concat($heatName,'-',$isMultiFamily,'-',$heatSysCnt)"/>
						<!--<xsl:value-of
							select="count(//Model[@Name='Proposed']/Proj/SCSysRpt[HeatSystem=$heatName]) * $heatSysCnt"
						/>-->
					</fo:block>
				</fo:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Heating Units - MF-->
	<xsl:template name="HVAC_Heat_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(26.259)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(30.081)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(21.830)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEATING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHeat[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HeatSystem and not(preceding-sibling::SCSysRpt/HeatSystem)]">
					<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>
					<xsl:variable name="heatSys" select="Name"/>
					<xsl:variable name="dwellUnitTypeName"
						select="preceding-sibling::Proj/Zone/DwellUnit[SCSysRpt/HeatSystem=$heatSys]/DwellUnitTypeRef"/>
					<xsl:variable name="heatUnitIndex"
						select="//Model[@Name='Proposed']/DwellUnitType[Name=$dwellUnitTypeName]/HVACHeatRef[text()=$heatSys]/@index"/>
					<xsl:variable name="heatUnitCount"
						select="//Model[@Name='Proposed']/DwellUnitType[Name=$dwellUnitTypeName]/HeatEquipCount[@index=$heatUnitIndex]"/>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="$heatSys"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<xsl:call-template name="GetHeatSysCount">
							<xsl:with-param name="heatName" select="$heatSys"/>
							<xsl:with-param name="isMultiFamily" select="$isMF"/>
							<xsl:with-param name="unitCount" select="$heatUnitCount"/>
						</xsl:call-template>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isAFUE" select="DisplayAFUE"/>
								<xsl:variable name="hType" select="TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="$isAFUE=1 or $hType='CombHydro'">
										<xsl:value-of select="concat(AFUE,' AFUE')"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Heat Pump SF-->
	<xsl:template name="HVAC_HP_SF2">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.234)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(21.022)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.712)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.712)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.609)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(5.914)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.995)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.09)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(7.933)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(8.965)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(14.525)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEAT PUMPS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block>System</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Number of</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Units</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HSPF/COP</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Cap 47</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cap 17</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal=2]">
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="htPumpName" select="HtPumpSystem"/>
					<xsl:variable name="heatPumpSysName">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/Name"
						/>
					</xsl:variable>
					<xsl:variable name="scSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$heatPumpSysName]/SCSysRptRef[text()=$scSysRptName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="scSysRptCount">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$heatPumpSysName]/SCSysRptCount[@index=$scSysIndex]"
						/>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$htPumpName"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HeatingType)">
									<xsl:value-of select="HeatingType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$scSysRptCount"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="MinHeatEffic"/>

							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HtPumpCap47)">
									<xsl:value-of select="HtPumpCap47"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HtPumpCap17)">
									<xsl:value-of select="HtPumpCap17"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(MinCoolSEER)">
									<xsl:value-of select="MinCoolSEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(MinCoolEER)">
									<xsl:value-of select="MinCoolEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="ZonalCoolingType"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="CoolCompType"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hp_name" select="Name"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACHtPump[Name=$htPumpName]/HERSCheck"
								/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Heat Pump SF NOT USED-->
	<xsl:template name="HVAC_HP_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.234)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(21.022)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.712)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.712)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.609)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(5.914)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.995)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.09)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(7.933)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(8.965)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(14.525)" column-number="11"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="11" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEAT PUMPS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>11</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Number of</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Multispeed</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Units</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HSPF/COP</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Cap 47</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cap 17</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]">

					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TypeAbbrevStr)">
									<xsl:value-of select="TypeAbbrevStr"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TypeAbbrevStr)">
									<xsl:value-of select="TypeAbbrevStr"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HSPF)">
									<xsl:value-of select="HSPF"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Cap47)">
									<xsl:value-of select="Cap47"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Cap17)">
									<xsl:value-of select="Cap17"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(SEER)">
									<xsl:value-of select="SEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(EER)">
									<xsl:value-of select="EER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="IsZonal=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hp_sys" select="../HtPumpSystem"/>
								<xsl:variable name="multi_flag"
									select="//Model[@Name='Proposed']/HVACHtPump[Name=$hp_sys]/IsMultiSpeed"/>
								<xsl:choose>
									<xsl:when test="$multi_flag=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hp_name" select="Name"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACHtPump[Name=$hp_name]/HERSCheck"
								/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Heat Pump MF-->
	<xsl:template name="HVAC_HP_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.234)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(21.022)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.712)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5.609)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.914)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(5.995)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.09)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(7.933)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8.965)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(14.525)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - HEAT PUMPS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="3" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Multispeed</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" overflow="hidden">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HSPF/COP</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Cap 47</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Cap 17</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(TypeAbbrevStr)">
									<xsl:value-of select="TypeAbbrevStr"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HSPF)">
									<xsl:value-of select="HSPF"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Cap47)">
									<xsl:value-of select="Cap47"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Cap17)">
									<xsl:value-of select="Cap17"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(SEER)">
									<xsl:value-of select="SEER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(EER)">
									<xsl:value-of select="EER"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="IsZonal=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hp_sys" select="../HtPumpSystem"/>
								<xsl:variable name="multi_flag"
									select="//Model[@Name='Proposed']/HVACHtPump[Name=$hp_sys]/IsMultiSpeed"/>
								<xsl:choose>
									<xsl:when test="$multi_flag=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hp_name" select="Name"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACHtPump[Name=$hp_name]/HERSCheck"
								/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--GetCoolCount-->
	<xsl:template name="GetCoolSysCount">
		<xsl:param name="coolName"/>
		<xsl:param name="isMultiFamily"/>
		<xsl:param name="coolSysCnt"/>
		<xsl:param name="unitCount"/>
		<xsl:choose>
			<xsl:when test="$isMultiFamily=1">
				<fo:table-cell xsl:use-attribute-sets="numberCell">
					<fo:block>
						<xsl:value-of
							select="count(//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[CoolSystem=$coolName]) * $unitCount"
						/>
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-cell xsl:use-attribute-sets="numberCell">
					<fo:block>
						<xsl:value-of
							select="count(//Model[@Name='Proposed']/Proj/SCSysRpt[CoolSystem=$coolName])"
						/>
					</fo:block>
				</fo:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--HVAC Cool Not HP SF-->
	<xsl:template name="HVAC_Cool_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.650)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.073)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.707)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.500)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(6.500)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - COOLING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Compressor Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(contains(CoolingType,'HeatPump'))]">
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="hvacSysName">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/Name"
						/>
					</xsl:variable>
					<xsl:variable name="scSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$hvacSysName]/SCSysRptRef[text()=$scSysRptName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="scSysRptCount">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[Name=$hvacSysName]/SCSysRptCount[@index=$scSysIndex]"
						/>
					</xsl:variable>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CoolSystem)">
									<xsl:value-of select="CoolSystem"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CoolingType)">
									<xsl:value-of select="CoolingType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$scSysRptCount"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolEER">
										<xsl:value-of select="MinCoolEER"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolSEER">
										<xsl:value-of select="MinCoolSEER"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ZonalCoolingType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="CoolCompType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolSys" select="CoolSystem"/>
								<xsl:variable name="hersCount"
									select="count(//Model[@Name='Proposed']/HVACCool/HERSCheck)"/>
								<xsl:variable name="coolingType" select="CoolingType"/>
								<xsl:choose>
									<xsl:when test="$isMF=1 and $hersCount&gt;1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:when>
									<xsl:when test="$coolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--HVAC Cool Not HP SF-->
	<xsl:template name="HVAC_Cool_SF2">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.650)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.073)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.707)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.500)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(6.500)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - COOLING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Compressor Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(contains(CoolingType,'HeatPump')) and CoolSystem]">
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="coolSysName" select="CoolSystem"/>
					<xsl:variable name="coolSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/CoolSystem[text()=$coolSysName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="coolSysCount">
						<xsl:value-of select="ReferenceCount"/>
					</xsl:variable>
					<!--<xsl:variable name="coolSysCount">
						<xsl:value-of select="sum(//Model[@Name='Proposed']/HVACSys/CoolSystemCount[@index=$coolSysIndex and ../CoolSystem=$coolSysName])"	/>
					</xsl:variable>-->
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name)">
									<xsl:value-of select="$coolSysName"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CoolingType)">
									<xsl:value-of select="CoolingType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$coolSysCount"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolEER">
										<xsl:value-of select="MinCoolEER"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolSEER">
										<xsl:value-of select="MinCoolSEER"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ZonalCoolingType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="CoolCompType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolSys" select="CoolSystem"/>
								<xsl:variable name="hersCount"
									select="count(//Model[@Name='Proposed']/HVACCool/HERSCheck)"/>
								<xsl:variable name="coolingType" select="CoolingType"/>
								<xsl:choose>
									<xsl:when test="$isMF=1 and $hersCount&gt;1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:when>
									<xsl:when test="$coolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Cool Not HP MF-->
	<xsl:template name="HVAC_Cool_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(16.650)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.073)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.000)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10.00)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(12.260)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(13.655)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - COOLING UNIT TYPES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Zonally Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell number-rows-spanned="2" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Multi-speed Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" border-top-color="black"
						border-top-style="solid" border-top-width="1pt" display-align="after"
						padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>System Type</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Number of Units</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>EER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<!-- //Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(contains(CoolingType,'HeatPump'))] -->
				<!-- //Model[@Name='Proposed']/HVACHeat[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HeatSystem and not(preceding-sibling::SCSysRpt/HeatSystem)] -->
				<xsl:for-each
					select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem and not(preceding-sibling::SCSysRpt/CoolSystem)]">
					<!-- Setup retrieval -->
					<xsl:variable name="coolSys" select="Name"/>
					<xsl:variable name="dwellUnitTypeName"
						select="preceding-sibling::Proj/Zone/DwellUnit[SCSysRpt/CoolSystem=$coolSys]/DwellUnitTypeRef"/>
					<xsl:variable name="coolUnitIndex"
						select="//Model[@Name='Proposed']/DwellUnitType[Name=$dwellUnitTypeName]/HVACCoolRef[text()=$coolSys]/@index"/>
					<xsl:variable name="coolUnitCount"
						select="//Model[@Name='Proposed']/DwellUnitType[Name=$dwellUnitTypeName]/CoolEquipCount[@index=$coolUnitIndex]"/>
					<!--<xsl:variable name="dwellUnitName" select="../preceding-sibling::Proj/Zone/DwellUnit/DwellUnitTypeRef and not(../preceding-sibling::Proj/Zone/DwellUnit/DwellUnitTypeRef)"/>-->
					<!--<xsl:variable name="dwellUnitName"
						select="preceding::Proj/Zone/DwellUnit/DwellUnitTypeRef/text()"/>
					<xsl:variable name="coolUnitName" select="Name"/>
					<xsl:variable name="coolUnitIndex"
						select="preceding::DwellUnitType[Name=$dwellUnitName]/HVACCoolRef[text()=$coolUnitName]/@index"/>
					<xsl:variable name="coolUnitCnt"
						select="preceding::DwellUnitType[Name=$dwellUnitName]/CoolEquipCount[@index=$coolUnitIndex]/text()"/>
					<xsl:variable name="numUnits"
						select="preceding::DwellUnitType[Name=$dwellUnitName]/NumAssigningDUs"/>-->
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$coolSys"/>
								<!--<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Type)">
									<xsl:value-of select="Type"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<xsl:call-template name="GetCoolSysCount">
							<xsl:with-param name="coolName" select="$coolSys"/>
							<xsl:with-param name="isMultiFamily" select="$isMF"/>
							<xsl:with-param name="unitCount" select="$coolUnitCount"/>
						</xsl:call-template>
						<!--<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="$coolUnitCnt * $numUnits"/>
							</fo:block>
						</fo:table-cell>-->
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="EERRpt">
										<xsl:value-of select="EERRpt"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SEERRpt">
										<xsl:value-of select="SEERRpt"/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:when test="IsZonal=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:when test="IsMultiSpeed=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="coolSys" select="CoolSystem"/>-->
								<xsl:variable name="hersCount"
									select="count(//Model[@Name='Proposed']/HVACCool/HERSCheck)"/>
								<xsl:variable name="coolingType" select="CoolingType"/>
								<xsl:choose>
									<xsl:when test="$isMF=1 and $hersCount&gt;1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:when>
									<xsl:when test="$coolingType='NoCooling'"><xsl:call-template name="na"/></xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACCool[Name=$coolSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERS Cool SF-->
	<xsl:template name="HERS_Cool_SF">
		<!-- Variable to toggle special verification note for HERS -->
		<xsl:variable name="altChrgNote" select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck]/AltACCharg | 
			//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/AltACCharg"/>		
		
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.948)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>HVAC COOLING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Airflow</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Airflow Target</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified EER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Refrigerant Charge</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]">
					<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt | //Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/HtPumpSystem]/TypeAbbrev"/>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="AHUAirFlow='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling') or contains($coolType,'DuctlessHeatPump')">----</xsl:when>
									<xsl:when test="AHUAirFlow=0">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="AirFlowRptMsg"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="EER='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="SEER='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<!--<xsl:variable name="coolType" select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt | //Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/HtPumpSystem]/TypeAbbrev"/>-->
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not Required</xsl:when>
									<xsl:when test="ACCharg='1'">Required</xsl:when>
									<xsl:when test="AltACCharg='1'">Required*</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
		<xsl:if test="$altChrgNote=1">
			<fo:block keep-with-previous="always" xsl:use-attribute-sets="lastBlockBelowTable"
			><fo:inline xsl:use-attribute-sets="sup6">*</fo:inline>Refrigerant Charge verification required if a refrigerant containing component is altered</fo:block>
		<!--<fo:block xsl:use-attribute-sets="lastBlockBelowTable"><fo:inline
			xsl:use-attribute-sets="sup6">3</fo:inline>Lighting information for existing
			spaces modeled is not included in the table</fo:block>-->
		</xsl:if>
		
	</xsl:template>

	<!--HERS Cool SM-->
	<xsl:template name="HERS_Cool_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.948)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(7.956)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>HVAC COOLING - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Airflow</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Airflow Target</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified EER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified SEER</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Refrigerant Charge</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="AHUAirFlow='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt | //Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/HtPumpSystem]/TypeAbbrev"/>
								<xsl:choose>
									<xsl:when
										test="contains($coolType,'NoCooling') or contains($coolType,'DuctlessHeatPump')"
										>----</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="AirFlowRptMsg"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="EER='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="SEER='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt | //Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/HtPumpSystem]/TypeAbbrev"/>
								<xsl:choose>
									<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>
									<xsl:when test="ACCharg='1'">Required</xsl:when>
									<xsl:when test="AltACCharg='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Dist - No Design SF-->
	<xsl:template name="HVAC_Dist_NoDesign_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.058)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(14.959)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.857)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.362)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10.362)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.659)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.710)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>HVAC -  DISTRIBUTION SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Leakage</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Insulation R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)] | //Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACDistRef)">
									<xsl:value-of select="HVACDistRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DistribType)">
									<xsl:value-of select="DistribType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctLeakage or //Model[@Name='Proposed']/HVACDist[Name=$ductSys]/AltDuctLeakage"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctInsRvalue"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DuctLocationRpt)">
									<xsl:value-of select="DuctLocationRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="HVACHasByPass"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HasBypassDuct"/>
								<xsl:choose>
									<xsl:when test="$HVACHasByPass=1">Has Bypass Duct</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Dist - No Design MF-->
	<xsl:template name="HVAC_Dist_NoDesign_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13.058)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(14.959)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.857)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.362)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(10.362)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.659)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.710)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>HVAC -  DISTRIBUTION SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Leakage</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Insulation R-value</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Location</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)] | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACDistRef)">
									<xsl:value-of select="HVACDistRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DistribType)">
									<xsl:value-of select="DistribType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctLeakage"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctInsRvalue"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DuctLocationRpt)">
									<xsl:value-of select="DuctLocationRpt"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="HVACHasByPass"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HasBypassDuct"/>
								<xsl:choose>
									<xsl:when test="$HVACHasByPass=1">Has Bypass Duct</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Dist - Design SF-->
	<xsl:template name="HVAC_Dist_Design_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(11.908)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.642)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(9.901)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.449)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.449)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.459)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(9.767)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>HVAC -  DISTRIBUTION SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Duct Insulation R-value</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-bottom-color="black"
						border-bottom-width="1pt" xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Location </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Surface Area</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-width="1pt"
						xsl:use-attribute-sets="cellAC">
						<fo:block>Supply </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-width="1pt"
						xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACDistRef)">
									<xsl:value-of select="HVACDistRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DistribType)">
									<xsl:value-of select="DistribType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="HERSRetDuctDesign=1 or HERSSupDuctDesign=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctInsRvalue"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/RetDuctInsRvalue"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyRptLocation"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnRptLocation"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="sdArea"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyDuctArea"/>
								<xsl:choose>
									<xsl:when test="$sdArea&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyDuctArea"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="rdArea"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnDuctArea"/>
								<xsl:choose>
									<xsl:when test="$rdArea&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnDuctArea"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="HVACHasByPass"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HasBypassDuct"/>
								<xsl:choose>
									<xsl:when test="$HVACHasByPass=1">Has Bypass Duct</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Dist - Design MF-->
	<xsl:template name="HVAC_Dist_Design_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(11.908)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.642)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(9.901)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.449)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.449)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.459)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8.808)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(9.767)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>HVAC -  DISTRIBUTION SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>09</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>10</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Duct Insulation R-value</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border-bottom-color="black"
						border-bottom-width="1pt" xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Location </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cellAC">
						<fo:block>Duct Surface Area</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-width="1pt"
						xsl:use-attribute-sets="cellAC">
						<fo:block>Supply </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-width="1pt"
						xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Supply</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Return</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Bypass Duct</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(preceding::SCSysRpt/HVACDistRef=HVACDistRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACDistRef)">
									<xsl:value-of select="HVACDistRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DistribType)">
									<xsl:value-of select="DistribType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="HERSRetDuctDesign=1 or HERSSupDuctDesign=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/DuctInsRvalue"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/RetDuctInsRvalue"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyRptLocation"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnRptLocation"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="sdArea"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyDuctArea"/>
								<xsl:choose>
									<xsl:when test="$sdArea&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/SupplyDuctArea"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="rdArea"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnDuctArea"/>
								<xsl:choose>
									<xsl:when test="$rdArea&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/ReturnDuctArea"
										/>
									</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:variable name="HVACHasByPass"
									select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HasBypassDuct"/>
								<xsl:choose>
									<xsl:when test="$HVACHasByPass=1">Has Bypass Duct</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="ductSys" select="HVACDistRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACDist[Name=$ductSys]/HERSCheck"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERS Dist SF-->
	<xsl:template name="EAA_HERS_Dist_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.605)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.426)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.11)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.29)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.207)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.957)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.26)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.56)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC DISTRIBUTION - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Verified Duct</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Verified Duct </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Deeply Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Low-leakage</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block> Verification</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block><fo:inline> Target</fo:inline> (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Location</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						display-align="after" padding="2pt" text-align="center">
						<fo:block><fo:inline>Design</fo:inline> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Air Handler</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef and DuctsCreatedForAnalysis=0]/HERSCheck]">
					<xsl:variable name="thisName" select="Name"/>
					<xsl:variable name="lldcs"
						select="//Model[@Name='Proposed']/HVACDist[HERSCheck=$thisName]/TypeAbbrev"/>
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">Required</xsl:when>
									<xsl:when test="AltDuctLeakage=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">
										<xsl:value-of select="DuctLkgRptMsg"/>
									</xsl:when>
									<xsl:when test="AltDuctLeakage=1">
										<xsl:value-of select="AltDuctLkgRptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLocation=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="RetDuctDesign=1 or SupDuctDesign=1"
										>Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="BuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DeeplyBuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hersdist" select="Name"/>
								<xsl:variable name="llah"
									select="preceding-sibling::HVACDist[HERSCheck=$hersdist]/LowLkgAH"/>
								<xsl:choose>
									<xsl:when test="$llah=1">Required</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!--HERS Dist SF-->
	<xsl:template name="HERS_Dist_SFx">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.605)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.426)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.11)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.29)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.207)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.957)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.26)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.56)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC DISTRIBUTION - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Verified Duct</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Verified Duct </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Deeply Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Low-leakage</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block> Verification</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block><fo:inline> Target</fo:inline> (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Location</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						display-align="after" padding="2pt" text-align="center">
						<fo:block><fo:inline>Design</fo:inline> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Air Handler</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef and DuctsCreatedForAnalysis=0]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">Required</xsl:when>
									<xsl:when test="AltDuctLeakage=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">
										<xsl:value-of select="DuctLkgRptMsg"/>
									</xsl:when>
									<xsl:when test="AltDuctLeakage=1">
										<xsl:value-of select="AltDuctLkgRptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLocation=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="RetDuctDesign=1 or SupDuctDesign=1"
										>Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="BuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DeeplyBuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hersdist" select="Name"/>
								<xsl:variable name="llah"
									select="preceding-sibling::HVACDist[HERSCheck=$hersdist]/LowLkgAH"/>
								<xsl:choose>
									<xsl:when test="$llah=1">Required</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERS Dist MF-->
	<xsl:template name="HERS_Dist_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.605)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(13.426)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10.11)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(9.29)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.207)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.957)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.26)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.56)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>HVAC DISTRIBUTION - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>07</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>08</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Duct Leakage</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>
							<fo:block>Verified Duct</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Verified Duct </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Deeply Buried</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="after" text-align="center"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" padding="2pt">
						<fo:block>Low-leakage</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block> Verification</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block><fo:inline> Target</fo:inline> (%)</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Location</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-left-color="black" border-left-style="solid" border-left-width="1pt"
						display-align="after" padding="2pt" text-align="center">
						<fo:block><fo:inline>Design</fo:inline> </fo:block>
					</fo:table-cell>
					<fo:table-cell border-left="1pt solid black" border-bottom-color="black"
						border-bottom-style="solid" border-bottom-width="1pt"
						border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Ducts</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" display-align="after"
						padding="2pt" text-align="center">
						<fo:block>Air Handler</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef and DuctsCreatedForAnalysis=0]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">Required</xsl:when>
									<xsl:when test="AltDuctLeakage=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLeakage=1">
										<xsl:value-of select="DuctLkgRptMsg"/>
									</xsl:when>
									<xsl:when test="AltDuctLeakage=1">
										<xsl:value-of select="AltDuctLkgRptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DuctLocation=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="RetDuctDesign=1 or SupDuctDesign=1"
										>Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="BuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="DeeplyBuriedDucts=1">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="hersdist" select="Name"/>
								<xsl:variable name="llah"
									select="preceding-sibling::HVACDist[HERSCheck=$hersdist]/LowLkgAH"/>
								<xsl:choose>
									<xsl:when test="$llah=1">Required</xsl:when>
									<xsl:otherwise><xsl:call-template name="na"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Fan SF-->
	<xsl:template name="HVAC_Fan_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(9.262)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.61)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.7)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.596)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - FAN  SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan Power (Watts/CFM)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding::SCSysRpt/HVACFanRef=HVACFanRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACFanRef)">
									<xsl:value-of select="HVACFanRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/Type"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/WperCFMCool"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isMF"
									select="//Model[@Name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACFan/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if
											test="not(//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck)"
											><xsl:call-template name="na"/></xsl:if>
										<xsl:if
											test="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck">
											<xsl:value-of
												select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck"
											/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HVAC Fan MF-->
	<xsl:template name="HVAC_Fan_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(9.262)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(10.61)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.7)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.596)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
						<fo:block>HVAC - FAN  SYSTEMS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Fan Power (Watts/CFM)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[not(preceding::SCSysRpt/HVACFanRef=HVACFanRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(HVACFanRef)">
									<xsl:value-of select="HVACFanRef"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/Type"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:value-of
									select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/WperCFMCool"
								/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isMF"
									select="//Model[@Name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:variable name="fanSys" select="HVACFanRef"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of
											select="//Model[@Name='Proposed']/HVACFan/HERSCheck"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if
											test="not(//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck)"
											><xsl:call-template name="na"/></xsl:if>
										<xsl:if
											test="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck">
											<xsl:value-of
												select="//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck"
											/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERS Fan SF-->
	<xsl:template name="HERS_Fan_SFx">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cell">
						<fo:block>HVAC FAN SYSTEMS - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Fan Watt Draw</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Required Fan Efficiency (Watts/CFM)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/Fan]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="AHUFanEff='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(FanEffRptMsg)">
									<xsl:value-of select="FanEffRptMsg"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--HERS Fan SF-->
	<xsl:template name="HERS_Fan_MF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(10.016)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.474)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(8.328)" column-number="3"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cell">
						<fo:block>HVAC FAN SYSTEMS - HERS VERIFICATION</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Verified Fan Watt Draw</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Required Fan Efficiency (Watts/CFM)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/Fan]/HERSCheck]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Name/text())">
									<xsl:value-of select="Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="AHUFanEff='1'">Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(FanEffRptMsg)">
									<xsl:value-of select="FanEffRptMsg"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Fan IAQ Vent.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Fan_IAQ_Vent_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.626)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(20.192)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(20.192)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(13.987)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.001)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(14.001)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>IAQ (Indoor Air Quality) FANS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>06</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Dwelling Unit</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Watts/CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Fan Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>IAQ Recovery Effectiveness(%)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>HERS Verification</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/IAQVentRpt[not(DwellUnitTypeRef=preceding-sibling::IAQVentRpt/DwellUnitTypeRef)]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="isMF"
									select="//Model[@name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:choose>
									<xsl:when test="$isMF=1">
										<xsl:value-of select="DwellUnitTypeRef"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(IAQCFM)">
									<xsl:value-of select="IAQCFM"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(WperCFMIAQ)">
									<xsl:value-of select="WperCFMIAQ"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(IAQFanType)">
									<xsl:value-of select="IAQFanType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(IAQRecovEffect)">
									<xsl:value-of select="IAQRecovEffect"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="preceding-sibling::HERSOther/IAQFan=1"
										>Required</xsl:when>
									<xsl:otherwise>Not Required</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Fan CoolVent.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Fan_CoolVent_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.552)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(24.689)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block>COOLING VENTILATION </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>03</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>04</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>05</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Vent CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Cooling Vent Watts/CFM</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Total Watts</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Number of Fans</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/ClVentFan[NumAssignments&gt;0]">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="cfiName" select="Name"/>
								<xsl:variable name="cfiCompat"
									select="//Model[@Name='Proposed']/HVACSys[CFIClVentFan=$cfiName]/CFIClVentCompat"/>
								<xsl:choose>
									<xsl:when test="$cfiCompat=1">
										<xsl:value-of
											select="concat(Name,' (',//Model[@Name='Proposed']/HVACSys[CFIClVentFan=$cfiName]/CFIClVentOptionRpt,') ')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CoolingVent)">
									<xsl:value-of select="CoolingVent"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(WperCFMCool)">
									<xsl:value-of select="WperCFMCool"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(format-number(CoolingVent*WperCFMCool,'0'))">
									<xsl:value-of
										select="format-number(CoolingVent*WperCFMCool,'0')"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(NumAssignments)">
									<xsl:value-of select="NumAssignments"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--REVISED COOLING VENTILATION TABLE-->
	<xsl:template name="CoolingVentilation">
		<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xslt="http://www.w3.org/1999/XSL/Transform">
			<fo:table border-collapse="collapse" font-family="Arial Narrow" font-size="8pt" keep-together.within-column="always" margin-top="0in" table-layout="fixed" width="100%">
				<fo:table-column column-width="proportional-column-width(22.024)" column-number="1"/>
				<fo:table-column column-width="proportional-column-width(12.653)" column-number="2"/>
				<fo:table-column column-width="proportional-column-width(11.603)" column-number="3"/>
				<fo:table-column column-width="proportional-column-width(14.369)" column-number="4"/>
				<fo:table-column column-width="proportional-column-width(11.213)" column-number="5"/>
				<fo:table-column column-width="proportional-column-width(11.815)" column-number="6"/>
				<fo:table-body>
					<fo:table-row height="0.224in" overflow="hidden">
						<fo:table-cell number-columns-spanned="6" border="1pt solid black" display-align="center" font-weight="bold" line-height="115%" padding="2pt" text-align="left">
							<fo:block>COOLING VENTILATION </fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row font-weight="bold" height="0.185in" overflow="hidden">
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>01</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>02</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>03</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>04</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>05</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
							<fo:block>06</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row font-weight="bold" overflow="hidden">
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Name</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Airflow Rate (CFM/ft2)</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Cooling Vent CFM</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Cooling Vent Watts/CFM</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Total Watts</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt" text-align="center">
							<fo:block>Number of Fans</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:for-each select="//Model[@Name='Proposed']/ClVentFan[NumAssignments&gt;0]">
						<fo:table-row>
							<xslt:variable name="isFirst_id28209024">
								<xslt:choose>
									<xslt:when test="position() = 1">true</xslt:when>
									<xslt:otherwise>false</xslt:otherwise>
								</xslt:choose>
							</xslt:variable>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:variable name="cfiName" select="Name"/>
									<xsl:variable name="cfiCompat" select="//Model[@Name='Proposed']/HVACSys[CFIClVentFan=$cfiName]/CFIClVentCompat"/>
									<xsl:choose>
										<xsl:when test="$cfiCompat=1">
											<xsl:value-of select="concat(Name,' (',//Model[@Name='Proposed']/HVACSys[CFIClVentFan=$cfiName]/CFIClVentOptionRpt,') ')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="Name"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:variable name="hasCoolVent" select="//Model[@Name='Proposed']/Proj/EnableClVent"/>
									<xsl:variable name="coolVentCFM" select="//Model[@Name='Proposed']/Proj/UnitClVentCFMTot"/>
									<xsl:variable name="CFA" select="//Model[@Name='Proposed']/Proj/CondFloorArea"/>
									<xsl:choose>
										<xsl:when test="$hasCoolVent=1">
											<xsl:value-of select="format-number($coolVentCFM div $CFA,'0.0')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(CoolingVent)">
										<xsl:value-of select="CoolingVent"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(WperCFMCool)">
										<xsl:value-of select="WperCFMCool"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(format-number(CoolingVent*WperCFMCool,'0'))">
										<xsl:value-of select="format-number(CoolingVent*WperCFMCool,'0')"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(NumAssignments)">
										<xsl:value-of select="NumAssignments"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</xsl:for-each>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!--COM_Notes-->
	<xsl:template name="COM_Notes">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(21.552)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(24.689)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(17.920)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block>PROJECT NOTES</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/Notes)">
								<fo:inline linefeed-treatment="preserve"
									white-space-collapse="false" white-space-treatment="preserve">
									<xsl:value-of select="//Model[@Name='Proposed']/Proj/Notes"/>
								</fo:inline>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--CF1R Declarations-->
	<xsl:template name="CF1R_Declarations">
		<fo:table xsl:use-attribute-sets="tableLast" keep-together.within-page="always">
			<fo:table-column column-width="proportional-column-width(25.000)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(25.000)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(25.000)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(25.000)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellD">
						<fo:block>DOCUMENTATION AUTHOR'S DECLARATION STATEMENT</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellC">
						<fo:block>1. I certify that this Certificate of Compliance documentation is
							accurate and complete.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Documentation Author Name:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Documentation Author Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Company:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Signature Date:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Address:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>CEA/HERS Certification Identification (If applicable):</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>City/State/Zip:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Phone:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellD">
						<fo:block>RESPONSIBLE PERSON'S DECLARATION STATEMENT</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cellC">
						<fo:block> I certify the following under penalty of perjury, under the laws
							of the State of California: </fo:block>
						<fo:block margin-left="5pt">
							<fo:list-block>
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block>1.</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block>I am eligible under Division 3 of the Business and
											Professions Code to accept responsibility for the
											building design identified on this Certificate of
											Compliance.</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block>2.</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block>I certify that the energy features and performance
											specifications identified on this Certificate of
											Compliance conform to the requirements of Title 24, Part
											1 and Part 6 of the California Code of
											Regulations.</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block>3.</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block>The building design features or system design
											features identified on this Certificate of Compliance
											are consistent with the information provided on other
											applicable compliance documents, worksheets,
											calculations, plans and specifications submitted to the
											enforcement agency for approval with this building
											permit application.</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Responsible Designer Name:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Responsible Designer Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25.5pt"
						padding="2pt">
						<fo:block>Company:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25.5pt"
						padding="2pt">
						<fo:block>Date Signed:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Address:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>License:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>City/State/Zip:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black" height="25pt"
						padding="2pt">
						<fo:block>Phone:</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<!-- Misc utility templates -->
	<xsl:template name="na">
		<fo:block>n/a</fo:block>
	</xsl:template>
	

	<!-- Draw empty square    -->
	<xsl:template name="drawSquare">
		<fo:instream-foreign-object>
			<svg:svg width="10" height="10">
				<svg:rect x="0" y="0" width="10" height="10" fill="white"
					style="stroke:black;stroke-width:1"/>
			</svg:svg>
		</fo:instream-foreign-object>
	</xsl:template>
	<!-- End Draw empty square  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    -->

	<!-- Draw checked square    -->
	<xsl:template name="drawCheckedSquare">
		<fo:instream-foreign-object>
			<svg:svg width="10" height="10">
				<svg:rect x="0" y="0" width="10" height="10" fill="white"
					style="stroke:black;stroke-width:1"/>
				<svg:line x1="0" y1="0" stroke="black" stroke-width="1" x2="10" y2="10"/>
				<svg:line x1="0" y1="10" stroke="black" stroke-width="1" x2="10" y2="0"/>
			</svg:svg>
		</fo:instream-foreign-object>
	</xsl:template>
	<!-- End Draw checked square  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   -->

</xsl:stylesheet>
