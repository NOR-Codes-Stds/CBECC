<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:date="http://exslt.org/dates-and-times" xmlns:str="http://exslt.org/strings"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" extension-element-prefixes="date str">

	<xsl:output indent="no" encoding="utf-8"/>

	<!-- Parameters passed by Report Generator based on security keys, compliance manager version and date -->
	<xsl:param name="draft" select="'NotCertified'"/>
	<xsl:param name="AtVersion">695</xsl:param>
	<xsl:param name="VersionDate">04252017</xsl:param>
	<xsl:param name="Expiry">December 31, 2018</xsl:param>
	<!-- Check if the Expiry date has passed 1 = true; 0 = false-->
	<xsl:variable name="isExpired">
		<!-- Need a function for this tied to a parameter that is passed:  can do this after deployment -->
		0 </xsl:variable>
	<!-- Global Variables -->
	<!-- Check the DevMode Flag -->
	<xsl:variable name="useDebug" select="//SDDXML/Model[@Name='Proposed']/Proj/DevMode"/>
	<!-- Code Year -->
	<xsl:variable name="energyCodeYear"
		select="//SDDXML/Model[@Name='Proposed']/Proj/EnergyCodeYear"/>
	<!-- MultiFamily Flag -->
	<xsl:variable name="isMF" select="//SDDXML/Model[@Name='Proposed']/Proj/IsMultiFamily"/>
	<!-- RunScope -->
	<xsl:variable name="runScope" select="//SDDXML/Model[@Name='Proposed']/Proj/RunScope"/>
	<!-- Detect NoCooling -->
	<xsl:variable name="noCooling" select="//SDDXML/Model[@Name='Proposed']/SpeclFtr/NoCooling"/>
	<!-- EDR Variable -->
	<xsl:variable name="hasEDR" select="//SDDXML/Model[@Name='Proposed']/Proj/DesignRatingCalcs"/>
	<!-- Are there special features -->
	<xsl:variable name="spcl_feature"
		select="count(//SDDXML/Model[@Name='Proposed']/SpeclFtr[.>=1])"/>
	<!-- Template fix for IsAdditionAlone -->
	<xsl:variable name="isAddAlone" select="//SDDXML/Model[@Name='Proposed']/Proj/IsAddAlone"/>
	<xsl:variable name="yodaFlag" select="//SDDXML/Model[@Name='Proposed']/Proj/ShowNotRegWatermark"/>

	<!-- General PV Input variables -->
	<xsl:variable name="pvRowCount" select="//SDDXML/Model[@Name='Proposed']/Proj/PVWLastRow"/>
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="pvInputType" select="//Model[@Name='Proposed']/Proj/PVWInputs"/>

	<!-- PV Battery Variables -->
	<xsl:variable name="hasBattery" select="//SDDXML/Model[@Name='Proposed']/Proj/SimulateBattery"/>
	<xsl:variable name="batteryControl"
		select="//SDDXML/Model[@Name='Proposed']/Proj/BatteryControl"/>

	<!-- CFI Variables -->
	<xsl:variable name="cfi1"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=0]"/>
	<xsl:variable name="cfi2"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=1]"/>
	<xsl:variable name="cfi3"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=2]"/>
	<xsl:variable name="cfi4"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=3]"/>
	<xsl:variable name="cfi5" select="//Model[@Name='Proposed']/Proj/PVWCalFlexInstall[@index=4]"/>

	<!-- PVWSysSize Variables -->
	<xsl:variable name="sysSize1"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=0]"/>
	<xsl:variable name="sysSize2"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=1]"/>
	<xsl:variable name="sysSize3"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=2]"/>
	<xsl:variable name="sysSize4"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=3]"/>
	<xsl:variable name="sysSize5"
		select="//SDDXML/Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=4]"/>

	<!-- Water Heating HERS Measure Variable to indicate if there re HERS MEasures for DHW -->
	<xsl:variable name="test_dhw">
		<xsl:choose>
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="count(//SDDXML/Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<!-- For SF we only need to test DHWSys1 -->
			<xsl:when
				test="//SDDXML/Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1]">
				<xsl:value-of
					select="count(//SDDXML/Model[@Name='Proposed']/HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DHWSys1]/HERSCheck]/*[.=1])"
				/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Get the Pass/Fail Value -->
	<xsl:variable name="passOrfail"
		select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary/PassFail/text()"/>

	<!--<!-\- IAQ ERROR FOR Ticket 765 -\->
	<xsl:variable name="mfIAQERROR">
		<xsl:if test="$isMF=1">
			<xsl:value-of select="1"/>
		</xsl:if>
	</xsl:variable>-->


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
	
	<xsl:attribute-set name="blockBelowTable">
		<xsl:attribute name="font-size">7pt</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- ========================= ROOT TEMPLATE =========================== -->
	<xsl:template match="/">

		<fo:root font-family="Arial" font-size="8pt">

			<fo:layout-master-set>
				<fo:simple-page-master master-name="Letter Page" page-width="11in"
					page-height="8.5in">
					<fo:region-body region-name="xsl-region-body" margin="1in 0.5in 0.7in 0.5in"/>
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
					<!-- CHECK FOR PROBLEMS IN THE CBECC DATA -->
					<xsl:if test="$draft='InterceptError'">
						<!-- XmlIntercept    -->
						<xsl:apply-templates select="//Errors" mode="XmlIntercept"/>
					</xsl:if>
					<!--General)-->
					<xsl:call-template name="General"/>
					<fo:block>
						<xsl:choose>
							<xsl:when test="//SDDXML/Model[@Name='Proposed']/Proj/IsAddAlone=1">
								<fo:block>
									<xsl:apply-templates
										select="//SDDXML/Model[@Name='Proposed']/Proj"
										mode="addAloneParms"/>
								</fo:block>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/AllOrientations=1">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_CF1R_FeaturesList.xfc)-->
								<xsl:call-template name="CF1R_FeaturesList"/>
								<fo:block>
									<!--Cardinal Orientation Results-->
									<!--<xsl:apply-templates select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary"
										mode="CardinalOrientationResults"/>-->
									<xsl:call-template
										name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Cardinal_Orientation_Results_xfc"
									/>
								</fo:block>
								<xsl:choose>
									<xsl:when test="$hasEDR=1">
										<!--Generated for component:url(.\NC\NC_DesignRating-Cardinal_2016-2.0.xfc)-->
										<xsl:call-template name="EDR_Cardinal"/>
										<!--  If there are PV records to report-->
										<xsl:if test="$pvRowCount > 0">
											<xsl:call-template name="EDR_PV_Simple"/>
										</xsl:if>
										<xsl:if test="$hasEDR=1 and $hasBattery=1">
											<xsl:call-template name="EDR_Battery"/>
										</xsl:if>
									</xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<!--Single Orientation Results-->
								<xsl:apply-templates
									select="//SDDXML/Model[@Name='Standard']/Proj/EUseSummary"
									mode="SingleOrientationResults"/>
								<!--<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Single_Orientation_Results_xfc"/>-->
								<!-- Show the EDR Report if $hasEDR=1 -->
								<xsl:if test="$hasEDR=1">
									<xsl:call-template name="EDR_Single2"/>
								</xsl:if>
								<!--  If there are PV records to report-->
								<xsl:if test="$hasEDR=1 and $pvRowCount > 0">
									<xsl:call-template name="EDR_PV_Simple"/>
								</xsl:if>
								<xsl:if test="$hasEDR=1 and $hasBattery=1">
									<xsl:call-template name="EDR_Battery"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<!-- Special Features    -->
						<xsl:if test="//SDDXML/Model[@Name='Proposed']/Proj/SpeclFeatrs">
							<xsl:apply-templates select="//SDDXML/Model[@Name='Proposed']/SpeclFtr"
								mode="SpecialFeaturesList"/>
						</xsl:if>
						<fo:block> </fo:block>
						<!-- HERS Features    -->
						<xsl:if test="//SDDXML/Model[@Name='Proposed']/Proj/SpeclFeatrs">
							<xsl:apply-templates select="//SDDXML/Model[@Name='Proposed']"
								mode="HERSFeatureSummary"/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$hasEDR=0 and $energyCodeYear ='2013'">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_CalGreenSummary.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_CalGreenSummary_xfc"
								/>
							</xsl:when>
						</xsl:choose>
						<!-- Building, Zone and Dwelling Unit -->
						<xsl:choose>
							<xsl:when test="$isMF=0">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_BuildingFeatures-SF.xfc)-->
								<xsl:apply-templates mode="BuildingFeatures"
									select="//SDDXML/Model[@Name='Proposed']/Proj"/>
								<!--<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_BuildingFeatures-SF_xfc"/>-->
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Zone Features-SF.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Zone_Features-SF_xfc"
								/>
							</xsl:when>
							<xsl:when test="$isMF=1">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_BuildingFeatures-MF.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_BuildingFeatures-MF_xfc"/>
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Zone Features-MF.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Zone_Features-MF_xfc"/>
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Dwelling Unit Table.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Dwelling_Unit_Table_xfc"/>
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Dwelling Unit Types.xfc)-->
								<xsl:call-template name="Dwelling_Unit_Types"/>
							</xsl:when>
						</xsl:choose>
						<!-- Building Envelope Sections -->
						<xsl:choose>
							<xsl:when test="$runScope='Newly Constructed'">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Opaque Surfaces.xfc)-->
								<xsl:call-template name="Opaque_Surfaces"/>
							</xsl:when>
						</xsl:choose>  <xsl:choose>
							<xsl:when
								test="$runScope='Newly Constructed' and //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Opaque-Cathedral Ceilings.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Opaque-Cathedral_Ceilings_xfc"
								/>
							</xsl:when>
						</xsl:choose>  <xsl:choose>
							<xsl:when
								test="$runScope='Newly Constructed' and //Model[@Name='Proposed']/Proj/Attic">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Attic.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Attic_xfc"/>
							</xsl:when>
						</xsl:choose>  <xsl:choose>
							<xsl:when test="$runScope='Newly Constructed'">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Windows.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Windows_xfc"
								/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Door | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door | //Model[@Name='Proposed']/Proj/Garage/ExtWall/Door">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Doors.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Doors_xfc"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[ShowFinsOverhang=1]">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Overhangs-Fins.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Overhangs-Fins_xfc"
								/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Opaque Surface Constructions.xfc)-->
						<xsl:call-template name="Opaque_Surface_Constructions"/>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/UndFloor | //Model[@Name='Proposed']/Proj/Zone/SlabFloor">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Slab Floor.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Slab_Floor_xfc"
								/>
							</xsl:when>
						</xsl:choose>
						<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Building Envelope HERS.xfc)-->
						<xsl:call-template name="Building_Envelope_HERS"/>
						<!-- DHW Systems -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj[IsMultiFamily=1]/Zone/DwellUnit/DHWSysRpt">
								<xsl:call-template name="MF_DHW_System"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="count(//Model[@Name='Proposed']/DHWSys/DHWSysRpt) > 0">
								<xsl:call-template name="SF_DHW_System"/>
							</xsl:when>
						</xsl:choose>
						<!-- DHW Heaters -->
						<xsl:choose>
							<!--Water Heaters SF-->
							<xsl:when test="count(//Model[@Name='Proposed']/DHWSys/DHWSysRpt) > 0">
								<!--<xsl:call-template name="WaterHeaters_SF3"/>-->
								<xsl:apply-templates
									select="//SDDXML/Model[@Name='Proposed']/DHWSys[NumDUsServed > 0]"
									mode="Waterheaters_SF_UEF"/>
							</xsl:when>
							<!--Water Heaters MF-->
							<xsl:when
								test="count(//SDDXML/Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt) > 0">
								<!--<xsl:call-template name="WaterHeaters_MF3"/>-->
								<xsl:call-template name="Waterheaters_MF_UEF"/>
								<!--<xsl:apply-templates
									select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit"
									mode="Waterheaters_MF_UEF"/>-->
								<!--<xsl:apply-templates
									select="//SDDXML/Model[@Name='Proposed']/Proj/Zone/DwellUnit"
									mode="Waterheaters_MF"/>-->
							</xsl:when>
						</xsl:choose>
						<!-- DHW HERS ONLY WHEN $test_dhw = 1 -->
						<xsl:if test="$test_dhw >= 1">
							<xsl:choose>
								<xsl:when test="//Model[@Name='Proposed']/DHWSys/DHWSysRpt">
									<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_HERS _DHW-SF.xfc)-->
									<xsl:call-template name="DHWHERS"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<!-- Space Conditioning Systems SF -->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/SCSysRpt">
								<xsl:call-template name="SC_Systems_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- Heat Types SF-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal!=2]">
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
							<xsl:when test="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal !=2 and CoolingType !='NoCooling']">
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
						<!-- HVAC Dist -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1) and (preceding-sibling::Proj/SCSysRpt/HERSRetDuctDesign=0 or preceding-sibling::Proj/SCSysRpt/HERSSupDuctDesign=0)]">
								<xsl:call-template name="HVAC_Dist_NoDesign_SF"/>
							</xsl:when>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1) and (preceding-sibling::Proj/SCSysRpt/HERSRetDuctDesign=1 or preceding-sibling::Proj/SCSysRpt/HERSSupDuctDesign=1)]">
								<xsl:call-template name="HVAC_Dist_Design_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- HERS Dist -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1)]">
								<xsl:call-template name="HERS_Dist_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- HVAC Fan -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef]">
								<xsl:call-template name="HVAC_Fan_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- HERS Fan -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef and ClFlrAreaServed &gt; 0]">
								<xsl:call-template name="HERS_Fan_SF"/>
							</xsl:when>
						</xsl:choose>
						<!-- END SPACE CONDITIONING SF -->
						<!-- Space Conditioning Systems MF -->
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt">
								<xsl:call-template name="SC_Systems_MF"/>
							</xsl:when>
						</xsl:choose>
						<!-- Heat Types MF-->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[SCSysTypeVal!=2]">
								<xsl:call-template name="HVAC_Heat_MF"/>
							</xsl:when>
						</xsl:choose>
						<!-- Heat Pump Systems -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]">
								<xsl:call-template name="HVAC_HP_MF"/>
							</xsl:when>
						</xsl:choose>
						<!-- Cooling NOT HP -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[SCSysTypeVal !=2 and CoolingType !='NoCooling']">
								<xsl:call-template name="HVAC_Cool_MF"/>
							</xsl:when>
						</xsl:choose>
						<!-- HERS Cooling -->
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HtPumpSystem]/HERSCheck]">
								<xsl:call-template name="HERS_Cool_MF"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1) and (preceding-sibling::Proj/SCSysRpt/Zone/DwellUnit/HERSRetDuctDesign=0 or preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HERSSupDuctDesign=0)]">
								<xsl:call-template name="HVAC_Dist_NoDesign_MF"/>
							</xsl:when>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1) and (preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HERSRetDuctDesign=1 or preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HERSSupDuctDesign=1)]">
								<xsl:call-template name="HVAC_Dist_Design_MF"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef and not(DuctsCreatedForAnalysis=1)]">
								<xsl:call-template name="HERS_Dist_MF"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef]">
								<xsl:call-template name="HVAC_Fan_MF"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef and ClFlrAreaServed &gt; 0]">
								<xsl:call-template name="HERS_Fan_MF"/>
							</xsl:when>
						</xsl:choose>
						<!-- IAQ -->
						<xsl:choose>
							<xsl:when
								test="not(sum(//Model[@Name='Proposed']/Proj/Zone/AdditionCFA) &lt;=1000 and //Model[@Name='Proposed']/Proj/IsAddAlone=1)">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Fan IAQ Vent.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Fan_IAQ_Vent_xfc"
								/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when
								test="//Model[@Name='Proposed']/ClVentFan[NumAssignments&gt;0]">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\NC\NC_Fan CoolVent.xfc)-->
								<xsl:call-template name="CoolingVentilation"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="//Model[@Name='Proposed']/Proj/Notes">
								<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_Notes.xfc)-->
								<xsl:call-template
									name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Notes_xfc"
								/>
							</xsl:when>
						</xsl:choose>  <fo:block break-before="page">
							<!--Generated for component:url(Y:\CBECC-Res Documents\2016\Common\COM_CF1R Declarations.xfc)-->
							<xsl:call-template
								name="_component_Y__CBECC-Res_Documents_2016_Common_COM_CF1R_Declarations_xfc"
							/>
						</fo:block>
						<fo:block>
							<xsl:if test="string(//Model[@Name='Proposed']/Proj/SoftwareNote)">
								<xsl:value-of select="//Model[@Name='Proposed']/Proj/SoftwareNote"/>
							</xsl:if>
						</fo:block>
						<fo:block id="last-page">
							<xsl:attribute name="id">last-page</xsl:attribute>
						</fo:block>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<!-- ========================= NUMBER FORMATS ========================= -->
	<!-- ======================== DURATION FORMATS ======================== -->
	<xsl:template name="date:format-duration">
		<xsl:param name="duration" select="''"/>
		<xsl:param name="pattern"/>
		<xsl:variable name="duration-sign">
			<xsl:value-of select="substring-before($duration, 'P')"/>
		</xsl:variable>
		<xsl:variable name="years">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'years'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="months">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'months'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="days">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'days'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hours">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'hours'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="minutes">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'minutes'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="seconds">
			<xsl:call-template name="date:extract-duration-component">
				<xsl:with-param name="duration-str" select="$duration"/>
				<xsl:with-param name="duration-component" select="'seconds'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="years-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($pattern)"/>
				<xsl:with-param name="from" select="'YYY'"/>
				<xsl:with-param name="to" select="normalize-space($years)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="months-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($years-formated)"/>
				<xsl:with-param name="from" select="'MMM'"/>
				<xsl:with-param name="to" select="normalize-space($months)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="days-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($months-formated)"/>
				<xsl:with-param name="from" select="'DDD'"/>
				<xsl:with-param name="to" select="normalize-space($days)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hours-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($days-formated)"/>
				<xsl:with-param name="from" select="'HH'"/>
				<xsl:with-param name="to" select="normalize-space($hours)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="minutes-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($hours-formated)"/>
				<xsl:with-param name="from" select="'MM'"/>
				<xsl:with-param name="to" select="normalize-space($minutes)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="seconds-formated">
			<xsl:call-template name="str:replace-string">
				<xsl:with-param name="text" select="normalize-space($minutes-formated)"/>
				<xsl:with-param name="from" select="'SS'"/>
				<xsl:with-param name="to" select="normalize-space($seconds)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($duration-sign, $seconds-formated)"
			disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template name="date:extract-duration-component">
		<xsl:param name="duration-str" select="''"/>
		<xsl:param name="duration-component" select="''"/>
		<xsl:variable name="duration-date">
			<xsl:choose>
				<xsl:when test="contains($duration-str, 'T')">
					<xsl:value-of
						select="substring-before(substring-after($duration-str, 'P'), 'T')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after($duration-str, 'P')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="duration-time" select="substring-after($duration-str, 'T')"/>
		<xsl:variable name="duration-component-value">
			<xsl:choose>
				<xsl:when test="$duration-str = ''"/>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$duration-component = 'years'">
							<xsl:value-of select="substring-before($duration-date, 'Y')"/>
						</xsl:when>
						<xsl:when test="$duration-component = 'months'">
							<xsl:choose>
								<xsl:when test="contains($duration-date, 'Y')">
									<xsl:value-of
										select="substring-before(substring-after($duration-date, 'Y'), 'M')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($duration-date, 'M')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$duration-component = 'days'">
							<xsl:choose>
								<xsl:when test="contains($duration-date, 'M')">
									<xsl:value-of
										select="substring-before(substring-after($duration-date, 'M'), 'D')"
									/>
								</xsl:when>
								<xsl:when test="contains($duration-date, 'Y')">
									<xsl:value-of
										select="substring-before(substring-after($duration-date, 'Y'), 'D')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($duration-date, 'D')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$duration-component = 'hours'">
							<xsl:value-of select="substring-before($duration-time, 'H')"/>
						</xsl:when>
						<xsl:when test="$duration-component = 'minutes'">
							<xsl:choose>
								<xsl:when test="contains($duration-time, 'H')">
									<xsl:value-of
										select="substring-before(substring-after($duration-time, 'H'), 'M')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($duration-time, 'M')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$duration-component = 'seconds'">
							<xsl:choose>
								<xsl:when test="contains($duration-time, 'M')">
									<xsl:value-of
										select="substring-before(substring-after($duration-time, 'M'), 'S')"
									/>
								</xsl:when>
								<xsl:when test="contains($duration-time, 'H')">
									<xsl:value-of
										select="substring-before(substring-after($duration-time, 'H'), 'S')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($duration-time, 'S')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($duration-component-value) = ''">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$duration-component-value" disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="str:replace-string">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:param name="to"/>
		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before" select="substring-before($text, $from)"/>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:variable name="prefix" select="concat($before, $to)"/>
				<xsl:value-of select="$before"/>
				<xsl:value-of select="$to"/>
				<xsl:call-template name="str:replace-string">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
					<xsl:with-param name="to" select="$to"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ========================= CUSTOM FORMATS ========================= -->
	<xsl:template name="str:custom-format">
		<xsl:param name="str" select="''"/>
		<xsl:param name="pattern" select="''"/>
		<xsl:param name="crtPos" select="1"/>
		<xsl:if test="$crtPos &lt;= string-length($pattern)">
			<xsl:variable name="chr" select="substring(normalize-space($pattern), $crtPos, 1)"/>
			<xsl:choose>
				<xsl:when test="$chr = '#'">
					<xsl:value-of select="substring($str, 1, 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$chr"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="str:custom-format">
				<xsl:with-param name="str">
					<xsl:choose>
						<xsl:when test="$chr = '#'">
							<xsl:value-of select="substring($str, 2)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$str"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="pattern" select="$pattern"/>
				<xsl:with-param name="crtPos" select="$crtPos + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="str:get-number-ordinal">
		<xsl:param name="number"/>
		<xsl:param name="lang-id" select="'en_US'"/>
		<xsl:param name="type" select="'number'"/>
		<xsl:variable name="numberValue" select="number($number)"/>
		<xsl:choose>
			<xsl:when test="string($numberValue) = 'NaN'"/>
			<xsl:when test="$lang-id = 'en_US' or $lang-id = 'en_GB'">
				<xsl:choose>
					<xsl:when test="$numberValue = 11 or $numberValue = 12 or $numberValue = 13"
							><xsl:value-of select="$numberValue"/>&lt;fo:inline
						baseline-shift="super"
						font-size="smaller"&gt;th&lt;/fo:inline&gt;</xsl:when>
					<xsl:when test="$numberValue mod 10 = 1"><xsl:value-of select="$numberValue"
						/>&lt;fo:inline baseline-shift="super"
						font-size="smaller"&gt;st&lt;/fo:inline&gt;</xsl:when>
					<xsl:when test="$numberValue mod 10 = 2"><xsl:value-of select="$numberValue"
						/>&lt;fo:inline baseline-shift="super"
						font-size="smaller"&gt;nd&lt;/fo:inline&gt;</xsl:when>
					<xsl:when test="$numberValue mod 10 = 3"><xsl:value-of select="$numberValue"
						/>&lt;fo:inline baseline-shift="super"
						font-size="smaller"&gt;rd&lt;/fo:inline&gt;</xsl:when>
					<xsl:otherwise><xsl:value-of select="$numberValue"/>&lt;fo:inline
						baseline-shift="super"
						font-size="smaller"&gt;th&lt;/fo:inline&gt;</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'da_DK'">
				<xsl:choose>
					<xsl:when test="$numberValue = 1"><xsl:value-of select="$numberValue"
						/>ste</xsl:when>
					<xsl:when test="$numberValue = 2"><xsl:value-of select="$numberValue"
						/>den</xsl:when>
					<xsl:when test="$numberValue = 3"><xsl:value-of select="$numberValue"
						/>je</xsl:when>
					<xsl:when
						test="$numberValue = 5 or $numberValue = 6 or $numberValue = 11 or $numberValue = 12"
							><xsl:value-of select="$numberValue"/>te</xsl:when>
					<xsl:otherwise><xsl:value-of select="$numberValue"/>de</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'fr_FR'">
				<xsl:choose>
					<xsl:when test="$numberValue = 1"><xsl:value-of select="$numberValue"
						/>&lt;fo:inline baseline-shift="super"
						font-size="smaller"&gt;er&lt;/fo:inline&gt;</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$type = 'number'"><xsl:value-of select="$numberValue"
								/>&lt;fo:inline baseline-shift="super"
								font-size="smaller"&gt;e&lt;/fo:inline&gt; </xsl:when>
							<xsl:when test="$type = 'date'">
								<xsl:value-of select="$numberValue"/>
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="$numberValue"/>&lt;fo:inline
								baseline-shift="super" font-size="smaller"&gt;e&lt;/fo:inline&gt;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'it_IT'">
				<xsl:choose>
					<xsl:when test="$numberValue = 1"><xsl:value-of select="$numberValue"
						/>º</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$type = 'number'"><xsl:value-of select="$numberValue"/>º </xsl:when>
							<xsl:when test="$type = 'date'">
								<xsl:value-of select="$numberValue"/>
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="$numberValue"/>º </xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'nl_NL'"><xsl:value-of select="$numberValue"/>&lt;fo:inline
				baseline-shift="super" font-size="smaller"&gt;e&lt;/fo:inline&gt; </xsl:when>
			<xsl:when test="$lang-id = 'es_ES'"><xsl:value-of select="$numberValue"/>º </xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$numberValue"/>
				<xsl:text>.</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ========================= EXSLT TEMPLATES [str.padding.template.xsl] ========================= -->
	<xsl:template name="str:padding">
		<xsl:param name="length" select="0"/>
		<xsl:param name="chars" select="' '"/>
		<xsl:choose>
			<xsl:when test="not($length) or not($chars)"/>
			<xsl:otherwise>
				<xsl:variable name="string"
					select="concat($chars, $chars, $chars, $chars, $chars,                                        $chars, $chars, $chars, $chars, $chars)"/>
				<xsl:choose>
					<xsl:when test="string-length($string) &gt;= $length">
						<xsl:value-of select="substring($string, 1, $length)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="str:padding">
							<xsl:with-param name="length" select="$length"/>
							<xsl:with-param name="chars" select="$string"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ========================= EXSLT TEMPLATES [date.format-date.template.xsl] ========================= -->
	<xsl:template name="date:_get-days-elapsed">
		<xsl:param name="month"/>
		<xsl:choose>
			<xsl:when test="$month = 1">0</xsl:when>
			<xsl:when test="$month = 2">31</xsl:when>
			<xsl:when test="$month = 3">59</xsl:when>
			<xsl:when test="$month = 4">90</xsl:when>
			<xsl:when test="$month = 5">120</xsl:when>
			<xsl:when test="$month = 6">151</xsl:when>
			<xsl:when test="$month = 7">181</xsl:when>
			<xsl:when test="$month = 8">212</xsl:when>
			<xsl:when test="$month = 9">243</xsl:when>
			<xsl:when test="$month = 10">273</xsl:when>
			<xsl:when test="$month = 11">304</xsl:when>
			<xsl:when test="$month = 12">334</xsl:when>
			<xsl:otherwise>365</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="date:_get-month">
		<xsl:param name="month"/>
		<xsl:param name="lang-id" select="'en_US'"/>
		<xsl:choose>
			<xsl:when test="$lang-id = 'fr_FR'">
				<xsl:choose>
					<xsl:when test="$month = 1">janvier;jan</xsl:when>
					<xsl:when test="$month = 2">février;fév</xsl:when>
					<xsl:when test="$month = 3">mars;mar</xsl:when>
					<xsl:when test="$month = 4">avril;avr</xsl:when>
					<xsl:when test="$month = 5">mai;mai</xsl:when>
					<xsl:when test="$month = 6">juin;jui</xsl:when>
					<xsl:when test="$month = 7">juillet;juil</xsl:when>
					<xsl:when test="$month = 8">août;aoû</xsl:when>
					<xsl:when test="$month = 9">septembre;sep</xsl:when>
					<xsl:when test="$month = 10">octobre;oct</xsl:when>
					<xsl:when test="$month = 11">novembre;nov</xsl:when>
					<xsl:when test="$month = 12">décembre;déc</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'de_AT' or $lang-id = 'de_DE' or $lang-id = 'de_CH'">
				<xsl:choose>
					<xsl:when test="$month = 1">Januar;Jan</xsl:when>
					<xsl:when test="$month = 2">Februar;Feb</xsl:when>
					<xsl:when test="$month = 3">März;Mär</xsl:when>
					<xsl:when test="$month = 4">April;Apr</xsl:when>
					<xsl:when test="$month = 5">Mai;Mai</xsl:when>
					<xsl:when test="$month = 6">Juni;Jun</xsl:when>
					<xsl:when test="$month = 7">Juli;Jul</xsl:when>
					<xsl:when test="$month = 8">August;Aug</xsl:when>
					<xsl:when test="$month = 9">September;Sep</xsl:when>
					<xsl:when test="$month = 10">Oktober;Okt</xsl:when>
					<xsl:when test="$month = 11">November;Nov</xsl:when>
					<xsl:when test="$month = 12">Dezember;Dez</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'es_ES'">
				<xsl:choose>
					<xsl:when test="$month = 1">Enero;Ene</xsl:when>
					<xsl:when test="$month = 2">Febrero;Feb</xsl:when>
					<xsl:when test="$month = 3">Marzo;Mar</xsl:when>
					<xsl:when test="$month = 4">Abril;Abr</xsl:when>
					<xsl:when test="$month = 5">Mayo;May</xsl:when>
					<xsl:when test="$month = 6">Junio;Jun</xsl:when>
					<xsl:when test="$month = 7">Julio;Jul</xsl:when>
					<xsl:when test="$month = 8">Agosto;Ago</xsl:when>
					<xsl:when test="$month = 9">Septiembre;Sep</xsl:when>
					<xsl:when test="$month = 10">Octubre;Oct</xsl:when>
					<xsl:when test="$month = 11">Noviembre;Nov</xsl:when>
					<xsl:when test="$month = 12">Diciembre;Dic</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'nl_NL'">
				<xsl:choose>
					<xsl:when test="$month = 1">januari;jan</xsl:when>
					<xsl:when test="$month = 2">februari;feb</xsl:when>
					<xsl:when test="$month = 3">maart;maa</xsl:when>
					<xsl:when test="$month = 4">april;apr</xsl:when>
					<xsl:when test="$month = 5">mei;mei</xsl:when>
					<xsl:when test="$month = 6">juni;jun</xsl:when>
					<xsl:when test="$month = 7">juli;jul</xsl:when>
					<xsl:when test="$month = 8">augustus;aug</xsl:when>
					<xsl:when test="$month = 9">september;sep</xsl:when>
					<xsl:when test="$month = 10">oktober;okt</xsl:when>
					<xsl:when test="$month = 11">november;nov</xsl:when>
					<xsl:when test="$month = 12">december;dec</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'it_IT'">
				<xsl:choose>
					<xsl:when test="$month = 1">gennaio;genn</xsl:when>
					<xsl:when test="$month = 2">febbraio;febbr</xsl:when>
					<xsl:when test="$month = 3">marzo;mar</xsl:when>
					<xsl:when test="$month = 4">aprile;apr</xsl:when>
					<xsl:when test="$month = 5">maggio;magg</xsl:when>
					<xsl:when test="$month = 6">giugno;giugno</xsl:when>
					<xsl:when test="$month = 7">luglio;luglio</xsl:when>
					<xsl:when test="$month = 8">agosto;ag</xsl:when>
					<xsl:when test="$month = 9">settembre;sett</xsl:when>
					<xsl:when test="$month = 10">ottobre;ott</xsl:when>
					<xsl:when test="$month = 11">novembre;nov</xsl:when>
					<xsl:when test="$month = 12">dicembre;dic</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'da_DK'">
				<xsl:choose>
					<xsl:when test="$month = 1">januar;jan</xsl:when>
					<xsl:when test="$month = 2">februar;feb</xsl:when>
					<xsl:when test="$month = 3">marts;mar</xsl:when>
					<xsl:when test="$month = 4">april;apr</xsl:when>
					<xsl:when test="$month = 5">maj;maj</xsl:when>
					<xsl:when test="$month = 6">juni;jun</xsl:when>
					<xsl:when test="$month = 7">juli;jul</xsl:when>
					<xsl:when test="$month = 8">august;aug</xsl:when>
					<xsl:when test="$month = 9">september;sep</xsl:when>
					<xsl:when test="$month = 10">oktober;okt</xsl:when>
					<xsl:when test="$month = 11">november;nov</xsl:when>
					<xsl:when test="$month = 12">december;dec</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$month = 1">January;Jan</xsl:when>
					<xsl:when test="$month = 2">February;Feb</xsl:when>
					<xsl:when test="$month = 3">March;Mar</xsl:when>
					<xsl:when test="$month = 4">April;Apr</xsl:when>
					<xsl:when test="$month = 5">May;May</xsl:when>
					<xsl:when test="$month = 6">June;Jun</xsl:when>
					<xsl:when test="$month = 7">July;Jul</xsl:when>
					<xsl:when test="$month = 8">August;Aug</xsl:when>
					<xsl:when test="$month = 9">September;Sep</xsl:when>
					<xsl:when test="$month = 10">October;Oct</xsl:when>
					<xsl:when test="$month = 11">November;Nov</xsl:when>
					<xsl:when test="$month = 12">December;Dec</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="date:_get-day">
		<xsl:param name="day"/>
		<xsl:param name="lang-id" select="'en_US'"/>
		<xsl:choose>
			<xsl:when test="$lang-id = 'fr_FR'">
				<xsl:choose>
					<xsl:when test="$day = 1">Dimanche;Dim</xsl:when>
					<xsl:when test="$day = 2">Lundi;Lun</xsl:when>
					<xsl:when test="$day = 3">Mardi;Mar</xsl:when>
					<xsl:when test="$day = 4">Mercredi;Mer</xsl:when>
					<xsl:when test="$day = 5">Jeudi;Jeu</xsl:when>
					<xsl:when test="$day = 6">Vendredi;Ven</xsl:when>
					<xsl:when test="$day = 7">Samedi;Sam</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'de_AT' or $lang-id = 'de_DE' or $lang-id = 'de_CH'">
				<xsl:choose>
					<xsl:when test="$day = 1">Sonntag;Son</xsl:when>
					<xsl:when test="$day = 2">Montag;Mon</xsl:when>
					<xsl:when test="$day = 3">Dienstag;Die</xsl:when>
					<xsl:when test="$day = 4">Mittwoch;Mit</xsl:when>
					<xsl:when test="$day = 5">Donnerstag;Don</xsl:when>
					<xsl:when test="$day = 6">Freitag;Fre</xsl:when>
					<xsl:when test="$day = 7">Samstag;Sam</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'es_ES'">
				<xsl:choose>
					<xsl:when test="$day = 1">Domingo;Dom</xsl:when>
					<xsl:when test="$day = 2">Lunes;Lun</xsl:when>
					<xsl:when test="$day = 3">Martes;Mar</xsl:when>
					<xsl:when test="$day = 4">Miércoles;Mié</xsl:when>
					<xsl:when test="$day = 5">Jueves;Jue</xsl:when>
					<xsl:when test="$day = 6">Viernes;Vie</xsl:when>
					<xsl:when test="$day = 7">Sábado;Sáb</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'nl_NL'">
				<xsl:choose>
					<xsl:when test="$day = 1">zondag;zon</xsl:when>
					<xsl:when test="$day = 2">maandag;maa</xsl:when>
					<xsl:when test="$day = 3">dinsdag;din</xsl:when>
					<xsl:when test="$day = 4">woensdag;woe</xsl:when>
					<xsl:when test="$day = 5">donderdag;don</xsl:when>
					<xsl:when test="$day = 6">vrijdag;vri</xsl:when>
					<xsl:when test="$day = 7">zaterdag;zat</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'it_IT'">
				<xsl:choose>
					<xsl:when test="$day = 1">domenica;do</xsl:when>
					<xsl:when test="$day = 2">lunedì;lun</xsl:when>
					<xsl:when test="$day = 3">martedì;mar</xsl:when>
					<xsl:when test="$day = 4">mercoledì;mer</xsl:when>
					<xsl:when test="$day = 5">giovedì;gio</xsl:when>
					<xsl:when test="$day = 6">venerdì;ven</xsl:when>
					<xsl:when test="$day = 7">sabato;sab</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$lang-id = 'da_DK'">
				<xsl:choose>
					<xsl:when test="$day = 1">søndag;søn</xsl:when>
					<xsl:when test="$day = 2">mandag;man</xsl:when>
					<xsl:when test="$day = 3">tirsdag;tir</xsl:when>
					<xsl:when test="$day = 4">onsdag;ons</xsl:when>
					<xsl:when test="$day = 5">torsdag;tor</xsl:when>
					<xsl:when test="$day = 6">fredag;fre</xsl:when>
					<xsl:when test="$day = 7">lørdag;lør</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$day = 1">Sunday;Sun</xsl:when>
					<xsl:when test="$day = 2">Monday;Mon</xsl:when>
					<xsl:when test="$day = 3">Tuesday;Tue</xsl:when>
					<xsl:when test="$day = 4">Wednesday;Wed</xsl:when>
					<xsl:when test="$day = 5">Thursday;Thu</xsl:when>
					<xsl:when test="$day = 6">Friday;Fri</xsl:when>
					<xsl:when test="$day = 7">Saturday;Sat</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="date:format-date">
		<xsl:param name="date-time"/>
		<xsl:param name="pattern"/>
		<xsl:param name="lang-id"/>
		<xsl:variable name="formatted">
			<xsl:choose>
				<xsl:when test="starts-with($date-time, '---')">
					<xsl:call-template name="date:_format-date">
						<xsl:with-param name="year" select="'NaN'"/>
						<xsl:with-param name="month" select="'NaN'"/>
						<xsl:with-param name="day" select="number(substring($date-time, 4, 2))"/>
						<xsl:with-param name="pattern" select="$pattern"/>
						<xsl:with-param name="lang-id" select="$lang-id"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="starts-with($date-time, '--')">
					<xsl:call-template name="date:_format-date">
						<xsl:with-param name="year" select="'NaN'"/>
						<xsl:with-param name="month" select="number(substring($date-time, 3, 2))"/>
						<xsl:with-param name="day" select="number(substring($date-time, 6, 2))"/>
						<xsl:with-param name="pattern" select="$pattern"/>
						<xsl:with-param name="lang-id" select="$lang-id"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="neg" select="starts-with($date-time, '-')"/>
					<xsl:variable name="no-neg">
						<xsl:choose>
							<xsl:when test="$neg or starts-with($date-time, '+')">
								<xsl:value-of select="substring($date-time, 2)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$date-time"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="no-neg-length" select="string-length($no-neg)"/>
					<xsl:variable name="timezone">
						<xsl:choose>
							<xsl:when test="substring($no-neg, $no-neg-length) = 'Z'">Z</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="tz"
									select="substring($no-neg, $no-neg-length - 5)"/>
								<xsl:if
									test="(substring($tz, 1, 1) = '-' or                                      substring($tz, 1, 1) = '+') and                                    substring($tz, 4, 1) = ':'">
									<xsl:value-of select="$tz"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if
						test="not(string($timezone)) or                           $timezone = 'Z' or                            (substring($timezone, 2, 2) &lt;= 23 and                            substring($timezone, 5, 2) &lt;= 59)">
						<xsl:variable name="dt"
							select="substring($no-neg, 1, $no-neg-length - string-length($timezone))"/>
						<xsl:variable name="dt-length" select="string-length($dt)"/>
						<xsl:choose>
							<xsl:when
								test="substring($dt, 3, 1) = ':' and                                   substring($dt, 6, 1) = ':'">
								<xsl:variable name="hour" select="substring($dt, 1, 2)"/>
								<xsl:variable name="min" select="substring($dt, 4, 2)"/>
								<xsl:variable name="sec" select="substring($dt, 7)"/>
								<xsl:if
									test="$hour &lt;= 23 and                                    $min &lt;= 59 and                                    $sec &lt;= 60">
									<xsl:call-template name="date:_format-date">
										<xsl:with-param name="year" select="'NaN'"/>
										<xsl:with-param name="month" select="'NaN'"/>
										<xsl:with-param name="day" select="'NaN'"/>
										<xsl:with-param name="hour" select="$hour"/>
										<xsl:with-param name="minute" select="$min"/>
										<xsl:with-param name="second" select="$sec"/>
										<xsl:with-param name="timezone" select="$timezone"/>
										<xsl:with-param name="pattern" select="$pattern"/>
										<xsl:with-param name="lang-id" select="$lang-id"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="year"
									select="substring($dt, 1, 4) * (($neg * -2) + 1)"/>
								<xsl:choose>
									<xsl:when test="not(number($year))"/>
									<xsl:when test="$dt-length = 4">
										<xsl:call-template name="date:_format-date">
											<xsl:with-param name="year" select="$year"/>
											<xsl:with-param name="timezone" select="$timezone"/>
											<xsl:with-param name="pattern" select="$pattern"/>
											<xsl:with-param name="lang-id" select="$lang-id"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="substring($dt, 5, 1) = '-'">
										<xsl:variable name="month" select="substring($dt, 6, 2)"/>
										<xsl:choose>
											<xsl:when test="not($month &lt;= 12)"/>
											<xsl:when test="$dt-length = 7">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="substring($dt, 8, 1) = '-'">
												<xsl:variable name="day"
												select="substring($dt, 9, 2)"/>
												<xsl:if test="$day &lt;= 31">
												<xsl:choose>
												<xsl:when test="$dt-length = 10">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="day" select="$day"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
												</xsl:when>
												<xsl:when
												test="substring($dt, 11, 1) = 'T' and                                                        substring($dt, 14, 1) = ':' and                                                        substring($dt, 17, 1) = ':'">
												<xsl:variable name="hour"
												select="substring($dt, 12, 2)"/>
												<xsl:variable name="min"
												select="substring($dt, 15, 2)"/>
												<xsl:variable name="sec"
												select="substring($dt, 18)"/>
												<xsl:if
												test="$hour &lt;= 23 and                                                         $min &lt;= 59 and                                                         $sec &lt;= 60">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="day" select="$day"/>
												<xsl:with-param name="hour" select="$hour"/>
												<xsl:with-param name="minute" select="$min"/>
												<xsl:with-param name="second" select="$sec"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="string(number(substring($dt,5,1)))!='NaN'">
										<xsl:variable name="month" select="substring($dt, 5, 2)"/>
										<xsl:choose>
											<xsl:when test="not($month &lt;= 12)"/>
											<xsl:when test="$dt-length = 6">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="day"
												select="substring($dt, 7, 2)"/>
												<xsl:if test="$day &lt;= 31">
												<xsl:choose>
												<xsl:when test="$dt-length = 8">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="day" select="$day"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
												</xsl:when>
												<xsl:when
												test="substring($dt, 9, 1) = 'T' and  substring($dt, 12, 1) = ':' and  substring($dt, 15, 1) = ':'">
												<xsl:variable name="hour"
												select="substring($dt, 10, 2)"/>
												<xsl:variable name="min"
												select="substring($dt, 13, 2)"/>
												<xsl:variable name="sec"
												select="substring($dt, 16)"/>
												<xsl:if
												test="$hour &lt;= 23 and                                                         $min &lt;= 59 and                                                         $sec &lt;= 60">
												<xsl:call-template name="date:_format-date">
												<xsl:with-param name="year" select="$year"/>
												<xsl:with-param name="month" select="$month"/>
												<xsl:with-param name="day" select="$day"/>
												<xsl:with-param name="hour" select="$hour"/>
												<xsl:with-param name="minute" select="$min"/>
												<xsl:with-param name="second" select="$sec"/>
												<xsl:with-param name="timezone" select="$timezone"/>
												<xsl:with-param name="pattern" select="$pattern"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												</xsl:call-template>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$formatted" disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template name="date:_format-date">
		<xsl:param name="year"/>
		<xsl:param name="month" select="1"/>
		<xsl:param name="day" select="1"/>
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:param name="second" select="0"/>
		<xsl:param name="timezone" select="'Z'"/>
		<xsl:param name="pattern" select="''"/>
		<xsl:param name="lang-id" select="'en_US'"/>
		<xsl:variable name="char" select="substring($pattern, 1, 1)"/>
		<xsl:choose>
			<xsl:when test="not($pattern)"/>
			<xsl:when test="$char = &quot;'&quot;">
				<xsl:choose>
					<xsl:when test="substring($pattern, 2, 1) = &quot;'&quot;">
						<xsl:text>'</xsl:text>
						<xsl:call-template name="date:_format-date">
							<xsl:with-param name="year" select="$year"/>
							<xsl:with-param name="month" select="$month"/>
							<xsl:with-param name="day" select="$day"/>
							<xsl:with-param name="hour" select="$hour"/>
							<xsl:with-param name="minute" select="$minute"/>
							<xsl:with-param name="second" select="$second"/>
							<xsl:with-param name="timezone" select="$timezone"/>
							<xsl:with-param name="pattern" select="substring($pattern, 3)"/>
							<xsl:with-param name="lang-id" select="$lang-id"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="literal-value"
							select="substring-before(substring($pattern, 2), &quot;'&quot;)"/>
						<xsl:value-of select="$literal-value"/>
						<xsl:call-template name="date:_format-date">
							<xsl:with-param name="year" select="$year"/>
							<xsl:with-param name="month" select="$month"/>
							<xsl:with-param name="day" select="$day"/>
							<xsl:with-param name="hour" select="$hour"/>
							<xsl:with-param name="minute" select="$minute"/>
							<xsl:with-param name="second" select="$second"/>
							<xsl:with-param name="timezone" select="$timezone"/>
							<xsl:with-param name="pattern"
								select="substring($pattern, string-length($literal-value) + 2)"/>
							<xsl:with-param name="lang-id" select="$lang-id"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when
				test="not(contains('abcdefghjiklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', $char))">
				<xsl:value-of select="$char"/>
				<xsl:call-template name="date:_format-date">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="hour" select="$hour"/>
					<xsl:with-param name="minute" select="$minute"/>
					<xsl:with-param name="second" select="$second"/>
					<xsl:with-param name="timezone" select="$timezone"/>
					<xsl:with-param name="pattern" select="substring($pattern, 2)"/>
					<xsl:with-param name="lang-id" select="$lang-id"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(contains('GyMdhHmsSEDFOwWakKz', $char))">
				<xsl:message> Invalid token in format string: <xsl:value-of select="$char"
					/></xsl:message>
				<xsl:call-template name="date:_format-date">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="hour" select="$hour"/>
					<xsl:with-param name="minute" select="$minute"/>
					<xsl:with-param name="second" select="$second"/>
					<xsl:with-param name="timezone" select="$timezone"/>
					<xsl:with-param name="pattern" select="substring($pattern, 2)"/>
					<xsl:with-param name="lang-id" select="$lang-id"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="next-different-char"
					select="substring(translate($pattern, $char, ''), 1, 1)"/>
				<xsl:variable name="pattern-length">
					<xsl:choose>
						<xsl:when test="$next-different-char">
							<xsl:value-of
								select="string-length(substring-before($pattern, $next-different-char))"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($pattern)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$char = 'G'">
						<xsl:choose>
							<xsl:when test="string($year) = 'NaN'"/>
							<xsl:when test="$year &gt; 0">AD</xsl:when>
							<xsl:otherwise>BC</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$char = 'M'">
						<xsl:choose>
							<xsl:when test="string($month) = 'NaN'"/>
							<xsl:when test="$pattern-length &gt;= 3">
								<xsl:variable name="month-node">
									<xsl:call-template name="date:_get-month">
										<xsl:with-param name="month" select="number($month)"/>
										<xsl:with-param name="lang-id" select="$lang-id"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$pattern-length &gt;= 4">
										<xsl:value-of
											select="substring-before(normalize-space($month-node), ';')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="substring-after(normalize-space($month-node), ';')"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$pattern-length = 2">
								<xsl:value-of select="format-number($month, '00')"/>
							</xsl:when>
							<xsl:when test="$pattern-length = 1">
								<xsl:value-of select="format-number($month, '0')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$month"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$char = 'E'">
						<xsl:choose>
							<xsl:when
								test="string($year) = 'NaN' or string($month) = 'NaN' or string($day) = 'NaN'"/>
							<xsl:otherwise>
								<xsl:variable name="month-days">
									<xsl:call-template name="date:_get-days-elapsed">
										<xsl:with-param name="month" select="number($month)"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="days"
									select="number($month-days) + $day + boolean(((not($year mod 4) and $year mod 100) or not($year mod 400)) and $month &gt; 2)"/>
								<xsl:variable name="y-1" select="$year - 1"/>
								<xsl:variable name="dow"
									select="(($y-1 + floor($y-1 div 4) -                                              floor($y-1 div 100) + floor($y-1 div 400) +                                              $days)                                              mod 7) + 1"/>
								<xsl:variable name="day-node">
									<xsl:call-template name="date:_get-day">
										<xsl:with-param name="day" select="number($dow)"/>
										<xsl:with-param name="lang-id" select="$lang-id"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$pattern-length &gt;= 4">
										<xsl:value-of
											select="substring-before(normalize-space($day-node),';')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="substring-after(normalize-space($day-node),';')"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$char = 'a'">
						<xsl:choose>
							<xsl:when test="string($hour) = 'NaN'"/>
							<xsl:when test="$hour &gt;= 12">PM</xsl:when>
							<xsl:otherwise>AM</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$char = 'z'">
						<xsl:choose>
							<xsl:when test="$timezone = 'Z'">UTC</xsl:when>
							<xsl:otherwise> UTC<xsl:value-of select="$timezone"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="padding">
							<xsl:choose>
								<xsl:when test="$pattern-length &gt; 10">
									<xsl:call-template name="str:padding">
										<xsl:with-param name="length" select="$pattern-length"/>
										<xsl:with-param name="chars" select="'0'"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="substring('0000000000', 1, $pattern-length)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$char = 'O'">
								<xsl:choose>
									<xsl:when test="string($day) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:variable name="day-ordinal">
											<xsl:call-template name="str:get-number-ordinal">
												<xsl:with-param name="number" select="$day"/>
												<xsl:with-param name="lang-id" select="$lang-id"/>
												<xsl:with-param name="type" select="'date'"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="$day-ordinal"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'y'">
								<xsl:choose>
									<xsl:when test="string($year) = 'NaN'"/>
									<xsl:when test="$pattern-length &gt; 2">
										<xsl:value-of select="format-number($year, $padding)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="format-number(substring($year, string-length($year) - 1), $padding)"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'd'">
								<xsl:choose>
									<xsl:when test="string($day) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="format-number($day, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'h'">
								<xsl:variable name="h" select="$hour mod 12"/>
								<xsl:choose>
									<xsl:when test="string($hour) = 'NaN'"/>
									<xsl:when test="$h">
										<xsl:value-of select="format-number($h, $padding)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(12, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'H'">
								<xsl:choose>
									<xsl:when test="string($hour) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="format-number($hour, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'k'">
								<xsl:choose>
									<xsl:when test="string($hour) = 'NaN'"/>
									<xsl:when test="$hour">
										<xsl:value-of select="format-number($hour, $padding)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(24, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'K'">
								<xsl:choose>
									<xsl:when test="string($hour) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="format-number($hour mod 12, $padding)"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'm'">
								<xsl:choose>
									<xsl:when test="string($minute) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="format-number($minute, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 's'">
								<xsl:choose>
									<xsl:when test="string($second) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="format-number($second, $padding)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'S'">
								<xsl:choose>
									<xsl:when test="string($second) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of
											select="format-number(substring-after($second, '.'), $padding)"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$char = 'F'">
								<xsl:choose>
									<xsl:when test="string($day) = 'NaN'"/>
									<xsl:otherwise>
										<xsl:value-of select="floor($day div 7) + 1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when
								test="string($year) = 'NaN' or string($month) = 'NaN' or string($day) = 'NaN'"/>
							<xsl:otherwise>
								<xsl:variable name="month-days">
									<xsl:call-template name="date:_get-days-elapsed">
										<xsl:with-param name="month" select="number($month)"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="days"
									select="number($month-days) + $day + boolean(((not($year mod 4) and $year mod 100) or not($year mod 400)) and $month &gt; 2)"/>
								<xsl:choose>
									<xsl:when test="$char = 'D'">
										<xsl:value-of select="format-number($days, $padding)"/>
									</xsl:when>
									<xsl:when test="$char = 'w'">
										<xsl:call-template name="date:_week-in-year">
											<xsl:with-param name="days" select="$days"/>
											<xsl:with-param name="year" select="$year"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="$char = 'W'">
										<xsl:variable name="y-1" select="$year - 1"/>
										<xsl:variable name="day-of-week"
											select="(($y-1 + floor($y-1 div 4) -                                                   floor($y-1 div 100) + floor($y-1 div 400) +                                                   $days)                                                    mod 7) + 1"/>
										<xsl:choose>
											<xsl:when test="($day - $day-of-week) mod 7">
												<xsl:value-of
												select="floor(($day - $day-of-week) div 7) + 2"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="floor(($day - $day-of-week) div 7) + 1"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="date:_format-date">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="hour" select="$hour"/>
					<xsl:with-param name="minute" select="$minute"/>
					<xsl:with-param name="second" select="$second"/>
					<xsl:with-param name="timezone" select="$timezone"/>
					<xsl:with-param name="pattern" select="substring($pattern, $pattern-length + 1)"/>
					<xsl:with-param name="lang-id" select="$lang-id"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="date:_week-in-year">
		<xsl:param name="days"/>
		<xsl:param name="year"/>
		<xsl:variable name="y-1" select="$year - 1"/>
		<xsl:variable name="day-of-week"
			select="($y-1 + floor($y-1 div 4) -                           floor($y-1 div 100) + floor($y-1 div 400) +                           $days)                           mod 7"/>
		<xsl:variable name="dow">
			<xsl:choose>
				<xsl:when test="$day-of-week">
					<xsl:value-of select="$day-of-week"/>
				</xsl:when>
				<xsl:otherwise>7</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="start-day" select="($days - $dow + 7) mod 7"/>
		<xsl:variable name="week-number" select="floor(($days - $dow + 7) div 7)"/>
		<xsl:choose>
			<xsl:when test="$start-day &gt;= 4">
				<xsl:value-of select="$week-number + 1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="not($week-number)">
						<xsl:call-template name="date:_week-in-year">
							<xsl:with-param name="days"
								select="365 + ((not($y-1 mod 4) and $y-1 mod 100) or not($y-1 mod 400))"/>
							<xsl:with-param name="year" select="$y-1"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$week-number"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ========================= END OF STYLESHEET ================================================================================================================================x -->

	<!-- SECTION TEMPLATES -->

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
				<xsl:when test="$isAddAlone=1">
					<xsl:choose>
						<xsl:when test="$yodaFlag=1 and $draft='NotRegistered' and $passOrfail = 'PASS'">
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
						<xsl:when
							test="(($draft='NotCertified' or $draft='InterceptError')  or (($draft='None' or $draft='NotRegistered') and $passOrfail='FAIL'))">
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
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$draft='NotRegistered' and $passOrfail = 'PASS' ">
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
						<xsl:when
							test="($draft='NotCertified' or $draft='InterceptError')  or (($draft='None' or $draft='NotRegistered') and $passOrfail='FAIL')">
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
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<!-- XML INTERCEPT -->
	<xsl:template match="Errors" mode="XmlIntercept">
		<fo:table border-collapse="collapse" keep-together.within-column="always" margin-top="0in"
			table-layout="fixed" width="100%">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<fo:table-body>
				<fo:table-row height="0.224in" overflow="hidden">
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block text-align="center" font-size="larger">** NOTICE **</fo:block>
						<fo:block text-align="center">The results for this run are invalid and
							cannot be used for compliance submittals.</fo:block>
						<fo:block>
							<fo:leader/>
						</fo:block>
						<fo:block text-align="center">
							<xsl:value-of select="Error/MessageBefore"/>
						</fo:block>
						<fo:block>
							<fo:leader/>
						</fo:block>
						<fo:block text-align="center">
							<xsl:value-of select="Error/MessageAfter"/>
						</fo:block>
						<fo:block>
							<fo:leader/>
						</fo:block>
						<!--<xsl:for-each select="../../Errors/Error">
								<fo:block text-align="center"><xsl:value-of select="concat('IAQ Fan Type in ',DwellUnitTypeName,' for ',IAQFanName)"/></fo:block>
								<!-\-<fo:block text-align="center"><xsl:value-of select="concat('Object:',DwellUnitTypeName,';',IAQFanName)"/></fo:block>-\->
							</xsl:for-each>						-->
						<!--<fo:block text-align="center">This item may be located in a different place in other software.</fo:block>-->
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

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
								select="substring('YN',              2 - boolean(//Model[@Name='Proposed']/Proj/BuildingTypeRpt),              1)"/>
							<!-- Method from #727 beyond -->
							<xsl:if test="$v727='Y'">
								<xsl:variable name="bldg_type"
									select="//Model[@Name='Proposed']/Proj/IsMultiFamily"/>
								<xsl:choose>
									<xsl:when test="$bldg_type &lt; 0.5">Single Family</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="//Model[@Name='Proposed']/Proj/BuildingTypeRpt"
										/>
									</xsl:otherwise>
								</xsl:choose>
								<!-- Old method -->
							</xsl:if>
							<xsl:if test="$v727='N'">
								<xsl:variable name="bldg_type"
									select="//Model[@Name='Proposed']/Proj/IsMultiFamily"/>
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
								select="sum(//Model[@Name='Proposed']/Proj/Zone/FloorArea)"/>
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
							<xsl:value-of select="count(//Model[@Name='Proposed']/Proj/Zone)"/>
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
								select="sum(//Model[@Name='Proposed']/Proj/Zone/SlabFloorArea)"/>
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
						<fo:block>Addition Cond. Floor Area(ft<fo:inline baseline-shift="super"
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
								<xsl:otherwise>
									<xsl:call-template name="na"/>
								</xsl:otherwise>
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
								select="(//Model[@Name='Proposed']/Proj/NatGasAvailable/text())"/>
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
								<xsl:otherwise>
									<xsl:call-template name="na"/>
								</xsl:otherwise>
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
								select="format-number(sum(//Model[@Name='Proposed']/Proj/Zone/RptTotCondZoneWinArea) div sum(//Model[@Name='Proposed']/Proj/Zone/FloorArea),'0.0%')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Display for Addition Alone-->
	<xsl:template match="Proj" mode="addAloneParms">
		<fo:table border-collapse="collapse" font-family="Arial Narrow" font-size="8pt"
			keep-together.within-column="always" margin-top="0in" table-layout="fixed" width="100%">
			<fo:table-column column-width="proportional-column-width(26.133)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(26.733)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(11.708)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.309)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.46)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.657)" column-number="6"/>
			<fo:table-body>
				<fo:table-row height="0.224in" overflow="hidden">
					<fo:table-cell number-columns-spanned="6" border="1pt solid black"
						display-align="center" font-weight="bold" line-height="115%" padding="2pt"
						text-align="left">
						<fo:block>ADDITION ALONE PROJECT ANALYSIS PARAMETERS</fo:block>
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
				<fo:table-row height="" overflow="hidden" font-weight="bold">
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Existing Area (excl. new addition) (ft<fo:inline
								baseline-shift="super" font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Addition Area (excl. existing) (ft<fo:inline
								baseline-shift="super" font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Total Area</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Existing Bedrooms</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Addition Bedrooms</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
						text-align="center">
						<fo:block>Total Bedrooms</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row display-align="center" text-align="center">
					<fo:table-cell border="1pt solid black" padding="2pt">
						<fo:block>
							<xsl:if test="string(AddAloneExistArea)">
								<xsl:value-of select="AddAloneExistArea"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(AddAloneAddedArea)">
								<xsl:value-of select="AddAloneAddedArea"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(AddAloneTotalArea)">
								<xsl:value-of select="AddAloneTotalArea"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(NumBedrooms)">
								<xsl:value-of select="NumBedrooms"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(NumAddBedrooms)">
								<xsl:value-of select="NumAddBedrooms"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(NumBedrooms + NumAddBedrooms)">
								<xsl:value-of select="NumBedrooms + NumAddBedrooms"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--CF1R_FeaturesList-->
	<xsl:template name="CF1R_FeaturesList">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="cell">
						<fo:block>COMPLIANCE RESULTS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>01</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="compliance_result"
								select="//Model[@Name='Standard']/Proj/EUseSummary[PassFail= 'FAIL']"/>
							<xsl:if test="normalize-space($compliance_result) != ''"> Bulding Does
								Not Comply</xsl:if>
							<xsl:if test="normalize-space($compliance_result) = ''"> Building
								Complies with Computer Performance</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>02</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellC">
						<fo:block>
							<xsl:variable name="herSection1"
								select="//Model[@Name='Proposed']/Proj/HERSCool"/>
							<xsl:variable name="herSection2"
								select="//Model[@Name='Proposed']/Proj/HERSProj"/>
							<xsl:variable name="herSection3"
								select="//Model[@Name='Proposed']/Proj/HERSDHW"/>
							<xsl:variable name="herSection4"
								select="//Model[@Name='Proposed']/Proj/HERSDist"/>
							<xsl:choose>
								<xsl:when
									test="$herSection1 != '' or herSection2 !='' or herSection3 !='' or herSection4 !=''"
									> This building incorporates features that require field testing
									and/or verification by a certified HERS rater under the
									supervision of a CEC-approved HERS provider. </xsl:when>
								<xsl:otherwise> This building DOES NOT require HERS Verification
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:variable name="spcFeature3"
					select="sum(//Model[@Name='Proposed']/SpeclFtr/*[.=1])"/>
				<xsl:if test="$spcFeature3&gt;=1">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>03</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="cellC">
							<fo:block>
								<xsl:variable name="spcFeature2"
									select="sum(//Model[@Name='Proposed']/SpeclFtr/*[.=1])"/>
								<xsl:choose>
									<xsl:when test="$spcFeature2&gt;=1">This building incorporates
										one or more Special Features shown below</xsl:when>
									<xsl:otherwise> </xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="$isExpired=1">
					<fo:table-row xsl:use-attribute-sets="headerRow">
						<fo:table-cell number-columns-spanned="2"  padding-top="5pt">
							<fo:block text-align="center">
								<xsl:value-of select="concat('This compliance analysis is valid only for permit applications through ',$Expiry)"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>

			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--Cardinal Orientation Results-->
	<xsl:template match="EUseSummary" mode="CardinalOrientationResults">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(29.853)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.053)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(19.374)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.482)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.238)" column-number="5"/>
			<fo:table-footer>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when test="current()[Name='West Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal"
											select="current()[Name='West Facing']/Enduse3[@index=3]"/>
										<xsl:with-param name="stdVal"
											select="current()[Name='West Facing']/Enduse3[@index=6]"
										/>
									</xsl:call-template>
									<!--<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6]),'0.0%')"
									/>-->
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal"
											select="current()[Name='West Facing']/Enduse3[@index=3]"/>
										<xsl:with-param name="stdVal"
											select="current()[Name='West Facing']/Enduse3[@index=6]"
										/>
									</xsl:call-template>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="center"
						padding="2pt" text-align="center"><fo:block><fo:inline>
								<xsl:if
									test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='West Facing'])">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='West Facing']"
									/>
								</xsl:if>
							</fo:inline> Compliance Total</fo:block> - </fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-footer>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block>ENERGY USE SUMMARY</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Energy Use</fo:block>
						<fo:block font-weight="bolder">(kTDV/ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>-yr)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Standard</fo:block>
						<fo:block font-weight="bolder">Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Proposed</fo:block>
						<fo:block font-weight="bolder">Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Compliance</fo:block>
						<fo:block font-weight="bolder">Margin</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Percent</fo:block>
						<fo:block font-weight="bolder">Improvement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when test="current()[Name='North Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal"
											select="current()[Name='North Facing']/Enduse2[@index=3]"/>
										<xsl:with-param name="stdVal"
											select="current()[Name='North Facing']/Enduse2[@index=6]"
										/>
									</xsl:call-template>
									<!--<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6]),'0.0%')"
									/>-->
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='North Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='North Facing']"
								/>
							</xsl:if> <fo:inline>Compliance Total</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='East Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='East Facing']"
								/>
							</xsl:if> <fo:inline>Compliance Total</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='South Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='South Facing']"
								/>
							</xsl:if><fo:inline> Compliance Total</fo:inline>  </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>


	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Cardinal Orientation Results.xfc-->
	<xsl:template
		name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Cardinal_Orientation_Results_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(29.853)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.053)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(19.374)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(17.482)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(14.238)" column-number="5"/>
			<fo:table-footer>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-left-color="black"
						border-left-style="solid" border-left-width="1pt" display-align="center"
						padding="2pt" text-align="center"><fo:block><fo:inline>
								<xsl:if
									test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='West Facing'])">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='West Facing']"
									/>
								</xsl:if>
							</fo:inline> Compliance Total</fo:block> - </fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-bottom-color="black" border-bottom-style="solid"
						border-bottom-width="1pt" border-right-color="black"
						border-right-style="solid" border-right-width="1pt" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-footer>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block>ENERGY USE SUMMARY</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Energy Use</fo:block>
						<fo:block font-weight="bolder">(kTDV/ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>-yr)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Standard</fo:block>
						<fo:block font-weight="bolder">Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Proposed</fo:block>
						<fo:block font-weight="bolder">Design</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Compliance</fo:block>
						<fo:block font-weight="bolder">Margin</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block font-weight="bolder">Percent</fo:block>
						<fo:block font-weight="bolder">Improvement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='North Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='North Facing']"
								/>
							</xsl:if> <fo:inline>Compliance Total</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='East Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='East Facing']"
								/>
							</xsl:if> <fo:inline>Compliance Total</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='East Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>IAQ Ventilation</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse3[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Water Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse5[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>PV Credit</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>----</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='North Facing']/Enduse13[@index=3]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=3]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=7]">
									<xsl:value-of
										select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse13[@index=7]"
									/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>---- </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row font-weight="bold">
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='South Facing'])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Name[text()='South Facing']"
								/>
							</xsl:if><fo:inline> Compliance Total</fo:inline>  </fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell display-align="center" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='South Facing']/Enduse11[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" border-top-color="black" border-top-style="solid"
						border-top-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse1[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell border-left-color="black" border-left-style="solid"
						border-left-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>Space Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-right-color="black" border-right-style="solid"
						border-right-width="1pt" display-align="center" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary[Name='West Facing']/Enduse2[@index=6]),'0.0%')"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component C:\CBECC-Res Templates\NC\NC_DesignRating-Cardinal_2016-2.0.xfc-->
	<xsl:template name="EDR_Cardinal">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(7.073)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(22.25)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(13.367)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(12.931)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(23.105)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(21.274)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>ENERGY DESIGN RATING</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="numberCellB"
						padding-after="1">
						<fo:block text-align="left">Energy Design Rating (EDR) is an alternate way
							to express the energy performance of a building using a scoring system
							where 100 represents the energy performance of the Residential Energy
							Services (RESNET) reference home characterization of the 2006
							International Energy Conservation Code (IECC) with California modeling assumptions. A score of zero
							represents the energy performance of a building that combines high
							levels of energy efficiency with renewable generation to"zero out" its
							TDV energy. Because EDR includes consideration of components not
							regulated by Title 24, Part 6 (such as domestic appliances and consumer
							electronics), it is not used to show compliance with Part 6 but may
							instead be used by local jurisdictions pursuing local ordinances under
							Title 24, Part 11 (CALGreen).</fo:block>
						<fo:block text-align="left">As a Standard Design building under the 2016
							Building Energy Efficiency Standards is significantly more efficient
							than the baseline EDR building, the EDR of the Standard Design building
							is provided for Information. Similarly, the EDR score of the Proposed
							Design is provided separately from the EDR value of installed PV so that
							the effects of efficiency and renewable energy can both be
							seen</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<fo:inline font-weight="bold">EDR of Standard Efficiency</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>EDR of Proposed Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<fo:inline font-weight="bold">EDR Value of Proposed PV +
								Battery</fo:inline>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<fo:inline font-weight="bold">Final Proposed EDR </fo:inline>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>North</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<fo:block>
								<xsl:if
									test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingNoPV,'0.0'))">
									<xsl:value-of
										select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingNoPV,'0.0')"
									/>
								</xsl:if>
							</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>East</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingNoPV,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingNoPV,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>South</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingNoPV,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingNoPV,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>West</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingNoPV,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingNoPV,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary[contains(Name,'Worst')]/MeetsTier1&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block text-align="left">Design meets Tier 1 requirement of 15% or
							greater code compliance margin (CALGreen A4.203.1.2.1) and QII
							verification prerequisite.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary[contains(Name,'Worst')]/MeetsTier2&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block text-align="left">
							<fo:block>Design meets Tier 2 requirement of 30% or greater code
								compliance margin (CALGreen A4.203.1.2.2) and QII verification
								prerequisite.</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row overflow="hidden">
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary[contains(Name,'Worst')]/MeetsZNETier&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block text-align="left">
							<xsl:value-of
								select="concat('Design meets Zero Net Energy (ZNE) Design Designation requirement for ',//Model[@Name='Proposed']/Proj/BuildingTypeRpt,' in climate zone ',//Model[@Name='Proposed']/Proj/ClimateZone,' (CALGreen A4.203.1.2.3) including on-site photovoltaic (PV) renewable energy generation sufficient to achieve a Final Energy Design Rating (EDR) of zero or less. The PV System must be verified.')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:if
					test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes | //Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="6" display-align="center"
							text-align="center" border-top="1pt solid black"
							border-left="1pt solid black" border-right="1pt solid black"
							font-weight="bold" padding="2pt">
							<fo:block text-align="left">Notes:</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<!-- If there are ResultsNotes -->
				<xsl:if test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="6" display-align="center"
							text-align="center" border-left="1pt solid black"
							border-right="1pt solid black" font-weight="bold" padding-left="2">
							<fo:block text-align="left">
								<xsl:call-template name="featureMessage">
									<xsl:with-param name="message"
										select="concat(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/Name,' - ',//Model[@Name='DesignRating']/Proj/EUseSummary[Name='North Facing']/ResultsNotes)"
									/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="6" display-align="center"
							text-align="center" border-left="1pt solid black"
							border-right="1pt solid black" font-weight="bold" padding-left="2">
							<fo:block text-align="left">
								<xsl:call-template name="featureMessage">
									<xsl:with-param name="message"
										select="concat(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/Name,' - ',//Model[@Name='DesignRating']/Proj/EUseSummary[Name='East Facing']/ResultsNotes)"
									/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="6" display-align="center"
							text-align="center" border-left="1pt solid black"
							border-right="1pt solid black" font-weight="bold" padding-left="2">
							<fo:block text-align="left">
								<xsl:call-template name="featureMessage">
									<xsl:with-param name="message"
										select="concat(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/Name,' - ',//Model[@Name='DesignRating']/Proj/EUseSummary[Name='South Facing']/ResultsNotes)"
									/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="6" display-align="center"
							text-align="center" border-left="1pt solid black"
							border-right="1pt solid black" font-weight="bold" padding-left="2">
							<fo:block text-align="left">
								<xsl:call-template name="featureMessage">
									<xsl:with-param name="message"
										select="concat(//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/Name,' - ',//Model[@Name='DesignRating']/Proj/EUseSummary[Name='West Facing']/ResultsNotes)"
									/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="6" display-align="center"
						text-align="center" border-bottom="1pt solid black"
						border-left="1pt solid black" border-right="1pt solid black"
						font-weight="bold" padding-left="2">
						<fo:block text-align="left">
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/AllowExcessPVEDR&gt;0">
									<xsl:call-template name="featureMessage">
										<xsl:with-param name="message"
											select="concat('Excess PV Generation EDR Credit: ',//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg)"
										/>
									</xsl:call-template>
									<!--<xsl:value-of select="concat('Excess PV Generation EDR Credit: ',//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg)"/>-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="featureMessage">
										<xsl:with-param name="message"
											select="//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg"
										/>
									</xsl:call-template>
									<!--<xsl:value-of select="//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg"/>-->
								</xsl:otherwise>
							</xsl:choose>

						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component C:\CBECC-Res Templates\NC\NC_DesignRating-PVDetSimp_Inputs-2016.xfc-->
	<xsl:template name="EDR_PV_Simple">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(14.67)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(28.477)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(6.872)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(10.73)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(9.38)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.103)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9.415)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.352)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
						<fo:block>
							<xsl:value-of
								select="concat('ENERGY DESIGN RATING PV SYSTEM INPUTS - ',translate($pvInputType,$lower,$upper))"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>DC System Size (kWdc)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Module Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>CFI</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Azimuth (deg)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Tilt Input</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Array Angle (deg)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Tilt:<fo:block/> (x in 12)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Inverter Eff. (%)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when test="$pvRowCount &gt;0">
										<xsl:value-of select="$sysSize1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when test="$pvRowCount &gt;0 and $sysSize1&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/Proj/PVWModuleType[@index=0]"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when test="$pvRowCount&gt;0 and $cfi1=1">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when
										test="$pvRowCount &gt;0 and $cfi1 = 0 and $sysSize1&gt;0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/Proj/PVWAzm[@index=0]"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when
										test="$pvRowCount &gt;0 and $cfi1 = 0 and $sysSize1 &gt; 0">
										<xsl:value-of
											select="//Model[@Name='Proposed']/Proj/PVWArrayTiltInput[@index=0]"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when
										test="$pvRowCount &gt;0 and $cfi1 = 0 and $sysSize1 &gt; 0">
										<xsl:value-of
											select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltDeg[@index=0],'0.0')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when
										test="$pvRowCount &gt;0 and $cfi1 = 0 and $sysSize1 &gt; 0">
										<xsl:value-of
											select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltPitch[@index=0],'0.0')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if test="$pvRowCount &gt; 0">
								<xsl:choose>
									<xsl:when
										test="$pvRowCount &gt;0 and $sysSize1 &gt; 0 and $pvInputType='Detailed'">
										<xsl:value-of
											select="//Model[@Name='Proposed']/Proj/PVWInverterEff[@index=0]"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:if test="$pvRowCount &gt; 1">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;1">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=1]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;1 and $sysSize2 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWModuleType[@index=1]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$pvRowCount&gt;1 and $cfi2=1">
										<xsl:call-template name="drawCheckedSquare"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="drawSquare"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;1 and $cfi2 = 0 and $sysSize2 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWAzm[@index=1]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block text-align="center">
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;1 and $cfi2 = 0 and $sysSize2 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWArrayTiltInput[@index=1]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block text-align="center">
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;1 and $cfi2 = 0 and $sysSize2 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltDeg[@index=1],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;1 and $cfi2 = 0 and $sysSize2 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltPitch[@index=1],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block text-align="center">
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;1 and $sysSize2 &gt; 0 and $pvInputType='Detailed'">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWInverterEff[@index=1]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="$pvRowCount &gt; 2">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount&gt;2">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=2]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;2 and $sysSize3 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWModuleType[@index=2]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$pvRowCount&gt;2 and $cfi3=1">
										<xsl:call-template name="drawCheckedSquare"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="drawSquare"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;2 and $cfi3 = 0 and $sysSize3 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWAzm[@index=2]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;2 and $cfi3 = 0 and $sysSize3 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWArrayTiltInput[@index=2]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;2 and $cfi3 = 0 and $sysSize3 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltDeg[@index=2],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;2 and $cfi3 = 0 and $sysSize3 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltPitch[@index=2],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;2 and $sysSize3 &gt; 0 and $pvInputType='Detailed'">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWInverterEff[@index=2]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="$pvRowCount &gt; 3">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;3">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=3]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;3 and $sysSize4 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWModuleType[@index=3]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$pvRowCount &gt; 3 and $cfi4=1">
										<xsl:call-template name="drawCheckedSquare"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="drawSquare"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;3 and $cfi4 = 0 and $sysSize4 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWAzm[@index=3]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;3 and $cfi4 = 0 and $sysSize4 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWArrayTiltInput[@index=3]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;3 and $cfi4 = 0 and $sysSize4 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltDeg[@index=3],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;3 and $cfi4 = 0 and $sysSize4 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltPitch[@index=3],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;3 and $sysSize4 &gt; 0 and $pvInputType='Detailed'">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWInverterEff[@index=3]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<xsl:if test="$pvRowCount &gt; 4">
					<fo:table-row>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;4">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWDCSysSize[@index=4]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when test="$pvRowCount &gt;4 and $sysSize5 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWModuleType[@index=4]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$pvRowCount &gt; 4 and $cfi5=1">
										<xsl:call-template name="drawCheckedSquare"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="drawSquare"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;4 and $cfi5 = 0 and $sysSize5 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWAzm[@index=4]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;4 and $cfi5 = 0 and $sysSize5 &gt; 0">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWArrayTiltInput[@index=4]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;4 and $cfi5 = 0 and $sysSize5 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltDeg[@index=4],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;4 and $cfi5 = 0 and $sysSize5 &gt; 0">
											<xsl:value-of
												select="format-number(//Model[@Name='Proposed']/Proj/PVWArrayTiltPitch[@index=4],'0.0')"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCellB">
							<fo:block>
								<xsl:if test="$pvRowCount &gt; 0">
									<xsl:choose>
										<xsl:when
											test="$pvRowCount &gt;4 and $sysSize5 &gt; 0 and $pvInputType='Detailed'">
											<xsl:value-of
												select="//Model[@Name='Proposed']/Proj/PVWInverterEff[@index=4]"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component C:\CBECC-Res Templates\NC\NC_DesignRating-Single_2016-2.0.xfc-->
	<xsl:template name="EDR_Battery">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="cell">
						<fo:block>ENERGY DESIGN RATING BATTERY INPUTS</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="6" xsl:use-attribute-sets="numberCellB">
						<fo:block text-align="left">
							<xsl:value-of
								select="concat('The battery model does not currently include energy consumption for cooling the battery during charging in environments above 77','&#176;','F or to keep the battery from freezing in winter, if outdoors.')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Charging</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>Discharging</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Control</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Capacity (kWh)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Rate (kW)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Rate (kW)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of select="$batteryControl"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of select="//Model[@Name='DesignRating']/Proj/BattMaxCap"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of select="//Model[@Name='DesignRating']/Proj/BattChgEff"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of select="//Model[@Name='DesignRating']/Proj/BattMaxChgPwr"
							/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of select="//Model[@Name='DesignRating']/Proj/BattDschgEff"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:value-of
								select="//Model[@Name='DesignRating']/Proj/BattMaxDschgPwr"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:variable name="ktdvsft">
		<fo:block>kTDV/ft<fo:inline baseline-shift="super" font-size="smaller"
			>2</fo:inline>-yr</fo:block>
	</xsl:variable>

	<!--Single Orientation Results-->
	<xsl:template match="EUseSummary" mode="SingleOrientationResults">
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
							<xsl:variable name="compliance_result" select="(PassFail/text())"/>
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
				<xsl:if test="$isExpired=1">
					<fo:table-row xsl:use-attribute-sets="headerRow">
						<fo:table-cell number-columns-spanned="6"  padding-top="5pt">
							<fo:block text-align="center">
								<xsl:value-of select="concat('This compliance analysis is valid only for permit applications through ',$Expiry)"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
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
						<!--<fo:block>
							<xsl:value-of select="concat('Energy Use ',$ktdvsft)"/>
						</fo:block>-->
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
							<xsl:if test="string(Enduse1[@index=6])">
								<xsl:value-of select="Enduse1[@index=6]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse1[@index=3])">
								<xsl:value-of select="Enduse1[@index=3]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse1[@index=7])">
								<xsl:value-of select="Enduse1[@index=7]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>

								<xsl:when test="Enduse1[@index=6]=0">0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal" select="Enduse1[@index=3]"/>
										<xsl:with-param name="stdVal" select="Enduse1[@index=6]"/>
									</xsl:call-template>
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
							<xsl:if test="string(Enduse2[@index=6])">
								<xsl:value-of select="Enduse2[@index=6]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse2[@index=3])">
								<xsl:value-of select="Enduse2[@index=3]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse2[@index=7])">
								<xsl:value-of select="Enduse2[@index=7]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when test="Enduse2[@index=6]=0">0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal" select="Enduse2[@index=3]"/>
										<xsl:with-param name="stdVal" select="Enduse2[@index=6]"/>
									</xsl:call-template>
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
							<xsl:if test="string(Enduse3[@index=6])">
								<xsl:value-of select="Enduse3[@index=6]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse3[@index=3])">
								<xsl:value-of select="Enduse3[@index=3]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse3[@index=7])">
								<xsl:value-of select="Enduse3[@index=7]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when test="Enduse3[@index=6]=0">0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal" select="Enduse3[@index=3]"/>
										<xsl:with-param name="stdVal" select="Enduse3[@index=6]"/>
									</xsl:call-template>
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
							<xsl:if test="string(Enduse5[@index=6])">
								<xsl:value-of select="Enduse5[@index=6]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse5[@index=3])">
								<xsl:value-of select="Enduse5[@index=3]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:if test="string(Enduse5[@index=7])">
								<xsl:value-of select="Enduse5[@index=7]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when test="Enduse5[@index=6]=0">0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal" select="Enduse5[@index=3]"/>
										<xsl:with-param name="stdVal" select="Enduse5[@index=6]"/>
									</xsl:call-template>
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
								<xsl:when test="Enduse13[@index=3]">
									<xsl:value-of select="Enduse13[@index=3]"/>
								</xsl:when>
								<xsl:otherwise>----</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when test="Enduse13[@index=7]">
									<xsl:value-of select="Enduse13[@index=7]"/>
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
							<xsl:if test="string(Enduse11[@index=6])">
								<xsl:value-of select="Enduse11[@index=6]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(Enduse11[@index=3])">
								<xsl:value-of select="Enduse11[@index=3]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if test="string(Enduse11[@index=7])">
								<xsl:value-of select="Enduse11[@index=7]"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when test="Enduse11[@index=6]=0">0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getMargin">
										<xsl:with-param name="prpVal" select="Enduse11[@index=3]"/>
										<xsl:with-param name="stdVal" select="Enduse11[@index=6]"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component C:\CBECC-Res Templates\NC\NC_DesignRating-Single_2016-2.0.xfc-->
	<xsl:template name="EDR_Single2">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(6.768)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(17.585)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(26.85)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(25.077)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(23.72)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block text-align="center">ENERGY DESIGN RATING</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB"
						padding-after="1">
						<fo:block text-align="left">Energy Design Rating (EDR) is an alternate way
							to express the energy performance of a building using a scoring system
							where 100 represents the energy performance of the Residential Energy
							Services (RESNET) reference home characterization of the 2006
							International Energy Conservation Code (IECC) with California modeling assumptions. A score of zero
							represents the energy performance of a building that combines high
							levels of energy efficiency with renewable generation to"zero out" its
							TDV energy. Because EDR includes consideration of components not
							regulated by Title 24, Part 6 (such as domestic appliances and consumer
							electronics), it is not used to show compliance with Part 6 but may
							instead be used by local jurisdictions pursuing local ordinances under
							Title 24, Part 11 (CALGreen).</fo:block>
						<fo:block text-align="left">As a Standard Design building under the 2016
							Building Energy Efficiency Standards is significantly more efficient
							than the baseline EDR building, the EDR of the Standard Design building
							is provided for Information. Similarly, the EDR score of the Proposed
							Design is provided separately from the EDR value of installed PV so that
							the effects of efficiency and renewable energy can both be
							seen</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>EDR of Standard Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<fo:block>EDR of Proposed Efficiency</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>EDR Value of Proposed PV + Battery</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Final Proposed EDR </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingNoPV,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingNoPV,'0.0')"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsTier1 &gt; 0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block text-align="left">Design meets Tier 1 requirement of 15% or
							greater code compliance margin (CALGreen A4.203.1.2.1) and QII
							verification prerequisite.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsTier2 &gt; 0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block>
							<fo:block text-align="left">Design meets Tier 2 requirement of 30% or
								greater code compliance margin (CALGreen A4.203.1.2.2) and QII
								verification prerequisite.</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsZNETier&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block text-align="left">
							<xsl:value-of
								select="concat('Design meets Zero Net Energy (ZNE) Design Designation requirement for ',//Model[@Name='Proposed']/Proj/BuildingTypeRpt,' in climate zone ',//Model[@Name='Proposed']/Proj/ClimateZone,' (CALGreen A4.203.1.2.3) including on-site photovoltaic (PV) renewable energy generation sufficient to achieve a Final Energy Design Rating (EDR) of zero or less. The PV System must be verified.')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:if
					test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes | //Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="5" display-align="center"
							text-align="center" border-top="1pt solid black"
							border-left="1pt solid black" border-right="1pt solid black"
							font-weight="bold" padding-left="2">
							<fo:block text-align="left">Notes:</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<!-- If there is a ResultsNotes -->
				<xsl:if test="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes">
					<fo:table-row>
						<fo:table-cell number-columns-spanned="5" display-align="center"
							text-align="center" border-left="1pt solid black"
							border-right="1pt solid black" font-weight="bold" padding-left="2">
							<fo:block text-align="left">
								<xsl:call-template name="featureMessage">
									<xsl:with-param name="message"
										select="//Model[@Name='DesignRating']/Proj/EUseSummary/ResultsNotes"
									/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:if>
				<fo:table-row>
					<!--<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/AllowExcessPVEDR&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>-->
					<fo:table-cell number-columns-spanned="5" display-align="center"
						text-align="center" border-left="1pt solid black"
						border-right="1pt solid black" border-bottom="1pt solid black"
						font-weight="bold" padding-left="2">
						<fo:block text-align="left">
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/AllowExcessPVEDR&gt;0">
									<xsl:call-template name="featureMessage">
										<xsl:with-param name="message"
											select="concat('Excess PV Generation EDR Credit: ',//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg)"
										/>
									</xsl:call-template>
									<!--<xsl:value-of select="concat('Excess PV Generation EDR Credit: ',//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg)"/>-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="featureMessage">
										<xsl:with-param name="message"
											select="//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg"
										/>
									</xsl:call-template>
									<!--<xsl:value-of select="//Model[@Name='DesignRating']/Proj/MaxPropPVRatioMsg"/>-->
								</xsl:otherwise>
							</xsl:choose>

						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component C:\CBECC-Res Templates\NC\NC_DesignRating-Single_2016-2.0.xfc**********  DEPRECATED ************-->
	<xsl:template name="EDR_Single">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(6.768)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(17.585)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(26.85)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(25.077)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(23.72)" column-number="5"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="cell">
						<fo:block text-align="center">ENERGY DESIGN RATING</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="5" xsl:use-attribute-sets="numberCellB">
						<fo:block text-align="left">Energy Design Rating (EDR) is an alternate way
							to express the energy performance of a building using a scoring system
							where 100 represents the energy performance of the Residential Energy
							Services (RESNET) reference home characterization of the 2006
							International Energy Conservation Code (IECC) with California modeling assumptions. A score of zero
							represents the energy performance of a building that combines high
							levels of energy efficiency with renewable generation to"zero out" its
							TDV energy. Because EDR includes consideration of components not
							regulated by Title 24, Part 6 (such as domestic appliances and consumer
							electronics), it is not used to show compliance with Part 6 but may
							instead be used by local jurisdictions pursuing local ordinances under
							Title 24, Part 11 (CALGreen).</fo:block>
						<fo:block text-align="left"> </fo:block>
						<fo:block text-align="left">As a Standard Design building under the 2016
							Building Energy Efficiency Standards is significantly more efficient
							than the baseline EDR building, the EDR of the Standard Design building
							is provided for Information. Similarly, the EDR score of the Proposed
							Design is provided separately from the EDR value of installed PV so that
							the effects of efficiency and renewable energy can both be
							seen</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>EDR of Standard Efficiency</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<fo:block>EDR of Proposed Efficiency</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>EDR Value of Proposed PV + Battery</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>Final Proposed EDR </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingStd,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingStd,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingNoPV,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingNoPV,'0.0')"
								/>
							</xsl:if>  </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingPVOnly,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRatingPVOnly,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:if
								test="string(format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRating,'0.0'))">
								<xsl:value-of
									select="format-number(//Model[@Name='DesignRating']/Proj/EUseSummary/DesignRating,'0.0')"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsTier1 &gt; 0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block text-align="left">Design meets Tier 1 requirement of 15% or
							greater code compliance margin (CALGreen A4.203.1.2.1) and QII
							verification prerequisite.</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsTier2 &gt; 0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block>
							<fo:block text-align="left">Design meets Tier 2 requirement of 30% or
								greater code compliance margin (CALGreen A4.203.1.2.2) and QII
								verification prerequisite.</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="1" xsl:use-attribute-sets="numberCellB">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='DesignRating']/Proj/EUseSummary/MeetsZNETier&gt;0">
									<xsl:call-template name="drawCheckedSquare"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="drawSquare"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="4" display-align="center"
						text-align="center" border="1pt solid black" font-weight="bold"
						padding="2pt">
						<fo:block text-align="left">
							<xsl:value-of
								select="concat('Design meets Zero Net Energy (ZNE) Design Designation requirement for ',//Model[@Name='Proposed']/Proj/BuildingTypeRpt,' in climate zone ',//Model[@Name='Proposed']/Proj/ClimateZone,' (CALGreen A4.203.1.2.3) including on-site photovoltaic (PV) renewable energy generation sufficient to achieve a Final Energy Design Rating (EDR) of zero or less. The PV System must be verified.')"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
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
		<fo:table border-collapse="collapse" keep-together.within-column="always" margin-top="0in"
			table-layout="fixed" width="100%">
			<fo:table-column column-width="proportional-column-width(8.358)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(91.642)" column-number="2"/>
			<!-- It there reduced attic vent? -->
			<xsl:variable name="reducedVentArea"
				select="//Model[@Name='Proposed']/Proj/UnitClVentLowArea"/>
			<fo:table-body>
				<fo:table-row height="0.224in" overflow="hidden">
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
										<xsl:value-of select="concat('$has_feature: ',$has_feature)"
										/>
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

										<xsl:if test="$reducedVentArea=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="//Model[@Name='Proposed']/Proj/ClVentAtticRelMsg"
												/>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$reducedVentArea=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="//Model[@Name='Proposed']/Proj/ClVentAtticRelMsg"
												/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$reducedVentArea=0"> NO SPECIAL FEATURES
											REQUIRED </xsl:if>
									</xsl:otherwise>
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
						<xsl:with-param name="message">High quality insulation installation
							(QII)</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="LowBldgLkg=1">
					<xsl:call-template name="featureMessage">
						<xsl:with-param name="message">Building Envelope Air
							Leakage</xsl:with-param>
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
					<xsl:with-param name="message" select="$isNone"/>
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
				<fo:table-row height="0.224in" overflow="hidden">
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
						<xsl:variable name="test_fan"
							select="sum(HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/SCSysRpt/HVACFanRef and not($noCooling=1)]/HERSCheck]/AHUFanEff)
								or sum(HERSFan[Name=preceding-sibling::HVACFan[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACFanRef and not($noCooling=1)]/HERSCheck]/AHUFanEff)"/>
						<fo:block> </fo:block>
						<fo:block> Cooling System Verifications: </fo:block>
						<xsl:choose>
							<!-- MultiFamily -->
							<xsl:when test="$isMF=1">
								<!-- The rest of the cooling measures -->
								<xsl:variable name="test_cool">
									<xsl:choose>
										<xsl:when
											test="HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]/*[.=1]">
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
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$test_cool &gt;=1 or $test_fan &gt;=1 or $isAddAlone=1">
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
										<xsl:if test="($isAddAlone and HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1) or 
											($isAddAlone and HERSCool[Name=preceding-sibling::HVACCool[FloorAreaServed > 0]/HERSCheck]/AltACCharg=1)">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"><xsl:value-of select="HERSCool[Name=preceding-sibling::HVACHtPump[FloorAreaServed > 0]/HERSCheck]/AltACChargRptMsg"/></xsl:with-param>
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
											<xsl:with-param name="message" select="$isNone"/>
										</xsl:call-template>
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
												<xsl:with-param name="message">Duct
												Sealing</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/SCSysRpt/HVACDistRef]/HERSCheck]/AltDuctLeakage=1">
											<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="AltDuctLkgRptMsg"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/Zone/DwellUnit/CSysRpt/HVACDistRef]/HERSCheck]/DuctLocation=1">
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
											<xsl:with-param name="message" select="$isNone"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
								<!-- Water Heating -->
								<!--<xsl:variable name="test_dhw"
									select="HERSDHWSys[Name=preceding-sibling::DHWSys[Name=preceding-sibling::Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef and not(preceding-sibling::DHWSysRpt/DHWSysRef)]/HERSCheck]/*[.=1]"/>-->
								<fo:block> </fo:block>
								<fo:block>Domestic Hot Water System
									Verifications:<!--<fo:block> <xsl:value-of select="concat('$test_dhw: ',$test_dhw)"/> </fo:block>--></fo:block>

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
											<xsl:with-param name="message" select="$isNone"/>
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
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable><fo:block> </fo:block> Cooling System Verifications: <fo:block>
									<xsl:choose>
										<xsl:when test="$test_cool &gt;=1 or $test_fan &gt;=1 or $isAddAlone=1">
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
												<xsl:with-param name="message">Refrigerant
												Charge</xsl:with-param>
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
												<xsl:with-param name="message" select="$isNone"/>
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
											test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1]">
											<xsl:value-of
												select="sum(HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/*[.=1])"
											/>
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="altLeak" select="AltDuctLkgRptMsg"/>
								<fo:block> </fo:block>
								<fo:block> HVAC Distribution System Verifications:</fo:block>
								<fo:block>
									<xsl:choose>
										<xsl:when test="$test_dist &gt;=1 or $low_leak=1">
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLeakage=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message">Duct
												Sealing</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/AltDuctLeakage=1">
												<xsl:call-template name="featureMessage">
												<xsl:with-param name="message"
												select="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/AltDuctLkgRptMsg"
												/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocation=1">
												<xsl:variable name="dLoc"
												select="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/DuctLocRptMsg"/>
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
												test="HERSDist[Name=preceding-sibling::HVACDist[Name=preceding-sibling::Proj/SCSysRpt/HVACDistRef]/HERSCheck]/BuriedDucts=1">
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
												<xsl:with-param name="message" select="$isNone"/>
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
											<xsl:with-param name="message" select="$isNone"/>
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_CalGreenSummary.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_CalGreenSummary_xfc">
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
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell background-color="rgb(236,236,232)" border="1pt solid black"
						font-weight="bold" padding="2pt" text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:if
								test="string(//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=7])">
								<xsl:value-of
									select="//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=7]"
								/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border="1pt solid black" font-weight="bold" padding="2pt"
						text-align="center">
						<fo:block>
							<xsl:choose>
								<xsl:when
									test="//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]=0"
									>0.0%</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="format-number(1-(//Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=3] div //Model[@Name='Standard']/Proj/EUseSummary/Enduse10[@index=6]),'0.0%')"
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_BuildingFeatures-MF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_BuildingFeatures-MF_xfc">
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
							<xsl:value-of select="count(//Model[@Name='Proposed']/Proj/Zone)"/>
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
								select="//Model[@Name='Proposed']/DHWSys[Name=//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef]/CentralDHW"/>
							<xsl:choose>
								<xsl:when test="$isCentral=1">
									<xsl:value-of
										select="count(//Model[@Name='Proposed']/DHWSys[Name=//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt/DHWSysRef]/CentralDHW)"
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_BuildingFeatures-SF.xfc-->
	<xsl:template match="Proj" mode="BuildingFeatures">
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
						<fo:block>Conditioned Floor Area (ft<fo:inline
							baseline-shift="super" font-size="smaller">2</fo:inline>)</fo:block>
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
							<xsl:if test="string(Name)">
								<xsl:value-of select="Name"/>
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
							<xsl:if test="string(NumDwellingUnits)">
								<xsl:value-of select="NumDwellingUnits"/>
							</xsl:if>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:choose>
								<xsl:when test="IsAddAlone=1">
									<xsl:value-of select="NumBedrooms + NumAddBedrooms"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="NumBedrooms/text()"/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block>
							<xsl:value-of select="count(Zone)"/>
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
							<xsl:value-of
								select="count(//Model[@Name='Proposed']/DHWSys[count(DHWSysRpt) > 0])"
							/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>

	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Zone Features-SF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Zone_Features-SF_xfc">
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
								<xsl:variable name="znStatus" select="Status"/>
								<xsl:variable name="hvacStatus" select="HVACSysStatus"/>
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
									<xsl:when test="string(DHWSys1 | AltDHWSys1 | exDHWSys1)">
										<xsl:value-of select="DHWSys1 | AltDHWSys1 | exDHWSys1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:if test="string(DHWSys1 | AltDHWSys1)">
									<xsl:value-of select="DHWSys1 | AltDHWSys1"/>
								</xsl:if>-->
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="string(DHWSys2  | AltDHWSys2 | exDHWSys2)">
										<xsl:value-of select="DHWSys2  | AltDHWSys2 | exDHWSys2"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:if test="string(DHWSys2  | AltDHWSys2)">
									<xsl:value-of select="DHWSys2  | AltDHWSys2"/>
								</xsl:if>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Zone Features-MF.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Zone_Features-MF_xfc">
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
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Zone">
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Dwelling Unit Table.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Dwelling_Unit_Table_xfc">
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Dwelling Unit Types.xfc-->
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

	<!--Opaque Surfaces-->
	<xsl:template name="Opaque_Surfaces">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(18.299)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.306)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(16.959)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(8.166)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(7.623)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(9.345)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(13.922)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(6.38)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
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
						<fo:block>Window &amp; Door Area (ft<fo:inline baseline-shift="super"
								font-size="smaller">2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Tilt (deg)</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall | //Model[@Name='Proposed']/Proj/Zone/IntWall | //Model[@Name='Proposed']/Proj/Zone/CeilingBelowAttic | 
					//Model[@Name='Proposed']/Proj/Zone/ExteriorFloor | //Model[@Name='Proposed']/Proj/Zone/FloorOverCrawl | //Model[@Name='Proposed']/Proj/Zone/InteriorFloor | 
					//Model[@Name='Proposed']/Proj/Garage/ExtWall | //Model[@Name='Proposed']/Proj/Garage/IntWall | //Model[@Name='Proposed']/Proj/Garage/CeilingBelowAttic | 
					//Model[@Name='Proposed']/Proj/Garage/FloorOverCrawl | //Model[@Name='Proposed']/Proj/Garage/ExteriorFloor|//Model[@Name='Proposed']/Proj/Zone/InteriorFloor|
					//Model[@Name='Proposed']/Proj/Zone/InteriorCeiling | //Model[@Name='Proposed']/Proj/Zone/UndWall">
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
							<xsl:choose>
								<xsl:when test="not(Azimuth)">
									<xsl:call-template name="na"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:block>
										<xsl:value-of select="Azimuth"/>
									</fo:block>

								</xsl:otherwise>
							</xsl:choose>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<xsl:choose>
								<xsl:when test="not(Orientation)">
									<xsl:call-template name="na"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:block>
										<xsl:value-of select="Orientation"/>
									</fo:block>

								</xsl:otherwise>
							</xsl:choose>
							<!--							<fo:block>
								<xsl:if test="string(Orientation)">
									<xsl:value-of select="Orientation"/>
								</xsl:if>
							</fo:block>-->
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Area/text())">
									<xsl:value-of select="Area/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<xsl:choose>
								<xsl:when test="not(ChildAreaSum)">
									<xsl:call-template name="na"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:block>
										<xsl:value-of select="ChildAreaSum"/>
									</fo:block>

								</xsl:otherwise>
							</xsl:choose>
							<!--							<fo:block>
								<xsl:if test="string(ChildAreaSum)">
									<xsl:value-of select="ChildAreaSum"/>
								</xsl:if>
							</fo:block>-->
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<xsl:choose>
								<xsl:when test="not(Tilt)">
									<xsl:call-template name="na"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:block>
										<xsl:value-of select="Tilt/text()"/>
									</fo:block>

								</xsl:otherwise>
							</xsl:choose>
							<!--<fo:block>
								<xsl:if test="string(Tilt/text())">
									<xsl:value-of select="Tilt/text()"/>
								</xsl:if>
							</fo:block>-->
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template name="naSurface">
		<xsl:param name="val" select="'999'"/>
		<xsl:choose>
			<xsl:when test="$val = '999'">
				<fo:block>n/a</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:value-of select="$val"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Opaque-Cathedral Ceilings.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Opaque-Cathedral_Ceilings_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(14.056)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11.97)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.524)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.569)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.644)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8.284)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.089)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.576)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(6.728)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(7.313)" column-number="10"/>
			<fo:table-column column-width="proportional-column-width(6.772)" column-number="11"/>
			<fo:table-column column-width="proportional-column-width(5.475)" column-number="12"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="12" xsl:use-attribute-sets="cell">
						<fo:block>OPAQUE SURFACES – Cathedral Ceilings</fo:block>
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
						<fo:block> </fo:block>
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
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Orientation</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Skylight Area (ft2)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof Rise <fo:block/>(x in 12)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof <fo:block/>Pitch</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof Tilt<fo:block/>(deg)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof<fo:block/> Reflectance</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Roof<fo:block/> Emittance</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Framing Factor </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/CathedralCeiling | //Model[@Name='Proposed']/Proj/Garage/CathedralCeiling">
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
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Construction/text())">
									<xsl:value-of select="Construction/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(Orientation/text())">
									<xsl:value-of select="Orientation/text()"/>
								</xsl:if>
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
								<xsl:if test="string(RoofRise/text())">
									<xsl:value-of select="RoofRise/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="round(RoofPitch*100) div 100"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="round(RoofTilt*100) div 100"/>
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
								<xsl:if test="string(FramingFactor/text())">
									<xsl:value-of select="FramingFactor/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Attic.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Attic_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(15.206)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(15.247)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(15.247)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(11.209)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(12.124)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.322)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(10.322)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10.322)" column-number="8"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="8" xsl:use-attribute-sets="cell">
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
				</fo:table-row>
				<xsl:for-each select="//Model[@Name='Proposed']/Proj/Attic">
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
								<xsl:if test="string(RoofRise/text())">
									<xsl:value-of select="RoofRise/text()"/>
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
								<xsl:variable name="getCons" select="Construction"/>
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
									<xsl:when test="SolReflSpclFtrs&gt;=2">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Windows.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Windows_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(17.86)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(9.433)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(22.823)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(7.103)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5.662)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(6.347)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(5.15)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(5.573)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(5.354)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(14.694)" column-number="10"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="10" xsl:use-attribute-sets="cell">
						<fo:block>FENESTRATION / GLAZING</fo:block>
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
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Surface (Orientation-Azimuth)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:block>Width (ft)</fo:block>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>
							<fo:inline>Height (ft)</fo:inline>
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
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win | //Model[@Name='Proposed']/Proj/Zone/CathedralCeiling/Skylt | //Model[@Name='Proposed']/Proj/Garage/ExtWall/Win | //Model[@Name='Proposed']/Proj/Garage/CathedralCeiling/Skylt">
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
								<xsl:variable name="type" select="name()"/>
								<xsl:if test="$type = 'Win'">Window</xsl:if>
								<xsl:if test="$type = 'Skylt'">Skylight</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if
									test="string(concat(../Name,' (',../Orientation,'-',../Azimuth,')'))">
									<xsl:value-of
										select="concat(../Name,' (',../Orientation,'-',../Azimuth,')')"
									/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SpecMethod = 'Overall Window Area'"
										>----</xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(Width)) != 'NaN'">
											<xsl:value-of select="format-number(Width,'#.0')"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SpecMethod = 'Overall Window Area'"
										>----</xsl:when>
									<xsl:otherwise>
										<xsl:if test="string(number(Height)) != 'NaN'">
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
								<xsl:if test="string(ExteriorShade)">
									<xsl:value-of select="ExteriorShade"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Doors.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Doors_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(15.195)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(19.126)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(7.312)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(6.578)" column-number="4"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="cell">
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
				</fo:table-row>
				<fo:table-row font-weight="bold">
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
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Door | //Model[@Name='Proposed']/Proj/Zone/IntWall[./IsDemising=1]/Door | //Model[@Name='Proposed']/Proj/Garage/ExtWall/Door">
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
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of select="format-number(Area, '0.0')"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:value-of
									select="format-number(Ufactor/text(), &quot;0.00&quot;)"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Overhangs-Fins.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Overhangs-Fins_xfc">
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
					select="//Model[@Name='Proposed']/Proj/Zone/ExtWall/Win[ShowFinsOverhang=1]">
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Opaque Surface Constructions.xfc-->
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
					//Model[@Name='Proposed']/Cons[CanAssignTo='Underground Walls' and AssignedSurfaceArea &gt;0] | //Model[@Name='Proposed']/Cons[CanAssignTo = 'Interior Ceilings' and AssignedSurfaceArea &gt; 0]">
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Slab Floor.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_NC_NC_Slab_Floor_xfc">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(19.05)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(20.098)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(14.189)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(11.21)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(17.243)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(10.27)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7.94)" column-number="7"/>
			<fo:table-body>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="7" xsl:use-attribute-sets="cell">
						<fo:block>SLAB FLOORS</fo:block>
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
						<fo:block>04 </fo:block>
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
						<fo:block> Name</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Zone</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Area (ft<fo:inline baseline-shift="super" font-size="smaller"
								>2</fo:inline>)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Perimeter (ft)</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Edge Insul. R-value &amp; Depth</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Carpeted Fraction</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Heated</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/Zone/SlabFloor | //Model[@Name='Proposed']/Proj/Garage/SlabFloor | //Model[@Name='Proposed']/Proj/Zone/UndFloor">
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
								<xsl:if test="string(../Name/text())">
									<xsl:value-of select="../Name/text()"/>
								</xsl:if>
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
								<xsl:choose>
									<xsl:when test="Perimeter">
										<xsl:value-of select="Perimeter"/>
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
									<xsl:when test="EdgeInsulation=1">
										<xsl:value-of
											select="concat('R-',EdgeInsulRValue,', ',EdgeInsulDepth,' inches')"
										/>
									</xsl:when>
									<xsl:otherwise>None</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(CarpetedFrac/text())">
									<xsl:value-of select="CarpetedFrac/text()"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="slabheat" select="(HeatedSlab/text())"/>
								<xsl:choose>
									<xsl:when test="$slabheat = '1'">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Building Envelope HERS.xfc-->
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



	<!--MF DHW-->
	<xsl:template name="MF_DHW_System">
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
					<xsl:variable name="znName" select="../Proj/Zone/Name"/>
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
										<xsl:value-of select="NumDUsServed"/>
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
								<xsl:for-each select="DHWHeater[not(contains(text(),'none'))]">
									<xsl:variable name="heaterIndex" select="./@index"/>
									<xsl:variable name="heaterMult">
										<xsl:value-of select="../HeaterMult[@index = $heaterIndex]"
										/>
									</xsl:variable>
									<xsl:call-template name="contentWithCount">
										<xsl:with-param name="content" select="current()"/>
										<xsl:with-param name="count" select="$heaterMult"/>
									</xsl:call-template>
								</xsl:for-each>
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
								<xsl:choose>
									<xsl:when test="string(SolFracAnnRpt)">
										<xsl:value-of select="SolFracAnnRpt"/>
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

	<!--MF_DHW_System-->
	<xsl:template name="SF_DHW_System">
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
				<xsl:for-each select="//Model[@Name='Proposed']/DHWSys[NumDUsServed > 0]">
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
								<xsl:if test="string(DHWSysRpt/DHWSysType)">
									<xsl:value-of select="DHWSysRpt/DHWSysType"/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:if test="string(DHWSysRpt/DwellUnitDistType)">
									<xsl:value-of select="DHWSysRpt/DwellUnitDistType[position()=1]"
									/>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:for-each select="DHWHeater[not(contains(text(),'none'))]">
									<xsl:variable name="heaterIndex" select="./@index"/>
									<xsl:variable name="heaterMult">
										<xsl:value-of select="../HeaterMult[@index = $heaterIndex]"
										/>
									</xsl:variable>
									<xsl:call-template name="contentWithCount">
										<xsl:with-param name="content" select="current()"/>
										<xsl:with-param name="count" select="$heaterMult"/>
									</xsl:call-template>
									<!--<xsl:value-of select="$heaterIndex"/>-->
								</xsl:for-each>

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
	</xsl:template>


	<!-- Template for writing messages with a count in parenthese i.e. item (2) -->
	<xsl:template name="contentWithCount">
		<xsl:param name="content"/>
		<xsl:param name="count"/>
		<fo:block>
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
							<xsl:value-of select="concat('  ' ,$content,' (',$count,')')"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>

	<!--WaterHeater Detail-->
	<xsl:template match="DHWSys" mode="Waterheaters_SF_UEF">
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

	<!--WaterHeater Detail- DEPRECATED 07222017-->
	<xsl:template match="DHWSys" mode="Waterheaters_SF">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(12)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(9)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(12)" column-number="10"/>
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
						<fo:block>Input Rating / Pilot / Thermal Efficiency</fo:block>
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
								<xsl:value-of select="EfficiencyRpt"/>
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

	<!--WaterHeater Detail MF-->

	<xsl:key name="groupWHMF" match="//SDDXML/Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt"
		use="DHWHeaterRef/text()"/>

	<xsl:template match="DwellUnit" mode="Waterheaters_MF">
		<!--<xsl:template name="WaterHeaters_MF">-->
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
					<xsl:if test="not(preceding-sibling::DHWSysRpt/DHWHeaterRef=$heaterName)">

						<xsl:variable name="tankType" select="TankType"/>
						<xsl:variable name="isHydronic" select="../IsHydronic"/>
						<xsl:variable name="isHP">
							<xsl:choose>
								<xsl:when test="contains(HeaterElementType,'Heat Pump')"
									>1</xsl:when>
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
									<xsl:value-of select="$heaterName"/>
									<!--<xsl:if test="string(Name)">
									<xsl:value-of select="Name"/>
								</xsl:if>-->
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
									<!--<xsl:value-of
									select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[DHWHeaterRef=$heaterName and preceding::DHWSysRpt/DHWHeaterRef!=$heaterName]/DHWHeaterCnt"
								/>-->
									<xsl:value-of
										select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[DHWHeaterRef=$heaterName and not(preceding::DHWSysRpt[DHWHeaterRef=$heaterName])]/DHWHeaterCnt * //Model[@Name='Proposed']/DHWSys[DHWHeater=$heaterName]/NumDUsServed"
									/>
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
									<!--<xsl:choose>
									<xsl:when test="HPWH_NEEARated = 0">
										<xsl:value-of
											select="concat(EnergyFactor,' ',EfficiencyUnits)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>-->
								</fo:block>
							</fo:table-cell>
							<fo:table-cell xsl:use-attribute-sets="numberCell">
								<fo:block>
									<xsl:choose>
										<xsl:when test=" InputRating | InputRating > 0 ">
											<xsl:value-of
												select="concat(InputRating,' ',InputRatingUnits)"/>
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
											<xsl:value-of
												select="concat('R-',IntInsulRVal,' / R-',ExtInsulRVal)"
											/>
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
										<xsl:when test="HasElecMiniTank=1 and $isHP=0">
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
												<xsl:with-param name="isOutside"
												select="TankOutside"/>
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
					</xsl:if>
					<!--					<xsl:for-each select="DHWSysRpt[generate-id(.)=generate-id(key('groupWHMF',DHWHeaterRef)[1])]">-->


				</xsl:for-each>
			</fo:table-body>
		</fo:table>
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

	<!--WaterHeater Detail MF2- DEPRECATED 07222017-->
	<xsl:template name="WaterHeaters_MF2">
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
					<xsl:variable name="heaterName" select="Name"/>
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
								<!--<xsl:value-of
									select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[DHWHeaterRef=$heaterName and preceding::DHWSysRpt/DHWHeaterRef!=$heaterName]/DHWHeaterCnt"
								/>-->
								<xsl:value-of
									select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[DHWHeaterRef=$heaterName and not(preceding::DHWSysRpt[DHWHeaterRef=$heaterName])]/DHWHeaterCnt * //Model[@Name='Proposed']/DHWSys[DHWHeater=$heaterName]/NumDUsServed"
								/>
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
										<xsl:value-of
											select="concat(EnergyFactor,' ',EfficiencyUnits)"/>
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
										<xsl:value-of
											select="concat(InputRating,' ',InputRatingUnits)"/>
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
										<xsl:value-of
											select="concat('R-',IntInsulRVal,' / R-',ExtInsulRVal)"
										/>
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
									<xsl:when test="HasElecMiniTank=1 and $isHP=0">
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
									<xsl:when test="HPWH_NEEARated = 1">
										<xsl:value-of select="concat(HPWHBrand,' / ',HPWHModel)"/>
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

	<!--WaterHeater Detail MF3- DEPRECATED 07222017-->
	<xsl:template name="WaterHeaters_MF3">
		<fo:table xsl:use-attribute-sets="table">
			<fo:table-column column-width="proportional-column-width(13)" column-number="1"/>
			<fo:table-column column-width="proportional-column-width(11)" column-number="2"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="3"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="4"/>
			<fo:table-column column-width="proportional-column-width(5)" column-number="5"/>
			<fo:table-column column-width="proportional-column-width(8)" column-number="6"/>
			<fo:table-column column-width="proportional-column-width(7)" column-number="7"/>
			<fo:table-column column-width="proportional-column-width(10)" column-number="8"/>
			<fo:table-column column-width="proportional-column-width(6)" column-number="9"/>
			<fo:table-column column-width="proportional-column-width(15)" column-number="10"/>
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
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[not(DHWHeaterRef = preceding::DHWSysRpt/DHWHeaterRef)]">
					<xsl:variable name="tankLoc" select="TankLocation"/>
					<xsl:variable name="dhwSysName" select="DHWSysRef"/>
					<xsl:variable name="dhwSys" select="//Model[@Name='Proposed']/DHWSys[Name=$dhwSysName]"/>
					<!--<xsl:variable name="dhwSys">
						<xsl:copy-of select="//Model[@Name='Proposed']/DHWSys[Name=$dhwSysName]"/>
					</xsl:variable>-->
					<xsl:variable name="dhwHeaterIndex" select="DHWHeaterIdx - 1"/>
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
								<xsl:value-of select="msxsl:node-set($dhwSys)/HeaterMult[@index=$dhwHeaterIndex] * msxsl:node-set($dhwSys)/NumDUsServed"/>
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
								<xsl:call-template name="isNA">
									<xsl:with-param name="input" select="StandbyLossRpt"/>
								</xsl:call-template>
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
								<xsl:choose>
									<xsl:when test="normalize-space(string(TankLocation))">
										<xsl:value-of select="TankLocation"/>
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

