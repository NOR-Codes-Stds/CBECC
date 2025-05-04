<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ns2="http://www.lmonte.com/besm/comp"
    xmlns:ns1="http://www.lmonte.com/besm/CF1RNCB01E"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:com="http://www.lmonte.com/besm/com"
    xmlns:dtyp="http://www.lmonte.com/besm/dtyp"
    version="1.0">

    <xsl:include href="CF1R_common.xsl"/>
    
    <xsl:template match="/">
        <fo:root xsl:use-attribute-sets="default">

            <xsl:call-template name="foLayoutMasterSet"/>
            
            <xsl:call-template name="bookmarkTreeSchema"/>

            <fo:page-sequence master-reference="repeatLetterLandCF1R" format="1" initial-page-number="1">

                <xsl:call-template name="foStaticContent"/>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:call-template name="firstPageHeader"/>
                    </fo:block>
                    <fo:block>
                        <xsl:apply-templates select="/ns1:ComplianceDocumentPackage/ns1:DocumentData/ns1:cF1RNCB01E"/>
                    </fo:block>
                    <fo:block>
                        <xsl:call-template name="tableSigBlockLandscape"/>
                    </fo:block>
                    <fo:block id="last">&#160;</fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="ns1:cF1RNCB01E">
        <xsl:call-template name="addMissingSections"/>
    </xsl:template>
    
   <xsl:template match="ns1:Section_A">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table8">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(5)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(9)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(7)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(9)" column-number="6"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="6">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>  
                <fo:table-row xsl:use-attribute-sets="row">
                  <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>01</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A01_ProjectName']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A01_ProjectName"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>02</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A02_ComplianceApplicationDate']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A02_ComplianceApplicationDate"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>03</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A03_StreetAddress']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A03_StreetAddress"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>04</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A04_Azimuth']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                           <xsl:value-of select="ns1:A04_Azimuth"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>05</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A05_City']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A05_City"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>06</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A06_DwellingUnitCount']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A06_DwellingUnitCount"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>07</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A07_Zipcode']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A07_Zipcode"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>08</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A08_SiteFuelType']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="$resCommon/xsd:simpleType[@name='SiteFuelType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:A08_SiteFuelType]"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>09</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A09_ClimateZone']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="$resCommon/xsd:simpleType[@name='ClimateZone']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:A09_ClimateZone]"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>10</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='A10_ResidentialBuildingTotalConditionedFloorArea']/xsd:annotation/xsd:documentation[@source='FieldText']"/>                            
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A10_ResidentialBuildingTotalConditionedFloorArea"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>11</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:element[@name='A11_ResidentialLowriseBuildingType']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="$resCommon/xsd:simpleType[@name='ResidentialLowriseBuildingType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:A11_ResidentialLowriseBuildingType]"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>12</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='A12_FloorSlabArea']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:value-of select="ns1:A12_FloorSlabArea"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>13</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2">
                        <fo:block>
                            <xsl:value-of select="$path/xsd:sequence[xsd:element[@name='A13_ProjectScopeNew']]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <xsl:for-each select="ns1:A13_ProjectScopeNew">
                            <fo:block>
                                <xsl:call-template name="formatSuperScript">
                                    <xsl:with-param name="text" select="$resCompliance/xsd:simpleType[@name='ProjectScopeNew']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()]"/>
                                </xsl:call-template>
                             </fo:block>
                        </xsl:for-each>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>14</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='A14_FenestrationUfactorSHGC150_1c3A_Exception']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <xsl:for-each select="ns1:A14_FenestrationUfactorSHGC150_1c3A_Exception">                                    
                            <fo:block>
                                <xsl:call-template name="formatSuperScript">
                                    <xsl:with-param name="text" select="$resCompliance/xsd:simpleType[@name='FenestrationUfactorSHGC150_1c3A_Exception']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value = current()]"/>
                                </xsl:call-template>
                            </fo:block>
                        </xsl:for-each>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_B">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="1.9cm" column-number="1"/>
            <fo:table-column column-width="1.9cm" column-number="2"/>
            <fo:table-column column-width="1.9cm" column-number="3"/>
            <fo:table-column column-width="1.9cm" column-number="4"/>
            <fo:table-column column-width="1.9cm" column-number="5"/>
            <fo:table-column column-width="1.9cm" column-number="6"/>
            <fo:table-column column-width="1.9cm" column-number="7"/>
            <fo:table-column column-width="1.9cm" column-number="8"/>
            <fo:table-column column-width="1.9cm" column-number="9"/>
            <fo:table-column column-width="1.85cm" column-number="10"/>
            <fo:table-column column-width="1.9cm" column-number="11"/>
            <fo:table-column column-width="4.5cm" column-number="12"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="12">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 12]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <xsl:attribute name="number-columns-spanned">
                                <xsl:choose>
                                    <xsl:when test="position() = 6">2</xsl:when>
                                    <xsl:otherwise>1</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 6]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="6">
                        <fo:block>
                            <fo:table xsl:use-attribute-sets="table5NoBorder">
                                <fo:table-column column-width="1.9cm" column-number="1"/>
                                <fo:table-column column-width="1.885cm" column-number="2"/>
                                <fo:table-column column-width="1.9cm" column-number="3"/>
                                <fo:table-column column-width="1.875cm" column-number="4"/>
                                <fo:table-column column-width="1.875cm" column-number="5"/>
                                <fo:table-column column-width="1.9cm" column-number="6"/>
                                <fo:table-body>               
                                    <fo:table-row xsl:use-attribute-sets="row" height="1cm">
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="5">
                                            <fo:block font-weight="bold">Proposed</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder">
                                            <fo:block font-weight="bold">Required</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                            <fo:block>
                                                <fo:table xsl:use-attribute-sets="table5NoBorder">
                                                    <fo:table-column column-width="1.885cm" column-number="1"/>
                                                    <fo:table-column column-width="1.86cm" column-number="2"/>
                                                    <fo:table-body>               
                                                        <fo:table-row height="2cm">
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                                <fo:block>     
                                                                    <xsl:value-of select="$path/xsd:element[@name='B06a_InsulationCavityRValue']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                <fo:block>
                                                                    <xsl:value-of select="$path/xsd:element[@name='B06b_InsulationContinuousRValue']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                            <fo:block>
                                                <xsl:value-of select="$path/xsd:element[@name='B07_UFactor']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                            <fo:block>
                                                <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                    <fo:table-column column-width="1.875cm" column-number="1"/>
                                                    <fo:table-column column-width="1.875cm" column-number="2"/>
                                                    <fo:table-body>               
                                                        <fo:table-row xsl:use-attribute-sets="row" height="1cm">
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                <fo:block>Appendix JA4 Reference</fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                        <fo:table-row height="1cm">
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                                <fo:block>Table</fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                <fo:block>Cell</fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder">
                                            <fo:block>
                                                <fo:table>
                                                    <fo:table-column column-width="1.9cm" column-number="1"/>
                                                    <fo:table-body>  
                                                        <fo:table-row>
                                                            <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                <fo:block>U-Factor from Package A</fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </fo:table-body>
                                                </fo:table>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block> <xsl:value-of select="$path/xsd:element[@name='B11_ComplianceDocumentTableComments']/xsd:annotation/xsd:documentation[@source='FieldText']"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body> 
                <xsl:for-each select="ns1:Table/ns1:Row">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                           <fo:block>
                               <xsl:value-of select="ns1:B01_PartitionName"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='PartitionType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:B02_PartitionType]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='PartitionFramingMaterial']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:B03_PartitionFramingMaterial]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='FramingSize']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:B04_FramingSize]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='FramingSpacing']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:B05_FramingSpacing]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B06a_InsulationCavityRValue"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B06b_InsulationContinuousRValue"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B07_UFactor"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B08_JAReferenceTableID"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B09_JAReferenceTableCell"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B10_UFactorLimit"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:B11_ComplianceDocumentTableComments"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_C">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table2']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="2.31cm" column-number="1"/>
            <fo:table-column column-width="2.31cm" column-number="2"/>
            <fo:table-column column-width="2.31cm" column-number="3"/>
            <fo:table-column column-width="2.31cm" column-number="4"/>
            <fo:table-column column-width="2.31cm" column-number="5"/>
            <fo:table-column column-width="2.31cm" column-number="6"/>
            <fo:table-column column-width="2.31cm" column-number="7"/>
            <fo:table-column column-width="2.31cm" column-number="8"/>
            <fo:table-column column-width="2.31cm" column-number="9"/>
            <fo:table-column column-width="2.31cm" column-number="10"/>
            <fo:table-column column-width="2.31cm" column-number="11"/>
           <xsl:choose>
               <xsl:when test="child::*">
                   <fo:table-header>
                       <fo:table-row  xsl:use-attribute-sets="headerRow">
                           <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="11">                        
                               <xsl:call-template name="sectionHeading"/>
                           </fo:table-cell>
                       </fo:table-row>
                       <fo:table-row xsl:use-attribute-sets="row">
                           <xsl:for-each select="$path/child::*[position() &lt; 12]">
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:choose>
                                           <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                           <xsl:otherwise>
                                               <xsl:value-of select="position()"/>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                   </fo:block>
                               </fo:table-cell>
                           </xsl:for-each>
                       </fo:table-row>
                       <fo:table-row xsl:use-attribute-sets="row">
                           <xsl:for-each select="$path/child::*[position() &lt; 5]">
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                   </fo:block>
                               </fo:table-cell>
                           </xsl:for-each>
                           <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="6">
                               <fo:block>
                                   <fo:table xsl:use-attribute-sets="table5NoBorder">
                                       <fo:table-column column-width="2.29cm" column-number="1"/>
                                       <fo:table-column column-width="2.31cm" column-number="2"/>
                                       <fo:table-column column-width="2.32cm" column-number="3"/>
                                       <fo:table-column column-width="2.32cm" column-number="4"/>
                                       <fo:table-column column-width="2.29cm" column-number="5"/>
                                       <fo:table-column column-width="2.30cm" column-number="6"/>
                                       <fo:table-body>               
                                           <fo:table-row xsl:use-attribute-sets="row">
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="5">
                                                   <fo:block font-weight="bold">Proposed</fo:block>
                                               </fo:table-cell>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder">
                                                   <fo:block font-weight="bold">Required</fo:block>
                                               </fo:table-cell>
                                           </fo:table-row>
                                           <fo:table-row>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                   <fo:block>     
                                                       <xsl:value-of select="$path/xsd:element[@name='C05_InsulationCoreRValue']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                   </fo:block>
                                               </fo:table-cell>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                   <fo:block>
                                                       <xsl:value-of select="$path/xsd:element[@name='C06_InsulationContinuousRValue']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                   </fo:block>
                                               </fo:table-cell>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                   <fo:block>
                                                       <xsl:value-of select="$path/xsd:element[@name='C07_UFactor']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                   </fo:block>
                                               </fo:table-cell>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                   <fo:block>
                                                       <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                           <fo:table-column column-width="2.285cm" column-number="1"/>
                                                           <fo:table-column column-width="2.30cm" column-number="2"/>
                                                           <fo:table-body>               
                                                               <fo:table-row xsl:use-attribute-sets="row">
                                                                   <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                       <fo:block>Appendix JA4 Reference</fo:block>
                                                                   </fo:table-cell>
                                                               </fo:table-row>
                                                               <fo:table-row height="1cm">
                                                                   <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                                       <fo:block>Table</fo:block>
                                                                   </fo:table-cell>
                                                                   <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                       <fo:block>Cell</fo:block>
                                                                   </fo:table-cell>
                                                               </fo:table-row>
                                                           </fo:table-body>
                                                       </fo:table>
                                                   </fo:block>
                                               </fo:table-cell>
                                               <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder">
                                                   <fo:block>
                                                       <fo:table>
                                                           <fo:table-column column-width="2.30cm" column-number="1"/>
                                                           <fo:table-body> 
                                                               <fo:table-row>
                                                                   <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                       <fo:block>U-Factor from Package A</fo:block>
                                                                   </fo:table-cell>
                                                               </fo:table-row>
                                                           </fo:table-body>
                                                       </fo:table>
                                                   </fo:block>
                                               </fo:table-cell>
                                           </fo:table-row>
                                       </fo:table-body>
                                   </fo:table>
                               </fo:block>
                           </fo:table-cell>
                           <fo:table-cell xsl:use-attribute-sets="numberCell">
                               <fo:block> <xsl:value-of select="$path/xsd:element[@name='C11_ComplianceDocumentTableComments']/xsd:annotation/xsd:documentation[@source='FieldText']"/></fo:block>
                           </fo:table-cell>
                       </fo:table-row>
                   </fo:table-header>
                   <fo:table-body>
                       <xsl:for-each select="ns1:Table2/ns1:Row">
                           <fo:table-row xsl:use-attribute-sets="row">
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C01_PartitionName"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='PartitionType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:C02_PartitionType]"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='SplineTypeSIP']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:C03_SplineTypeSIP]"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C04_Thickness"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C05_InsulationCoreRValue"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C06_InsulationContinuousRValue"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C07_UFactor"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C08_JAReferenceTableID"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C09_JAReferenceTableCell"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C10_UFactorLimit"/>
                                   </fo:block>
                               </fo:table-cell>
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                   <fo:block>
                                       <xsl:value-of select="ns1:C11_ComplianceDocumentTableComments"/>
                                   </fo:block>
                               </fo:table-cell>
                           </fo:table-row>
                       </xsl:for-each>
                   </fo:table-body>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:call-template name="doesNotApplyWithHeader">
                       <xsl:with-param name="colspan" select="11"/>
                   </xsl:call-template>
               </xsl:otherwise>
           </xsl:choose>
        </fo:table> 
    </xsl:template>
    
    <xsl:template match="ns1:Section_D">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table3']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="8"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="11"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="12"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="13"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="14"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="15"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="16"/>
            <xsl:choose>
                <xsl:when test="child::*">
                    <fo:table-header>
                        <fo:table-row  xsl:use-attribute-sets="headerRow">
                            <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="16">                        
                                <xsl:call-template name="sectionHeading"/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <xsl:for-each select="$path/child::*[position() &lt; 13]">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <xsl:attribute name="number-columns-spanned">
                                        <xsl:choose>
                                            <xsl:when test="position() = 7 or position() = 8 or  position() = 11 or position()=12">2</xsl:when>
                                            <xsl:otherwise>1</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="position()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <xsl:for-each select="$path/child::*[position() &lt; 7]">
                                <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                                    <fo:block>
                                        <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                            <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="10">
                                <fo:block>
                                    <fo:table xsl:use-attribute-sets="table5NoBorder">
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="8"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
                                        <fo:table-body>               
                                            <fo:table-row xsl:use-attribute-sets="row">
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="6"  height="0.8cm">
                                                    <fo:block font-weight="bold">Proposed</fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="4"  height="0.8cm">
                                                    <fo:block font-weight="bold">Required</fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-body>               
                                                                <fo:table-row xsl:use-attribute-sets="row">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                        <fo:block>Inferior Insulation</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                                <fo:table-row height="1cm">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                                        <fo:block>R-value</fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder">
                                                                        <fo:block>U-factor</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-body>               
                                                                <fo:table-row xsl:use-attribute-sets="row">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                        <fo:block>Exterior Insulation</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                                <fo:table-row height="1cm">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                                        <fo:block>R-value</fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                        <fo:block>U-factor</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-body>               
                                                                <fo:table-row xsl:use-attribute-sets="row">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                        <fo:block>Appendix JA4 Reference</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                                <fo:table-row height="1cm">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                                        <fo:block>Table</fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                        <fo:block>Cell</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="4">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
                                                            <fo:table-body> 
                                                                <fo:table-row>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                                        <fo:block>
                                                                            <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                                                <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                                                <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                                                <fo:table-body>               
                                                                                    <fo:table-row xsl:use-attribute-sets="row">
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                                            <fo:block>Inferior Insulation</fo:block>
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                    <fo:table-row height="1cm">
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                                                            <fo:block>R-value</fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                                            <fo:block>U-factor</fo:block>
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                </fo:table-body>
                                                                            </fo:table>
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="2">
                                                                        <fo:block>
                                                                            <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                                                <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                                                <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                                                <fo:table-body>               
                                                                                    <fo:table-row xsl:use-attribute-sets="row">
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder" number-columns-spanned="2">
                                                                                            <fo:block>Exterior Insulation</fo:block>
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                    <fo:table-row height="1cm">
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad">
                                                                                            <fo:block>R-value</fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                                            <fo:block>U-factor</fo:block>
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                </fo:table-body>
                                                                            </fo:table>
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <xsl:for-each select="ns1:Table3/ns1:Row">
                            <fo:table-row xsl:use-attribute-sets="row">
                               <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D01_PartitionName"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="ns1:D02_PartitionAboveGrade = 'true' or ns1:D02_PartitionAboveGrade = 1 "> 
                                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='PartitionAboveGrade']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                            </xsl:when>
                                            <xsl:otherwise>   
                                                <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='PartitionAboveGrade']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='MasonryType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:D03_MasonryType]"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D04_MassWallThickness"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D05_FurringStripThickness"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D06_FurringStripThickness"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D07_InsulationInteriorRValue"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D07_InsulationInteriorUFactor"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D08_InsulationExteriorRValue"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D08_InsulationExteriorUFactor"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D09_JAReferenceTableID"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D10_JAReferenceTableCell"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D11_InsulationInteriorRValueMinimum"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D11_InsulationInteriorUFactorLimit"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D12_InsulationExteriorRValueMinimum"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:D12_InsulationExteriorUFactorLimit"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                    </fo:table-body>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="doesNotApplyWithHeader">
                        <xsl:with-param name="colspan" select="15"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>                
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_E">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="5cm" column-number="1"/>
            <fo:table-column column-width="3cm" column-number="2"/>
            <fo:table-column column-width="3cm" column-number="3"/>
            <fo:table-column column-width="3cm" column-number="4"/>
            <fo:table-column column-width="3cm" column-number="5"/>
            <fo:table-column column-width="8.45cm" column-number="6"/>
            <xsl:choose>
                <xsl:when test="child::*">
                    <fo:table-header>
                        <fo:table-row  xsl:use-attribute-sets="headerRow">
                            <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="6">                        
                                <xsl:call-template name="sectionHeading"/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>01</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell" number-columns-spanned="2">
                                <fo:block>02</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell" number-columns-spanned="2">
                                <fo:block>03</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>04</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:value-of select="$path/xsd:element[@name='E01_ExteriorFloorType']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                <fo:block>
                                    <fo:table xsl:use-attribute-sets="table5NoBorder">
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                        <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                        <fo:table-body>               
                                            <fo:table-row xsl:use-attribute-sets="row">
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="2">
                                                    <fo:block font-weight="bold">Proposed</fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="2">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-body>  
                                                                <fo:table-row height="1cm">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                                        <fo:block>
                                                                            <xsl:value-of select="$path/xsd:choice[xsd:element[@name='E02_InsulationRValue']]/xsd:annotation/xsd:documentation[@source='FieldText']"/>                                                                            
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                        <fo:block>
                                                                            <xsl:value-of select="$path/xsd:choice/xsd:element[@name='E02_InsulationUFactor']/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                                        </fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                <fo:block>
                                    <fo:table xsl:use-attribute-sets="table5NoBorder">
                                        <fo:table-column column-width="3cm" column-number="1"/>
                                        <fo:table-column column-width="3cm" column-number="2"/>
                                        <fo:table-body>               
                                            <fo:table-row xsl:use-attribute-sets="row">
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                    <fo:block font-weight="bold">Required</fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row>
                                                <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="2">
                                                    <fo:block>
                                                        <fo:table xsl:use-attribute-sets="table5NoBorder" height="100%">
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                                            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                                            <fo:table-body>  
                                                                <fo:table-row height="1cm">
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                                        <fo:block>Insulation R-value</fo:block>
                                                                    </fo:table-cell>
                                                                    <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                                                        <fo:block>Insulation U-factor</fo:block>
                                                                    </fo:table-cell>
                                                                </fo:table-row>
                                                            </fo:table-body>
                                                        </fo:table>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell  xsl:use-attribute-sets="numberCell" >
                                <fo:block>Comments</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='ExteriorFloorType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:E01_ExteriorFloorType]"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:value-of select="ns1:E02_InsulationRValue"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:value-of select="ns1:E02_InsulationUFactor" />
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="ns1:E03_InsulationRValueMinimumRequired">
                                            <xsl:value-of select="ns1:E03_InsulationRValueMinimumRequired" />
                                        </xsl:when>
                                        <xsl:when test="ns1:E03_InsulationUFactorLimit">
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:E03_NotApplicableMessage]"/>                                    
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="ns1:E03_InsulationUFactorLimit">
                                            <xsl:value-of select="ns1:E03_InsulationUFactorLimit" />
                                        </xsl:when>
                                        <xsl:when test="ns1:E03_InsulationRValueMinimumRequired"></xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:E03_NotApplicableMessage]"/>                                    
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="numberCell">
                                <fo:block>
                                    <xsl:value-of select="ns1:E04_ComplianceDocumentTableComments"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <fo:table-cell xsl:use-attribute-sets="cell2P" number-columns-spanned="6">
                                <fo:block>
                                    <xsl:apply-templates select="$path/xsd:element[@name='EEndNote1']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="doesNotApplyWithHeader">
                        <xsl:with-param name="colspan" select="6"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>            
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_F">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>        
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="7">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 8]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 3"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 8]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']" />
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body> 
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:value-of select="$resCompliance/xsd:simpleType[@name='ResidentialCeilingRoofInsulationOption']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F01_ResidentialCeilingRoofInsulationOption]"/>                                    
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="ns1:F02_DoesInsulationHaveAirSpace = 1 or ns1:F02_DoesInsulationHaveAirSpace = 'true'">
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='DoesInsulationHaveAirSpace']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='DoesInsulationHaveAirSpace']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="ns1:F03_RoofAboveDeckInsulation">
                                    <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='RoofAboveDeckInsulation']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F03_RoofAboveDeckInsulation]"/> 
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F03_NotApplicableMessage]"/>     
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="ns1:F04_RoofBelowDeckInsulation">
                                    <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='RoofBelowDeckInsulation']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F04_RoofBelowDeckInsulation]"/> 
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F04_NotApplicableMessage]"/>     
                                </xsl:otherwise>
                            </xsl:choose>     
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='CeilingInsulation']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:F05_CeilingInsulation]"/> 
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="ns1:F06_RadiantBarrierRequired = 1 or ns1:F06_RadiantBarrierRequired = 'true'">
                                    <xsl:value-of select="$path/xsd:element[@name='F06_RadiantBarrierRequired']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$path/xsd:element[@name='F06_RadiantBarrierRequired']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="ns1:F07_IsAtticVented = 1 or ns1:F07_IsAtticVented = 'true'">
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsAtticVented']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsAtticVented']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="7">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='FEndNote1']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>                
            </fo:table-body>
        </fo:table>
     </xsl:template>

    <xsl:template match="ns1:Section_G">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table4']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="8"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="11"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="12"/>       
            <fo:table-column column-width="proportional-column-width(1)" column-number="13"/>  
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="13">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 14]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*[position() &lt; 7]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                    <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="7">
                        <fo:block>
                            <fo:table xsl:use-attribute-sets="table5NoBorder">
                                <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
                                <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
                                <fo:table-body>               
                                    <fo:table-row xsl:use-attribute-sets="row">
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPad" number-columns-spanned="4"  height="0.9cm" >
                                            <fo:block font-weight="bold">Proposed</fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoPadNoBorder" number-columns-spanned="3"  height="0.9cm">
                                            <fo:block font-weight="bold">Minimum Required</fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <fo:table-row   height="1.1cm">
                                        <xsl:for-each select="$path/child::*[position() > 7 and position() &lt; 12]">
                                            <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                <fo:block>
                                                    <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </xsl:for-each>
                                        <xsl:for-each select="$path/child::*[position() > 12 and position() &lt; 15]">
                                            <fo:table-cell xsl:use-attribute-sets="numberCellR">
                                                <fo:block>
                                                    <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                </fo:block>
                                            </fo:table-cell>
                                        </xsl:for-each>
                                        <fo:table-cell xsl:use-attribute-sets="numberCellNoBorder">
                                            <fo:block>
                                                <xsl:value-of select="$path/xsd:choice[xsd:element[@name='G13_SolarReflectanceIndexLimit']]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body> 
                <xsl:for-each select="ns1:Table4/ns1:*">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="ns1:G01_PartitionName"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G02_IsRoofMassGreaterThan25lbft2 = 'true' or ns1:G02_IsRoofMassGreaterThan25lbft2 = 1 "> 
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsRoofMassGreaterThan25lbft2']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                      </xsl:when>
                                      <xsl:otherwise>   
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsRoofMassGreaterThan25lbft2']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                               </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G03_IsRoofPitchGreaterThan2Run12Rise">
                                          <xsl:choose>
                                              <xsl:when test="ns1:G03_IsRoofPitchGreaterThan2Run12Rise = 'true' or ns1:G03_IsRoofPitchGreaterThan2Run12Rise = 1 "> 
                                                  <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsRoofPitchGreaterThan2Run12Rise']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                              </xsl:when>
                                              <xsl:otherwise>   
                                                  <xsl:value-of select="$resCompliance/xsd:simpleType[@name='IsRoofPitchGreaterThan2Run12Rise']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                              </xsl:otherwise>
                                          </xsl:choose>
                                      </xsl:when>
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G03_NotApplicableMessage]"/>
                                       </xsl:otherwise>
                                  </xsl:choose>
                               </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G04_CoolRoofComplianceMethod">
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='CoolRoofComplianceMethod']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G04_CoolRoofComplianceMethod]"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G04_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                                 <!-- <xsl:value-of select="$resCompliance/xsd:simpleType[@name='CoolRoofComplianceMethod']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G04_CoolRoofComplianceMethod]"/>      -->                               
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G05_RoofProductType">
                                          <xsl:value-of select="$resEnvelope/xsd:simpleType[@name='RoofProductType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G05_RoofProductType]"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G05_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G06_CRRCProductID">
                                          <xsl:value-of select="ns1:G06_CRRCProductID"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G06_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G07_CRRC_InitialReflectance">
                                          <xsl:value-of select="ns1:G07_CRRC_InitialReflectance"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G07_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G08_SolarReflectanceAged">
                                          <xsl:value-of select="ns1:G08_SolarReflectanceAged"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G08_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G09_ThermalEmittance">
                                          <xsl:value-of select="ns1:G09_ThermalEmittance"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G09_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G10_SolarReflectanceIndex">
                                          <xsl:value-of select="ns1:G10_SolarReflectanceIndex"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G10_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G11_SolarReflectanceAgedLimit">
                                          <xsl:value-of select="ns1:G11_SolarReflectanceAgedLimit"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G11_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                               </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G12_ThermalEmittanceLimit">
                                          <xsl:value-of select="ns1:G12_ThermalEmittanceLimit"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G12_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                          <fo:table-cell xsl:use-attribute-sets="numberCell">
                              <fo:block>
                                  <xsl:choose>
                                      <xsl:when test="ns1:G13_SolarReflectanceIndexLimit">
                                          <xsl:value-of select="ns1:G13_SolarReflectanceIndexLimit"/>
                                      </xsl:when> 
                                      <xsl:otherwise>
                                          <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:G13_NotApplicableMessage]"/>
                                      </xsl:otherwise>
                                  </xsl:choose>
                              </fo:block>
                          </fo:table-cell>
                      </fo:table-row>
                </xsl:for-each>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="13">
                        <fo:block>
                            <xsl:apply-templates select="$path2/xsd:element[@name='GEndNote1']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_H">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(2)" column-number="7"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="7">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                               <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body> 
                <xsl:call-template name="columnsTableDataOnly">
                    <xsl:with-param name="path2" select="$path"/>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_I">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1.1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(1.1)" column-number="7"/>
            <fo:table-column column-width="proportional-column-width(1.1)" column-number="8"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="11"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="12"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="13"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="14"/>            
            <xsl:call-template name="columnsTableFormat">
                <xsl:with-param name="columnsSpan" select="14"/>
            </xsl:call-template>
        </fo:table>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
            <fo:table-body>
                <xsl:call-template name="rowsTableDataOnly">
                    <xsl:with-param name="path" select="$path"/>
                    <xsl:with-param name="start" select="14"/>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>       
    </xsl:template>

    <xsl:template match="ns1:Section_J">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table6']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <xsl:choose>
            <xsl:when test="child::*">
                <fo:table xsl:use-attribute-sets="table8">
                     <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="8"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
                     <fo:table-column column-width="proportional-column-width(1)" column-number="11"/>
                     <fo:table-column column-width="proportional-column-width(2)" column-number="12"/>
                     <fo:table-header>
                         <fo:table-row  xsl:use-attribute-sets="headerRow">
                             <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="12">                        
                                 <xsl:call-template name="sectionHeading"/>
                             </fo:table-cell>
                         </fo:table-row>
                         <fo:table-row xsl:use-attribute-sets="row">
                             <xsl:for-each select="$path/child::*">
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:choose>
                                             <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                             <xsl:otherwise>
                                                 <xsl:value-of select="position()"/>
                                             </xsl:otherwise>
                                         </xsl:choose>
                                     </fo:block>
                                 </fo:table-cell>
                             </xsl:for-each>
                         </fo:table-row>
                         <fo:table-row xsl:use-attribute-sets="row">
                             <xsl:for-each select="$path/child::*">
                                 <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                                     <fo:block>
                                         <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                     </fo:block>
                                 </fo:table-cell>
                             </xsl:for-each>
                         </fo:table-row>
                     </fo:table-header>
                     <fo:table-body> 
                         <xsl:for-each select="ns1:Table6/ns1:Row">
                             <fo:table-row xsl:use-attribute-sets="row">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="ns1:J01_ResidentialSpaceConditioningSystemName"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialHeatingSystemType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J02_ResidentialHeatingSystemType]"/>
                                      </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="$resHvac/xsd:simpleType[@name='EfficiencyType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J03_EfficiencyType]"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:choose>
                                             <xsl:when test="ns1:J04_EfficiencyMinimumValueAFUE"><xsl:value-of select="ns1:J04_EfficiencyMinimumValueAFUE"/></xsl:when>
                                             <xsl:when test="ns1:J04_EfficiencyMinimumValueCOP"><xsl:value-of select="ns1:J04_EfficiencyMinimumValueCOP"/></xsl:when>
                                             <xsl:when test="ns1:J04_EfficiencyMinimumValueHSPF"><xsl:value-of select="ns1:J04_EfficiencyMinimumValueHSPF"/></xsl:when>
                                         </xsl:choose>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialCoolingSystemType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J05_ResidentialCoolingSystemType]"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="ns1:J06_EfficiencyMinimumValueSEER"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="ns1:J07_EfficiencyMinimumValueEER"/>  
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="$resHvac/xsd:simpleType[@name='DuctSystemType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J08_DuctSystemType]"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="$resHvac/xsd:simpleType[@name='DuctLocation']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J09_DuctLocation]"/>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:choose>
                                             <xsl:when test="ns1:J10_DuctRValueLimit">
                                                 <xsl:value-of select="$resHvac/xsd:simpleType[@name='DuctRValueLimit']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J10_DuctRValueLimit]"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                 <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J10_NotApplicableMessage]"/>
                                             </xsl:otherwise>
                                         </xsl:choose>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:choose>
                                             <xsl:when test="ns1:J11_ThermostatType">
                                                 <xsl:value-of select="$resHvac/xsd:simpleType[@name='ThermostatType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J11_ThermostatType]"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                 <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:J11_NotApplicableMessage]"/>
                                             </xsl:otherwise>
                                         </xsl:choose>
                                     </fo:block>
                                 </fo:table-cell>
                                 <fo:table-cell xsl:use-attribute-sets="numberCell">
                                     <fo:block>
                                         <xsl:value-of select="ns1:J12_ComplianceDocumentTableComments"/>
                                     </fo:block>
                                 </fo:table-cell>
                             </fo:table-row>
                         </xsl:for-each>
                         <fo:table-row xsl:use-attribute-sets="row">
                             <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="12">
                                 <fo:block>
                                     <xsl:apply-templates select="$path2/xsd:element[@name='JEndNote1']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                 </fo:block>
                             </fo:table-cell>
                         </fo:table-row>
                     </fo:table-body>
                 </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="doesNotApplyFull"/>
            </xsl:otherwise>
        </xsl:choose>      
    </xsl:template>

    <xsl:template match="ns1:Section_K">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table8">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
          <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="2">                        
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
              <fo:table-row xsl:use-attribute-sets="row">
                  <xsl:for-each select="$path/child::*[position() &lt; 3]">
                      <fo:table-cell xsl:use-attribute-sets="numberCell">
                          <fo:block>
                              <xsl:choose>
                                  <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                  <xsl:otherwise>
                                      <xsl:value-of select="position()"/>
                                  </xsl:otherwise>
                              </xsl:choose>
                          </fo:block>
                      </fo:table-cell>
                  </xsl:for-each>
              </fo:table-row>
              <fo:table-row xsl:use-attribute-sets="row">
                  <xsl:for-each select="$path/child::*[position() &lt; 3]">
                      <fo:table-cell xsl:use-attribute-sets="numberCell">
                          <fo:block>
                              <xsl:call-template name="formatSuperScript">
                                  <xsl:with-param name="text" select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                              </xsl:call-template>
                          </fo:block>
                      </fo:table-cell>
                  </xsl:for-each>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body> 
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="child::*[position() &lt; 3]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="ns1:Section_L">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table7']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table8">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="3"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="4"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="5"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="6"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="7"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="8"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="9"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="10"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="11"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="12"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="13"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="14"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="15"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="15">                        
                        <xsl:call-template name="sectionHeading"/>
                        <xsl:call-template name="beginNote"/>   
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="$path/child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>  
                <xsl:for-each select="ns1:Table7/ns1:Row">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="ns1:L01_WaterHeatingSystemName"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialWaterHeatingSystemType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L02_ResidentialWaterHeatingSystemType]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialWaterHeaterType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L03_ResidentialWaterHeaterType]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="ns1:L04_WaterHeaterTotalSystemCount"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L05_StorageCapacity">
                                        <xsl:value-of select="ns1:L05_StorageCapacity"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L05_NotApplicableMessage]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='WaterHeaterFuelSource']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L06_WaterHeaterFuelSource]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='WaterHeaterRatedInputUnits']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L07_WaterHeaterRatedInputUnits]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L08_WaterHeaterElectricFiredRatedInput">
                                        <xsl:value-of select="ns1:L08_WaterHeaterElectricFiredRatedInput"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="ns1:L08_WaterHeaterGasFiredRatedInput"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='EfficiencyType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L09_EfficiencyType]"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L10_ThermalEfficiency">
                                        <xsl:value-of select="ns1:L10_ThermalEfficiency"/>
                                    </xsl:when>
                                    <xsl:when test="ns1:L10_WaterHeaterAFUE">
                                        <xsl:value-of select="ns1:L10_WaterHeaterAFUE"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="ns1:L10_EnergyFactor"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L11_WaterHeatingStandbyLossPercent">
                                        <xsl:value-of select="ns1:L11_WaterHeatingStandbyLossPercent"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L11_NotApplicableMessage]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L12_ExteriorTankInsulation">
                                        <xsl:value-of select="ns1:L12_ExteriorTankInsulation"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L12_NotApplicableMessage]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L13_WaterHeatingSolarFraction">
                                        <xsl:value-of select="ns1:L13_WaterHeatingSolarFraction"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L13_NotApplicableMessage]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="ns1:L14_ResidentialDHWCentralDistributionType">
                                        <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialDHWCentralDistributionType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L14_ResidentialDHWCentralDistributionType]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L14_NotApplicableMessage]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:value-of select="$resHvac/xsd:simpleType[@name='ResidentialDHWDwellingUnitDistributionType']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:L15_ResidentialDHWDwellingUnitDistributionType]"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="ns1:Section_M">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[@name='Table8']/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="4.08cm" column-number="1"/>
            <fo:table-column column-width="4.08cm" column-number="2"/>
            <fo:table-column column-width="4.08cm" column-number="3"/>
            <fo:table-column column-width="4.08cm" column-number="4"/>
            <fo:table-column column-width="4.08cm" column-number="5"/>
            <fo:table-column column-width="5.08cm" column-number="6"/>
            <xsl:choose>
                <xsl:when test="child::*">
                    <fo:table-header>
                        <fo:table-row  xsl:use-attribute-sets="headerRow">
                            <fo:table-cell xsl:use-attribute-sets="headerCell" number-columns-spanned="6">                        
                                <xsl:call-template name="sectionHeading"/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <xsl:for-each select="$path/child::*[position() &lt; 13]">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position())"/></xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="position()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                        </fo:table-row>
                        <fo:table-row xsl:use-attribute-sets="row">
                            <xsl:for-each select="$path/child::*">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                       <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body> 
                        <xsl:for-each select="ns1:Table8/ns1:Row">
                            <fo:table-row xsl:use-attribute-sets="row">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:M01_ResidentialDwellingUnitName"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:M02_DwellingUnitConditionedFloorArea"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="ns1:M03_WaterHeatingSystemName">
                                                <xsl:value-of select="ns1:M03_WaterHeatingSystemName"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$resCompliance/xsd:simpleType[@name='NotApplicableMessage']/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value =  current()/ns1:M03_NotApplicableMessage]"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <xsl:for-each select="ns1:M04_WaterHeatingSystemName">
                                        <fo:block>
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </xsl:for-each>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <xsl:for-each select="ns1:M05_ResidentialSpaceConditioningSystemName">
                                        <fo:block>
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </xsl:for-each>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:value-of select="ns1:M06_ComplianceDocumentTableComments"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                    </fo:table-body>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="doesNotApplyWithHeader">
                        <xsl:with-param name="colspan" select="6"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="ns1:Section_N">  
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="headerCell">                        
                        <xsl:call-template name="sectionHeading"/>
                        <fo:block font-weight="normal">
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote1']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>               
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote2']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote3']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote4']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote5']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row xsl:use-attribute-sets="row">
                    <fo:table-cell xsl:use-attribute-sets="cell2P">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[@name='N_BeginNote6']/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
</xsl:stylesheet>