<!--	<!-\-NC_WaterHeaters-SF-2016-V2-\->
	<xsl:template name="NC_WaterHeaters-SF-2016-V2">
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
					select="//Model[@Name='Proposed']/DHWSys/DHWSysRpt[not(DHWHeaterRef = preceding::DHWSysRpt/DHWHeaterRef)] | //Model[@Name='Proposed']/Proj/Zone/DwellUnit/DHWSysRpt[not(DHWHeaterRef = preceding::DHWSysRpt/DHWHeaterRef)]">
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
	</xsl:template>-->


	<!--HERS _DHW-->
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSParallelPipe=1">
										<xsl:value-of select="HERSParaPipeRptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose xmlns:ns1="http://www.w3.org/2000/09/xmldsig#">
									<xsl:when test="HERSCompact=1">
										<xsl:value-of select="HERSCompactRptMsg"/>
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
									<xsl:when test="HERSPointOfUse=1">
										<xsl:value-of select="HERSPOURptMsg"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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

	<!--Space Conditioning Systems - SF -->
	<xsl:template name="SC_Systems_SF">
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
					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<!--MultiFamily_SC_Systems2-->
	<xsl:template name="SC_Systems_MF2">
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
											<xsl:value-of select="$coolUnit"/>
										</xsl:when>
										<xsl:when test="HtPumpSystem">
											<xsl:value-of select="$coolUnit"/>
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
											<xsl:value-of select="$coolUnit"/>
										</xsl:when>
										<xsl:when test="HtPumpSystem">
											<xsl:value-of select="$coolUnit"/>
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

	<!-- Template with HVACSys node set -->
	<xsl:template match="HVACSys"> </xsl:template>

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
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal !=2 and not(contains(DuctLocationRpt,'no ducts'))]">
					<!--<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>-->
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="concat('Name',Name)"/>
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
				<xsl:for-each
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[SCSysTypeVal !=2 and HeatSystem]">
					<!--<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>-->
					<!--	<xsl:if test="not(CoolSystem) and HeatSystem">-->
					<!-- Setup retrieval -->
					<xsl:variable name="scSysRptName" select="Name"/>
					<xsl:variable name="heatSysName" select="HeatSystem"/>
					<xsl:variable name="heatSysIndex">
						<xsl:value-of
							select="//Model[@Name='Proposed']/HVACSys[SCSysRptRef=$scSysRptName]/HeatSystem[text()=$heatSysName]/@index"
						/>
					</xsl:variable>
					<xsl:variable name="heatSysCount">
						<xsl:value-of select="ReferenceCount"/>
					</xsl:variable>
					<!--					<xsl:variable name="heatSysCount">
						<xsl:value-of select="sum(//Model[@Name='Proposed']/HVACSys/HeatSystemCount[@index=$heatSysIndex and ../HeatSystem=$heatSysName])"/>
					</xsl:variable>-->
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
								<xsl:value-of select="concat(MinHeatEffic,' ',HeatEfficType)"/>
								<!--</xsl:when>
									<xsl:otherwise>-\-\-</xsl:otherwise>
								</xsl:choose>-->
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<!--</xsl:if>-->
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>

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
					<!--<xsl:sort select="Name" data-type="text" order="ascending"
						case-order="lower-first"/>-->
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
				<fo:table-row font-weight="bold">
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block> </fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block>System</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block>Number of</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" number-columns-spanned="3">
						<fo:block>Heating</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" number-columns-spanned="2">
						<fo:block>Cooling</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block>Zonally</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block>Compressor</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC" border-bottom-color="#FFFFFF">
						<fo:block>HERS</fo:block>
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
						<fo:block>Units</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block> HSPF/COP </fo:block>
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
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Controlled</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
						<fo:block>Type</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellAC">
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
								<xsl:choose>
									<xsl:when test="CoolingType='GroundSourceHeatPump'"
										>--</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="MinCoolSEER"/>
									</xsl:otherwise>
								</xsl:choose>
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
								<xsl:choose>
									<xsl:when test="TypeAbbrevStr='GroundSourceHeatPump'">
										<xsl:value-of select="COP47"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="HSPF"/>
									</xsl:otherwise>
								</xsl:choose>
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
								<xsl:choose>
									<xsl:when test="CoolingType='GroundSourceHeatPump'"
										>--</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="MinCoolSEER"/>
									</xsl:otherwise>
								</xsl:choose>
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
								<xsl:choose>
									<xsl:when test="CoolingType='GroundSourceHeatPump'"
										>--</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="SEER"/>
									</xsl:otherwise>
								</xsl:choose>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolSEER">
										<xsl:value-of select="MinCoolSEER"/>
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
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ZonalCoolingType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
									<xsl:when test="$coolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="MinCoolSEER">
										<xsl:value-of select="MinCoolSEER"/>
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
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="ZonalCoolingType"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
									<xsl:when test="$coolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="SEERRpt">
										<xsl:value-of select="SEERRpt"/>
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
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
									<xsl:when test="IsZonal=1">Yes</xsl:when>
									<xsl:otherwise>No</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:choose>
									<xsl:when test="CoolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
									<xsl:when test="$coolingType='NoCooling'">
										<xsl:call-template name="na"/>
									</xsl:when>
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
					select="//Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACCool[Name=preceding-sibling::Proj/SCSysRpt/CoolSystem]/HERSCheck] | //Model[@Name='Proposed']/HERSCool[Name=preceding-sibling::HVACHtPump[Name=preceding-sibling::Proj/SCSysRpt/HtPumpSystem]/HERSCheck]">
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not Required</xsl:when>-->
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
									<!--<xsl:when
										test="contains($coolType,'NoCooling') or contains($coolType,'DuctlessHeatPump')"
										>-\-\-\-</xsl:when>-->
									<xsl:when test="AHUAirFlow='0'">
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
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
								<xsl:choose>
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
						<fo:block>Airflow Target (CFM)</fo:block>
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
									<!--<xsl:when
										test="contains($coolType,'NoCooling') or contains($coolType,'DuctlessHeatPump')"
										>-\-\-\-</xsl:when>-->
									<xsl:when
										test="contains($coolType,'DuctlessHeatPump')"
										><xsl:call-template name="na"/></xsl:when>
									<xsl:when test="AHUAirFlow='1'">
										<xsl:value-of select="AirFlowRptMsg"/>	
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell xsl:use-attribute-sets="numberCell">
							<fo:block>
								<xsl:variable name="coolType"
									select="//Model[@Name='Proposed']/HVACCool[Name=preceding-sibling::HVACSys[FloorAreaServed&gt;0]/CoolSystem]/TypeRpt"/>
								<xsl:choose>
								<!--	<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
									<!--<xsl:when test="contains($coolType,'NoCooling')">Not
										Required</xsl:when>-->
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
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding-sibling::SCSysRpt/HVACDistRef=HVACDistRef) and not(DuctLocationRpt='no ducts')]">
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
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[not(preceding-sibling::SCSysRpt/HVACDistRef=HVACDistRef) and not(DuctLocationRpt='no ducts')]">
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
									<xsl:otherwise>
										<xsl:call-template name="na"/>
									</xsl:otherwise>
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
	<xsl:template name="HERS_Dist_SF">
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
				<fo:table-row font-weight="bold">
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
					select="//Model[@Name='Proposed']/Proj/SCSysRpt[HVACFanRef and not(preceding::SCSysRpt/HVACFanRef=HVACFanRef)]">
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
											test="not(//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck)">
											<xsl:call-template name="na"/>
										</xsl:if>
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
				<fo:table-row font-weight="bold">
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
					select="//Model[@Name='Proposed']/Proj/Zone/DwellUnit/SCSysRpt[HVACFanRef and not(preceding::SCSysRpt/HVACFanRef=HVACFanRef)]">
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
											test="not(//Model[@Name='Proposed']/HVACFan[Name=$fanSys]/HERSCheck)">
											<xsl:call-template name="na"/>
										</xsl:if>
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\NC\NC_Fan CoolVent.xfc  DEPRECATED-->
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
	<!-- Revised again to remove column 7 Attic Relief Vent -->
	<xsl:template name="CoolingVentilation">
		<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xslt="http://www.w3.org/1999/XSL/Transform">
			<fo:table border-collapse="collapse" font-family="Arial Narrow" font-size="8pt"
				keep-together.within-column="always" margin-top="0in" table-layout="fixed"
				width="100%">
				<fo:table-column column-width="proportional-column-width(22.024)" column-number="1"/>
				<fo:table-column column-width="proportional-column-width(12.653)" column-number="2"/>
				<fo:table-column column-width="proportional-column-width(11.603)" column-number="3"/>
				<fo:table-column column-width="proportional-column-width(14.369)" column-number="4"/>
				<fo:table-column column-width="proportional-column-width(11.213)" column-number="5"/>
				<fo:table-column column-width="proportional-column-width(11.815)" column-number="6"/>
				<fo:table-body>
					<fo:table-row height="0.224in" overflow="hidden">
						<fo:table-cell number-columns-spanned="6" border="1pt solid black"
							display-align="center" font-weight="bold" line-height="115%"
							padding="2pt" text-align="left">
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
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
							<fo:block>Name</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
							<fo:block>Airflow Rate (CFM/ft2)</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
							<fo:block>Cooling Vent CFM</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
							<fo:block>Cooling Vent Watts/CFM</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
							<fo:block>Total Watts</fo:block>
						</fo:table-cell>
						<fo:table-cell border="1pt solid black" display-align="after" padding="2pt"
							text-align="center">
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
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
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
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
								<fo:block>
									<xsl:variable name="hasCoolVent"
										select="//Model[@Name='Proposed']/Proj/EnableClVent"/>
									<xsl:variable name="coolVentCFM"
										select="//Model[@Name='Proposed']/Proj/UnitClVentCFMTot"/>
									<xsl:variable name="CFA"
										select="//Model[@Name='Proposed']/Proj/CondFloorArea"/>
									<xsl:choose>
										<xsl:when test="$hasCoolVent=1">
											<xsl:value-of select="$coolVentCFM div $CFA"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="na"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(CoolingVent)">
										<xsl:value-of select="CoolingVent"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(WperCFMCool)">
										<xsl:value-of select="WperCFMCool"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
								<fo:block>
									<xsl:if
										test="string(format-number(CoolingVent*WperCFMCool,'0'))">
										<xsl:value-of
											select="format-number(CoolingVent*WperCFMCool,'0')"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell border="1pt solid black" display-align="center"
								padding="2pt" text-align="center">
								<fo:block>
									<xsl:if test="string(NumAssignments)">
										<xsl:value-of select="NumAssignments"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<!--<fo:table-cell border="1pt solid black" display-align="center" padding="2pt" text-align="center">
								<fo:block>
									<xsl:variable name="reducedVentArea" select="//Model[@Name='Proposed']/Proj/UnitClVentLowArea"/>
									<xsl:variable name="atticRelief" select="//Model[@Name='Proposed']/Proj/ClVentAtticRelief"/>
									<xsl:variable name="atticReliefText" select="//Model[@Name='Proposed']/Proj/ClVentAtticRelMsg"/>
									<xsl:choose>
										<xsl:when test="$reducedVentArea=1">
											Yes
										</xsl:when>
										<xsl:otherwise>
											No
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>-->
						</fo:table-row>
					</xsl:for-each>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_Notes.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_Notes_xfc">
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

	<!--Generated from component Y:\CBECC-Res Documents\2016\Common\COM_CF1R Declarations.xfc-->
	<xsl:template name="_component_Y__CBECC-Res_Documents_2016_Common_COM_CF1R_Declarations_xfc">
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
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						height="25.5pt" padding="2pt">
						<fo:block>Company:</fo:block>
					</fo:table-cell>
					<fo:table-cell number-columns-spanned="2" border="1pt solid black"
						height="25.5pt" padding="2pt">
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

	<!-- Calculate Margin or None     -->
	<xsl:template name="getMargin">
		<xsl:param name="stdVal"/>
		<xsl:param name="prpVal"/>

		<xsl:choose>
			<!--  Added check for numbers -->
			<xsl:when test="number(translate($prpVal,',','')) and number(translate($stdVal,',',''))">
				<xsl:value-of
					select="format-number( 1 - (( translate($prpVal,',','') div translate($stdVal,',','')) ), '0.0%')"/>
				<!-- <xsl:value-of select="format-number($stdVal - $prpVal,'#.##')"/>-->
			</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Calculate Margin or None  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    -->

	<!-- Calculate Margin or None     -->
	<xsl:template name="getMarginDiff">
		<xsl:param name="stdVal"/>
		<xsl:param name="prpVal"/>

		<xsl:choose>
			<!--  Added check for numbers -->
			<xsl:when test="number(translate($prpVal,',','')) and number(translate($stdVal,',',''))">
				<xsl:value-of
					select="format-number(( translate($stdVal,',','') - translate($prpVal,',','') ), '0.0')"/>
				<!-- <xsl:value-of select="format-number($stdVal - $prpVal,'#.##')"/>-->
			</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Calculate Margin or None  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    -->

</xsl:stylesheet>
