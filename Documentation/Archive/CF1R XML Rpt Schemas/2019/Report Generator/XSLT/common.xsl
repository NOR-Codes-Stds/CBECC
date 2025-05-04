<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    
    xmlns:ibex="http://www.xmlpdf.com/2003/ibex/Format"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:ns2="http://www.lmonte.com/besm/comp" 
    xmlns:exsl="http://exslt.org/common"
    xmlns:com="http://www.lmonte.com/besm/com"
    xmlns:dtyp="http://www.lmonte.com/besm/dtyp"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:user="urn:my-scripts"
    xmlns:d="http://www.lmonte.com/besm/d"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="xd user msxsl"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 14, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> John Bampton</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="commonjs.xsl"/>
    
    <!-- common document variables ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   -->
    
    <!-- Variable to set status for draft watermark -->    
    <xsl:param name="draft"/>  
    
    <!-- The getPath returns the last part of the schema namespace from the current input XML file and hence the schema filename without the file extension   -->
    <xsl:variable name="schemaFile">
        <xsl:call-template name="getPath"><xsl:with-param name="url" select="namespace-uri(/*)"/></xsl:call-template>
    </xsl:variable>
        
    <!-- The schemaFolder variable is either CF1R, CF2R, CF3R or NRCV   -->
    <xsl:variable name="schemaFolder">
        <xsl:choose>
            <xsl:when test="$schemaFile = 'PSR01E'">CF1R</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($schemaFile,1,4)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!--  fullPathToSchema is the actual full file path to the current XML documents deployed XML schema  -->
    <xsl:variable name="fullPathToSchema" select="concat('deployed/schema/',$schemaFolder,'/',$schemaFile,'.xsd')" />
             
    <!--  All documents or just the CF3RNoTestH.  The schema variable holds the path to the main XML schema element for the current document.  The element holds the Sections for all documents except the CF3RNoTestH.     -->
    <xsl:variable name="schema" select="document($fullPathToSchema)//xsd:schema/xsd:complexType/xsd:sequence|document($fullPathToSchema)//xsd:schema//xsd:element[@name='DocumentData']//xsd:element[@name='AfterHeaderNote1']"/>
    
     <!--  Base schema variables  -->
    <xsl:variable name="resCommon"
        select="document('deployed/schema/base/ResCommon.xsd')/xsd:schema"/>
    <xsl:variable name="resBuilding"
        select="document('deployed/schema/base/ResBuilding.xsd')/xsd:schema"/>
    <xsl:variable name="resEnvelope"
        select="document('deployed/schema/base/ResEnvelope.xsd')/xsd:schema"/>
    <xsl:variable name="resLighting"
        select="document('deployed/schema/base/ResLighting.xsd')/xsd:schema"/>
    <xsl:variable name="resHvac"
        select="document('deployed/schema/base/ResHvac.xsd')/xsd:schema"/>
    <xsl:variable name="resCompliance"
        select="document('deployed/schema/base/ResCompliance.xsd')/xsd:schema"/>
    <xsl:variable name="dataTypes"
        select="document('deployed/schema/base/DataTypes.xsd')/xsd:schema"/>
    
    <!-- Two variables used to translate lowercase to uppercase   -->
    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    
    <!-- Two different types of footer revisions    -->
    <xsl:variable name="footerRevision" select="'2016 Residential Compliance'"/>
    <xsl:variable name="footerRevisionNR" select="'2016 Nonresidential Compliance'"/>
     
    <!-- End common document variables ++++++++++++++++++++++++++++++++++++++++++++++++++++   -->
    
    
    <!-- common document styles  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   -->
    
    <!-- This is the standard spacing between some sections.  Others use foSectionB below   -->
    <xsl:attribute-set name="foSection">
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set> 

    <!-- This is the standard spacing between some sections.  Others use foSection above  -->
    <xsl:attribute-set name="foSectionB">
         <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set> 
    
    <xsl:attribute-set name="footerCell">
        <xsl:attribute name="padding">2pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="footer">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="default">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
    </xsl:attribute-set>    
    
    <!-- Full width table with no border   -->
    <xsl:attribute-set name="tableNB">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="headerRow">        
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="hR">        
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="hR2">        
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>   
    </xsl:attribute-set>
        
    <xsl:attribute-set name="declarationListBlock">
        <xsl:attribute name="margin-bottom">1pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="declarationEntry">
        <xsl:attribute name="font-size">10pt</xsl:attribute>    
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="tableNBB">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="border-right">1pt solid black</xsl:attribute>
        <xsl:attribute name="border-left">1pt solid black</xsl:attribute>
        <xsl:attribute name="border-top">1pt solid black</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cell">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cellC">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cell2">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cellB">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cell2B">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="numberCell">
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>  
    
    <xsl:attribute-set name="numberCellB">
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set> 
    
    <xsl:attribute-set name="numberCellR">
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
        <xsl:attribute name="border-right">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="numberCell2pt">
        <xsl:attribute name="padding-right">2pt</xsl:attribute>
        <xsl:attribute name="padding-left">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="numberCell0">
        <xsl:attribute name="padding-right">0pt</xsl:attribute>
        <xsl:attribute name="padding-left">0pt</xsl:attribute>
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="numberCell2ptB">
        <xsl:attribute name="padding-right">2pt</xsl:attribute>
        <xsl:attribute name="padding-left">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
        
    <xsl:attribute-set name="heading1">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="row">
        <xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>       
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="rown">        
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="watermark">
        <xsl:attribute name="z-index">-1</xsl:attribute>
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="left">5pt</xsl:attribute>
        <xsl:attribute name="top">5pt</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="height">100%</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cellNB">
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table5Row">
        <xsl:attribute name="border-top">1pt solid black</xsl:attribute>
        <xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>
    </xsl:attribute-set>        
    
    <xsl:attribute-set name="table5Cells">       
        <xsl:attribute name="display-align">center</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
    </xsl:attribute-set>   
    
    <xsl:attribute-set name="pad5">
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="pad4">
        <xsl:attribute name="padding">4pt</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="padENV">
        <xsl:attribute name="padding">4pt</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="cellCenter">
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="pad6">
        <xsl:attribute name="padding">6pt</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="cell2P">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cellSmallLandscape">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding-right">2pt</xsl:attribute>
        <xsl:attribute name="padding-left">2pt</xsl:attribute>       
        <xsl:attribute name="font-size">8pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cellSmallLandscapeCenter">
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding-right">2pt</xsl:attribute>
        <xsl:attribute name="padding-left">2pt</xsl:attribute>       
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="right">
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>
        
    <xsl:attribute-set name="headBlock">
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="numberCell1pt">
        <xsl:attribute name="padding-right">1pt</xsl:attribute>
        <xsl:attribute name="padding-left">1pt</xsl:attribute>
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">5pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">center</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="cell3">
        <xsl:attribute name="number-columns-spanned">3</xsl:attribute>
        <xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="tableSet1">
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">auto</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="margin-top">0.083in</xsl:attribute>
    </xsl:attribute-set>     
    
    <xsl:attribute-set name="table8">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table7">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">70%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table10">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">70%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="left15">
        <xsl:attribute name="margin-left">15pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="headerCell">		
        <xsl:attribute name="font-weight">bolder</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>  
    
    <xsl:attribute-set name="headerCell2">		
        <xsl:attribute name="font-weight">bolder</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="padding">2pt</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="foInlineSmallText">
        <xsl:attribute name="font-size">7pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="center">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="tableM">
        <xsl:attribute name="border-collapse">collapse</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="border">1pt solid black</xsl:attribute>
        <xsl:attribute name="font-family">Calibri</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
    </xsl:attribute-set>
    <!-- End common document styles  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  -->
    
    
    <!-- Common templates  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  -->
    <xsl:template name="rowsTableNN">        
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(1)" column-number="2"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeadingNN"/>  
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>    
                <xsl:for-each select="child::*">
                    <fo:table-row xsl:use-attribute-sets="row">                       
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:value-of select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="columnsTableNN">
        <xsl:param name="columnsSpan"/>     
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table-header>
            <fo:table-row  xsl:use-attribute-sets="headerRow">
                <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="{$columnsSpan}">
                    <xsl:call-template name="sectionHeadingNN"/> 
                </fo:table-cell>
            </fo:table-row>           
            <fo:table-row xsl:use-attribute-sets="row heading1">
                <xsl:for-each select="$path2/child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell1pt">
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
                <xsl:for-each select="child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                        <fo:block>
                            <xsl:call-template name="render">
                                <xsl:with-param name="ele" select="current()"/>
                                <xsl:with-param name="path2" select="$path2"/>
                            </xsl:call-template>
                        </fo:block>
                    </fo:table-cell>
                </xsl:for-each>                   
            </fo:table-row>
        </fo:table-body>
    </xsl:template> 
    
    <xsl:template name="bookmarkTreeSchemaNN">
        <fo:bookmark-tree>
            <xsl:for-each select="$schema/child::*[string-length(@name) = 9]">
                <fo:bookmark internal-destination="{@name}">
                    <fo:bookmark-title>
                        <xsl:value-of select="current()/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                    </fo:bookmark-title>
                </fo:bookmark>
            </xsl:for-each>
        </fo:bookmark-tree>
    </xsl:template>	
    
    <xsl:template name="sectionHeadingNN">
        <fo:block><xsl:value-of select="$schema/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/></fo:block>
    </xsl:template>
    
    <xsl:template name="columnsTableDataOnly">
        <xsl:param name="path2"/>
        <xsl:variable name="countEmpty" select="count($path2/child::*) - count(current()/child::*)"/> 
        <fo:table-row xsl:use-attribute-sets="row">
            <xsl:for-each select="current()/*">                
                <fo:table-cell xsl:use-attribute-sets="numberCell">
                    <fo:block>
                        <!--  The parameter ele is just the current element inside the for-each loop         -->
                        <xsl:call-template name="render">
                            <xsl:with-param name="ele" select="current()"/>
                            <xsl:with-param name="path2" select="$path2"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </xsl:for-each>    
            <!--   This last loop is used to add a final single empty column.  It's used where some columns style tables have a comments field as the last cell in the column.
                   The comments field is optional so when it is not present we add on one extra empty cell.  Some hack I did...
            -->
            <xsl:for-each select="$path2/child::*[$countEmpty &gt;= position()]">
                <fo:table-cell xsl:use-attribute-sets="numberCell">
                    <fo:block/>
                </fo:table-cell>
            </xsl:for-each>
        </fo:table-row>
    </xsl:template>
    
    <!-- This produces a single row of data elements. The render template automatically looks up the schemas for possible display terms or just outputs the data value.
         The path2 parameter comes from the current XML main schema
    -->
    <xsl:template name="columnsTableDataOnly2">
        <xsl:param name="path2"/>
        <fo:table-row xsl:use-attribute-sets="row">
            <xsl:for-each select="current()/*">                
                <fo:table-cell xsl:use-attribute-sets="numberCell">
                    <fo:block>
                        <!-- The ele paramater is just the current element inside the for-each loop          -->
                        <xsl:call-template name="render">
                            <xsl:with-param name="ele" select="current()"/>
                            <xsl:with-param name="path2" select="$path2"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:table-cell>
            </xsl:for-each>  
        </fo:table-row>
    </xsl:template>
    
    <!--  This function uses Javascript functions in the root commonjs.xsl to format text into superscript.         
          It still runs in  many places where we still don't have the new embedded markup  -->
    <xsl:template name="formatSuperScript">
        <xsl:param name="text" />
        <xsl:choose>
            <!--  If the text matches the format for superscript we replace the text with superscript markup          -->
            <xsl:when test="user:myMatch(concat('',$text,''))">
                <xsl:value-of select="user:myReplace(concat('',$text,''))" disable-output-escaping="yes"/>
            </xsl:when>
            <!--  Otherwise just print the text      -->
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Used to print out the common static region two column table.  Just reads from the schema and prints the responsible signature as the last row.
         Prints a number in the first column and then the AdditionalRequirements from the schema in the second column.
         The pos parameter is the number of the last element in the schema.  Or the final row in bold used as the responsible signature.
         The sig parameter defaults to 1 so that the responsible signature is printed.  Standard is to use 0 to not print the responsible signature.
    -->
    <xsl:template name="commonStaticRegion2Column">
        <xsl:param name="pos"/>
        <xsl:param name="sig" select="1"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="$path/child::*[position() &lt; $pos]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="formatSuperScript">
                                    <xsl:with-param name="text" select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <xsl:if test="$sig = 1">
                    <xsl:call-template name="responsibleSignature">
                        <xsl:with-param name="numberOfColumnsSpanned" select="2"/>
                        <xsl:with-param name="text" select="$path/child::*[$pos]/xsd:annotation/xsd:documentation[@source = 'AdditionalRequirements']"/>
                    </xsl:call-template>
                </xsl:if>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="commonStaticRegion2ColumnFormat">
        <xsl:param name="pos"/>
        <xsl:param name="sig" select="1"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="$path/child::*[position() &lt; $pos]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <xsl:if test="$sig = 1">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="cellB" number-columns-spanned="2">
                            <fo:block>
                                <xsl:apply-templates select="$path/child::*[$pos]/xsd:annotation/xsd:documentation[@source = 'AdditionalRequirements']"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>
            </fo:table-body>
        </fo:table>
    </xsl:template>    
    
    <xsl:template name="commonStaticRegion2ColumnBetween">
        <xsl:param name="posLess"/>
        <xsl:param name="posGreater"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each
                    select="$path/child::*[position() &lt; $posLess and position() > $posGreater]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="formatSuperScript">
                                    <xsl:with-param name="text" select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <xsl:call-template name="responsibleSignature">
                    <xsl:with-param name="numberOfColumnsSpanned" select="2"/>
                    <xsl:with-param name="text" select="$path/child::*[$posLess]/xsd:annotation/xsd:documentation[@source = 'AdditionalRequirements' ]"/>
                </xsl:call-template>
            </fo:table-body>
        </fo:table>
    </xsl:template>      
      
    <xsl:template name="commonStaticRegion2ColumnIfTrue">
        <xsl:param name="pos"/>
        <xsl:param name="trueElement"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:choose>
                    <xsl:when test="//*[local-name(.) = $trueElement] =  'true' or //*[local-name(.) = $trueElement] = 1 ">
                        <xsl:for-each select="$path/child::*[position() &lt; $pos]">
                            <fo:table-row xsl:use-attribute-sets="row">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="position()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="cell">
                                    <fo:block>
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text" select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                        <xsl:call-template name="responsibleSignature">
                            <xsl:with-param name="numberOfColumnsSpanned" select="2"/>
                            <xsl:with-param name="text" select="$path/child::*[$pos]/xsd:annotation/xsd:documentation[@source = 'AdditionalRequirements' ]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="doesNotApply"><xsl:with-param name="numberOfColumnsSpanned" select="2"/></xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose> 
            </fo:table-body>
        </fo:table>
    </xsl:template>   
    
    <xsl:template name="commonStaticRegion2ColumnIf">
        <xsl:param name="pos"/>
        <xsl:param name="trueElement"/>
        <xsl:param name="value"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:choose>
                    <xsl:when test="//*[local-name(.) = $trueElement] =  $value">
                        <xsl:for-each select="$path/child::*[position() &lt; $pos]">
                            <fo:table-row xsl:use-attribute-sets="row">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="position()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="cell">
                                    <fo:block>
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text">
                                                <xsl:choose>
                                                    <xsl:when test="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']">
                                                        <xsl:value-of select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                        <xsl:call-template name="responsibleSignature">
                            <xsl:with-param name="numberOfColumnsSpanned" select="2"/>
                            <xsl:with-param name="text" select="$path/child::*[$pos]/xsd:annotation/xsd:documentation[@source = 'AdditionalRequirements' ]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="doesNotApply"><xsl:with-param name="numberOfColumnsSpanned" select="2"/></xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose> 
            </fo:table-body>
        </fo:table>
    </xsl:template> 
      
    <xsl:template name="columnsTable">
        <xsl:param name="columnsSpan"/>
        <xsl:param name="start" select="0"/>
        <xsl:param name="header" select="1"/>
        <xsl:param name="notes" select="0"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table-header>
            <xsl:if test="$header = 1">
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="{$columnsSpan}">
                        <xsl:call-template name="sectionHeading"/>                  
                        <xsl:for-each select="$path/child::*">
                            <xsl:if test="contains(@name,'BeginNote')">
                                <fo:block font-weight="normal">
                                    <xsl:call-template name="formatSuperScript">
                                        <xsl:with-param name="text" select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                    </xsl:call-template>
                                </fo:block>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:if>
            <fo:table-row xsl:use-attribute-sets="row heading1">
                <xsl:for-each select="$path2/child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="position() + $start &lt; 10">0<xsl:value-of select="position() + $start"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="position() + $start"/></xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                </xsl:for-each>
            </fo:table-row>
            <fo:table-row xsl:use-attribute-sets="row heading1">
                <xsl:for-each select="$path2/child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell1pt">
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
            <xsl:for-each select="current()/*/*">
                <xsl:variable name="countEmpty" select="count($path2/child::*) - count(child::*)"/>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path2"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                    <xsl:for-each select="$path2/child::*[$countEmpty &gt;= position()]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block/>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </xsl:for-each>
            <xsl:if test="$notes = 1">
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="{$columnsSpan}">
                        <fo:block>
                            Notes: 
                           
                                <xsl:apply-templates select="current()/*[substring-after(local-name(.),'_') = 'SectionComments']"/>
                            
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:if>
        </fo:table-body>
    </xsl:template>
    
    <xsl:template name="columnsTableFormat">
        <xsl:param name="columnsSpan"/>
        <xsl:param name="start" select="0"/>
        <xsl:param name="header" select="1"/>
        <xsl:param name="notes" select="0"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <xsl:variable name="path2" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence/xsd:element/xsd:complexType/xsd:sequence"/>
        <fo:table-header>
            <xsl:if test="$header = 1">
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="{$columnsSpan}">
                        <xsl:call-template name="sectionHeading"/>                  
                        <xsl:call-template name="beginNote"/>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:if>
            <fo:table-row xsl:use-attribute-sets="row heading1">
                <xsl:for-each select="$path2/child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="position() + $start &lt; 10">0<xsl:value-of select="position() + $start"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="position() + $start"/></xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                </xsl:for-each>
            </fo:table-row>
            <fo:table-row xsl:use-attribute-sets="row heading1">
                <xsl:for-each select="$path2/child::*">
                    <fo:table-cell xsl:use-attribute-sets="numberCell1pt">
                        <fo:block>
                            <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='FieldText']"/>                           
                        </fo:block>
                    </fo:table-cell>
                </xsl:for-each>
            </fo:table-row>
        </fo:table-header>
        <fo:table-body>			
            <xsl:for-each select="current()/*/*">
                <xsl:variable name="countEmpty" select="count($path2/child::*) - count(child::*)"/>
                <fo:table-row xsl:use-attribute-sets="row">
                    <xsl:for-each select="child::*">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path2"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:for-each>
                    <xsl:for-each select="$path2/child::*[$countEmpty &gt;= position()]">
                        <fo:table-cell xsl:use-attribute-sets="numberCell2pt">
                            <fo:block/>
                        </fo:table-cell>
                    </xsl:for-each>
                </fo:table-row>
            </xsl:for-each>
            <xsl:if test="$notes = 1">
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="{$columnsSpan}">
                        <fo:block>
                            Notes: 
                            
                            <xsl:apply-templates select="current()/*[substring-after(local-name(.),'_') = 'SectionComments']"/>
                            
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:if>
        </fo:table-body>
    </xsl:template>
    
    <xsl:template name="responsibleSignature">
        <xsl:param name="numberOfColumnsSpanned"/>
        <xsl:param name="text"/>
        <fo:table-row xsl:use-attribute-sets="row">
            <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="{$numberOfColumnsSpanned}">
                <fo:block font-weight="bold">
                    <xsl:apply-templates select="$text"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>  
    
    <xsl:template name="getPath"> 
        <xsl:param name="url"/> 
        <xsl:choose> 
            <xsl:when test="contains($url,'/')"> 				
                <xsl:call-template name="getPath"> 
                    <xsl:with-param name="url" select="substring-after($url,'/')"/> 
                </xsl:call-template> 
            </xsl:when> 
            <xsl:otherwise>
                <xsl:value-of select="$url"/> 
            </xsl:otherwise> 
        </xsl:choose>
    </xsl:template>	
    
    
    
    
    <!-- this is a standard 3 column table where each row looks like: position - fieldtext - value   -->
    <xsl:template name="rowsTable"> 
        <xsl:param name="b" select="1"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="3">
                        <xsl:call-template name="sectionHeading"/>
                        <xsl:if test="$b = 1 ">
                            <xsl:for-each select="$path/child::*[contains(@name,'BeginNote')]">
                                <fo:block font-weight="normal">
                                    <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                </fo:block>
                            </xsl:for-each>
                        </xsl:if>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>    
                <xsl:for-each select="child::*[not(contains(name(.),'BeginNote')) and not(*[local-name(.)='Row']) and not(contains(name(.),'BeforeNote'))]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cellC">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:apply-templates select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="rowsTableBetween">
        <xsl:param name="posLess"/>
        <xsl:param name="b" select="1"/>
        <xsl:param name="list" select="''"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="3">
                        <xsl:call-template name="sectionHeading"/>
                        <xsl:if test="$b = 1 ">
                            <xsl:for-each select="$path/child::*[contains(@name,'BeginNote')]">
                                <fo:block font-weight="normal">
                                    <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                </fo:block>
                            </xsl:for-each>
                        </xsl:if>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="child::*[not(contains(local-name(.),'BeginNote')) and not(*[local-name(.)='Row']) and not(contains(local-name(.),'BeforeNote'))][ position() &lt; $posLess]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:apply-templates select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                            <xsl:if test="contains($list,local-name(current()))">
                                <fo:block>
                                     <xsl:choose>
                                         <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                             <xsl:apply-templates select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                         </xsl:when>
                                         <xsl:otherwise>
                                             <xsl:apply-templates select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                                         </xsl:otherwise>
                                     </xsl:choose>
                                </fo:block>
                            </xsl:if>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
        <fo:block xsl:use-attribute-sets="foSection">
            <xsl:call-template name="singleRowB">
                <xsl:with-param name="text" select="$path/*[position() = last()]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
            </xsl:call-template>
        </fo:block> 
    </xsl:template>
    
    <xsl:template name="rowsTableFt">        
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="3">
                        <xsl:call-template name="sectionHeading"/>                  
                        <xsl:for-each select="$path/child::*[contains(@name,'BeginNote')]">
                            <fo:block font-weight="normal">
                                <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                            </fo:block>
                        </xsl:for-each>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>    
                <xsl:for-each select="child::*[not(contains(name(.),'BeginNote')) and not(*[local-name(.)='Row']) and not(contains(name(.),'BeforeNote'))]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text" select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text" select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                        </xsl:call-template>                                        
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="rowsTableFormat4Col">        
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="5%" column-number="1"/>
            <fo:table-column column-width="25%" column-number="2"/>
            <fo:table-column column-width="20%" column-number="3"/>
            <fo:table-column column-width="50%" column-number="4"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="4">
                        
                        <xsl:call-template name="sectionHeading"/> 
                        
                        <xsl:for-each select="$path/child::*[contains(@name,'BeginNote')]">
                            <fo:block font-weight="normal">
                                <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                            </fo:block>
                        </xsl:for-each>
                        
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>    
                <xsl:for-each select="child::*[not(contains(name(.),'BeginNote')) and not(*[local-name(.)='Row']) and not(contains(name(.),'BeforeNote'))]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <xsl:attribute name="number-columns-spanned">
                                <xsl:choose>
                                    <xsl:when test="position() = last()">1</xsl:when>
                                    <xsl:otherwise>2</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:apply-templates select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell  xsl:use-attribute-sets="cell">
                            <xsl:attribute name="number-columns-spanned">
                                <xsl:choose>
                                    <xsl:when test="position() = last()">2</xsl:when>
                                    <xsl:otherwise>1</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
  
    
    <xsl:template name="rowsTableFtIf"> 
        <xsl:param name="trueElement"/>
        <xsl:param name="value"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="2"/>
            <fo:table-column column-width="proportional-column-width(15)" column-number="3"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="pad5" number-columns-spanned="3">
                        <xsl:call-template name="sectionHeading"/>       
                        <xsl:if test="//*[local-name(.) = $trueElement] = $value">
                            <xsl:for-each select="$path/child::*[contains(@name,'BeginNote')]">
                                <fo:block font-weight="normal">
                                    <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                            </fo:block>
                        </xsl:for-each>
                        </xsl:if>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>    
                <xsl:choose>
                    <xsl:when test="//*[local-name(.) = $trueElement] =  $value">
                        <xsl:for-each select="child::*[not(contains(name(.),'BeginNote')) and not(*[local-name(.)='Row']) and not(contains(name(.),'BeforeNote'))]">
                            <fo:table-row xsl:use-attribute-sets="row">
                                <fo:table-cell xsl:use-attribute-sets="numberCell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="position() &lt; 10">0<xsl:value-of select="position()"/></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell  xsl:use-attribute-sets="cell">
                                    <fo:block>
                                        <xsl:choose>
                                            <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                                <xsl:call-template name="formatSuperScript">
                                                    <xsl:with-param name="text" select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="formatSuperScript">
                                                    <xsl:with-param name="text" select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                                </xsl:call-template>                                        
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell  xsl:use-attribute-sets="cell">
                                    <fo:block>
                                        <xsl:call-template name="render">
                                            <xsl:with-param name="ele" select="current()"/>
                                            <xsl:with-param name="path2" select="$path"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="doesNotApply"><xsl:with-param name="numberOfColumnsSpanned" select="3"/></xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>      
            </fo:table-body>
        </fo:table>
    </xsl:template>    
    
    <!-- This is a table with the verification and section notes at the bottom of the table with the responsible signature as the last row in bold. 
        The initial rows just show: number - additional requirements.  These initial rows are just a static content region.
    -->
    <xsl:template name="rowsVerification">
        <xsl:param name="pos"/>
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="5%" column-number="1"/>
            <fo:table-column column-width="25%" column-number="2"/>
            <fo:table-column column-width="70%" column-number="3"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell3">                        
                        <xsl:call-template name="sectionHeading"/> 
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>   
                
                <!--   this is the static content region of the section that just outputs a row for each additional requirements        -->
                <xsl:for-each select="$path/child::*[position() &lt;= $pos]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="position() &lt; 10"><xsl:value-of select="concat('0',position() )"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                            <fo:block>
                                <xsl:apply-templates select="xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                
                <!--  the next two rows are for the verification and section notes            -->
                <xsl:for-each select="child::*[ position() > $pos and position() &lt;= $pos+2]">
                    <fo:table-row xsl:use-attribute-sets="row">
                        <fo:table-cell xsl:use-attribute-sets="numberCell">
                            <fo:block>
                                <xsl:choose>
                                    <!-- the position() here has started from 1 again since we are inside a new for loop  -->
                                    <xsl:when test="position() + $pos &lt; 10"><xsl:value-of select="concat('0',position()+$pos )"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="position() + $pos"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell" display-align="center">
                            <fo:block>
                                <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:apply-templates select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                    </xsl:otherwise>
                                </xsl:choose>                               
                                
                               <!-- <xsl:choose>
                                    <xsl:when test="$path/xsd:element[@name = local-name(current())]">
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text" select="$path/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="formatSuperScript">
                                            <xsl:with-param name="text" select="$path/xsd:choice[xsd:element[@name = local-name(current())]]/xsd:annotation/xsd:documentation[@source='FieldText']"/>
                                        </xsl:call-template>                                        
                                    </xsl:otherwise>
                                </xsl:choose>-->
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cell">
                            <fo:block>
                                <xsl:call-template name="render">
                                    <xsl:with-param name="ele" select="current()"/>
                                    <xsl:with-param name="path2" select="$path"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
                <!-- output the final additional requirements in bold as the final row of the section as the responsible signature -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="cellB">
                        <fo:block>
                            <xsl:apply-templates select="$path/xsd:element[position()=$pos+3]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>              
            </fo:table-body>
        </fo:table>
    </xsl:template>
        
    <!--  This adds the bookmarks to the PDF      -->
    <xsl:template name="bookmarkTreeSchema">
        <fo:bookmark-tree>
            <xsl:for-each select="$schema/child::*[string-length(@name) = 9]">
                <fo:bookmark internal-destination="{@name}">
                    <fo:bookmark-title>
                        <xsl:value-of select="concat(substring-before(@name,'_'),' ',substring-after(@name,'_'),' - ', current()/xsd:annotation/xsd:documentation[@source='FieldText'])"/>
                    </fo:bookmark-title>
                </fo:bookmark>
            </xsl:for-each>
            <fo:bookmark internal-destination="Declaration">
                <fo:bookmark-title>Documentation Author's Declaration Statement</fo:bookmark-title>
            </fo:bookmark>
        </fo:bookmark-tree>
    </xsl:template>	
    
    <!--  Prints the typical compliance statement table
        First row is comprised of section heading and begin note
        Second row just matches on the last element in the xml as well as in the schema in the current section and outputs the display term for true or false.
    -->
    <xsl:template name="complianceStatement">
        <xsl:variable name="path" select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1.5)" column-number="1"/>
            <fo:table-column column-width="proportional-column-width(30)" column-number="2"/>
            <fo:table-header>
                <fo:table-row  xsl:use-attribute-sets="headerRow">
                    <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
                        <xsl:call-template name="sectionHeading"/>
                        <xsl:call-template name="beginNote"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row xsl:use-attribute-sets="row" font-size="10pt">
                    <fo:table-cell xsl:use-attribute-sets="numberCell">
                        <fo:block>01</fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="cell">
                        <fo:block>
                            <xsl:choose>
                                <xsl:when test="*[last()] = 'true' or *[last()] = 1 "> 
                                    <xsl:apply-templates select="$resCompliance/xsd:simpleType[@name = substring-after($path/xsd:element[last()]/@type,':') ]/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='true']"/>
                                </xsl:when>
                                <xsl:otherwise>   
                                    <xsl:apply-templates select="$resCompliance/xsd:simpleType[@name = substring-after($path/xsd:element[last()]/@type,':') ]/xsd:annotation/xsd:appinfo/dtyp:displayterm[@value='false']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>   
    
    <!-- Every main document calls this template to add in missing section elements so we can match on them.   -->
    <xsl:template name="addMissingSections">
        <xsl:variable name="defaultNamespace" select="namespace-uri(current())"/>
        <xsl:variable name="currentElementName" select="name(current())"/>
        <xsl:variable name="currentMatchedElement" select="current()"/>
        <xsl:variable name="newMainElement">
            <xsl:element name="{$currentElementName}"> 
                <xsl:for-each select="$schema/child::*">					
                    <xsl:variable name="currentSchemaElement" select="current()/@name"/>					
                    <xsl:choose>
                        <xsl:when test="msxsl:node-set($currentMatchedElement)/*[name(.) = $currentSchemaElement]">
                            <xsl:for-each select="msxsl:node-set($currentMatchedElement)/*[name(.) = $currentSchemaElement]">
                                <xsl:copy-of  select="."/>                            
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="{@name}" namespace="{$defaultNamespace}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:element> 
        </xsl:variable>	        
        <xsl:variable name="sortedNewMainElement">
            <xsl:element name="{$currentElementName}"> 
                <xsl:for-each select="msxsl:node-set($newMainElement)/*/child::*">
                    <xsl:sort select="name(current())"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>	
        <fo:block margin-top="10pt"></fo:block>        
        <xsl:for-each select="msxsl:node-set($sortedNewMainElement)/*/child::*[string-length(name(.)) = 9]">
            <fo:block xsl:use-attribute-sets="foSectionB" id="{local-name(.)}">
                <xsl:apply-templates select="."/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <!-- This prints the does not apply row and takes a single paramater the number of columns for the cell to span or number of columns in the parent table -->
    <xsl:template name="doesNotApply">
        <xsl:param name="numberOfColumnsSpanned" select="1"/>
        <fo:table-row xsl:use-attribute-sets="row">
            <fo:table-cell number-columns-spanned="{$numberOfColumnsSpanned}" xsl:use-attribute-sets="numberCell">
                <fo:block font-size="10pt">This section does not apply to this project.</fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    
    <!--    Used to just print the section heading and defaults to a one column table        -->
    <xsl:template name="doesNotApplyTableHeader">
        <xsl:param name="numberOfColumnsSpanned" select="1" />
        <fo:table-header>
            <fo:table-row  xsl:use-attribute-sets="headerRow">
                <fo:table-cell xsl:use-attribute-sets="cellNB" number-columns-spanned="{$numberOfColumnsSpanned}">
                    <xsl:call-template name="sectionHeading"/>
                </fo:table-cell>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>    
    
    <xsl:template name="doesNotApplyWithHeader">
        <xsl:param name="colspan"/>
        <xsl:call-template name="doesNotApplyTableHeader"><xsl:with-param name="numberOfColumnsSpanned" select="$colspan"/></xsl:call-template>
        <fo:table-body>
            <xsl:call-template name="doesNotApply"><xsl:with-param name="numberOfColumnsSpanned" select="$colspan"/></xsl:call-template>
        </fo:table-body>    
    </xsl:template>
    
    <!--  Used to print the a full does not apply table with header row and single dna row    -->
    <xsl:template name="doesNotApplyFull">
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>            
            <xsl:call-template name="doesNotApplyTableHeader"/>
            <fo:table-body>
                <xsl:call-template name="doesNotApply"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="watermark">
        <xsl:choose>
            <xsl:when test="$draft='IsDraft'">                
                <fo:block>                    
                    <fo:block-container xsl:use-attribute-sets="watermark">                        
                        <fo:block>                            
                            <fo:instream-foreign-object>  
                                <svg xmlns="http://www.w3.org/2000/svg" width="680" height="920">                                    
                                    <text font-family="Arial Black" font-size="30pt"
                                        style="fill:rgb(192,192,192)" x="-10" y="300" width="680"
                                        text-anchor="middle" transform="rotate(-54, 340, 15)"> Not
                                        useable for compliance </text>                                    
                                </svg>                                
                            </fo:instream-foreign-object>                            
                        </fo:block>                        
                    </fo:block-container>                    
                </fo:block>                
            </xsl:when>
            <xsl:when test="$draft='IsTest'">
                <fo:block>                    
                    <fo:block-container xsl:use-attribute-sets="watermark">
                        <fo:block>                            
                            <fo:instream-foreign-object>  
                                <svg xmlns="http://www.w3.org/2000/svg" width="680" height="920">                                    
                                    <text font-family="Arial Black" font-size="30pt"                                        
                                        style="fill:rgb(192,192,192)" x="150" y="300"                                        
                                        width="680" text-anchor="middle"                                        
                                        transform="rotate(-54, 340, 15)">                                        
                                        Test Document Only-Not valid for compliance                                        
                                    </text>                                    
                                </svg>                                
                            </fo:instream-foreign-object> 
                        </fo:block> 
                    </fo:block-container>                    
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="renderValue">
        <xsl:param name="basePrefix"/>
        <xsl:param name="baseSimpleTypeName"/>  
        <xsl:param name="ele"/>        
        <xsl:variable name="baseSchema">
            <xsl:choose>
                <xsl:when test="$basePrefix = 'com'"><xsl:copy-of select="$resCommon"/></xsl:when>
                <xsl:when test="$basePrefix = 'bld'"><xsl:copy-of select="$resBuilding"/></xsl:when>
                <xsl:when test="$basePrefix = 'env'"><xsl:copy-of select="$resEnvelope"/></xsl:when>
                <xsl:when test="$basePrefix = 'lit'"><xsl:copy-of select="$resLighting"/></xsl:when>
                <xsl:when test="$basePrefix = 'hvac'"><xsl:copy-of select="$resHvac"/></xsl:when>
                <xsl:when test="$basePrefix = 'comp'"><xsl:copy-of select="$resCompliance"/></xsl:when>
                <xsl:when test="$basePrefix = 'dtyp'"><xsl:copy-of select="$dataTypes"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//xsd:appinfo[@source='displayterm']">
                <xsl:choose>
                    <xsl:when test="($ele = 1 or $ele = 'true') and msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//xsd:restriction[@base='xsd:boolean']">
                        <xsl:apply-templates select="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//dtyp:displayterm[@value='true']"/>
                    </xsl:when>
                    <xsl:when test="($ele = 0 or $ele = 'false') and msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//xsd:restriction[@base='xsd:boolean'] ">
                        <xsl:apply-templates select="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//dtyp:displayterm[@value='false']"/>
                    </xsl:when>
                    <xsl:when test="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//dtyp:displayterm[@value = $ele ]">
                        <xsl:apply-templates select="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//dtyp:displayterm[@value = $ele ]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$ele"/>
                    </xsl:otherwise>
                </xsl:choose>                        
            </xsl:when>
            <!-- when the base type is of type xsd:dateTime format just the date  -->
            <xsl:when test="msxsl:node-set($baseSchema)//xsd:simpleType[@name = $baseSimpleTypeName]//xsd:restriction[@base='xsd:dateTime']">
                <xsl:value-of select="substring-before($ele,'T')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$ele"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="render">
        <xsl:param name="ele"/>
        <xsl:param name="path2"/>
        <xsl:choose>            
            <!-- when local display terms            -->
            <xsl:when test="($ele = 1 or $ele = 'true') and $path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value='true']">
                <xsl:apply-templates select="$path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value='true']"/>
            </xsl:when>
            
            <xsl:when test="($ele = 0 or $ele = 'false') and $path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value='false']">
                <xsl:apply-templates select="$path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value='false']"/>
            </xsl:when>
            
            <xsl:when test="$path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value=$ele]">
                <xsl:apply-templates select="$path2//xsd:element[@name = local-name( $ele ) ]/xsd:annotation/xsd:appinfo[@source='displayterm']/dtyp:displayterm[@value=$ele]"/>
            </xsl:when>    
            
            <xsl:when test="$path2//xsd:element[@name = local-name( $ele ) ]/@type">
                <xsl:variable name="basePrefix" select="substring-before($path2//xsd:element[@name = local-name($ele) ]/@type,':')"/>
                <xsl:variable name="baseSimpleTypeName" select="substring-after($path2//xsd:element[@name = local-name($ele) ]/@type,':')"/>            
                <xsl:call-template name="renderValue">
                    <xsl:with-param name="basePrefix" select="$basePrefix"/>
                    <xsl:with-param name="baseSimpleTypeName" select="$baseSimpleTypeName"/> 
                    <xsl:with-param name="ele" select="$ele"/>
                </xsl:call-template>
            </xsl:when>            
            <xsl:when test="$path2//xsd:element[@name = local-name( $ele ) ]//xsd:restriction/@base">
                <xsl:variable name="basePrefix" select="substring-before($path2//xsd:element[@name = local-name($ele) ]//xsd:restriction/@base,':')"/>
                <xsl:variable name="baseSimpleTypeName" select="substring-after($path2//xsd:element[@name = local-name($ele) ]//xsd:restriction/@base,':')"/>            
                <xsl:call-template name="renderValue">
                    <xsl:with-param name="basePrefix" select="$basePrefix"/>
                    <xsl:with-param name="baseSimpleTypeName" select="$baseSimpleTypeName"/>
                    <xsl:with-param name="ele" select="$ele"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates select="$ele"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>      
    
    <xsl:template name="singleRowTable">
        <xsl:param name="text"/>
        <xsl:param name="text2" select="''"/>
        <xsl:param name="fontWeight" select="'bold'"/>
        <xsl:param name="fontStyle" select="'normal'" />
        <xsl:param name="fontSize" select="''"/>
        <xsl:param name="space" select="'0mm'"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-body>
                <fo:table-row xsl:use-attribute-sets="headerRow">
                    <xsl:if test="$fontSize != ''">
                        <xsl:attribute name="font-size"><xsl:value-of select="$fontSize"/></xsl:attribute>
                    </xsl:if>
                    <fo:table-cell xsl:use-attribute-sets="pad5">
                        <fo:block font-weight="{$fontWeight}" font-style="{$fontStyle}">
                            <xsl:apply-templates select="$text"/>
                        </fo:block>
                        <xsl:if test="$text2 != ''">
                            <fo:block font-weight="{$fontWeight}" font-style="{$fontStyle}" margin-top="{$space}">
                                <xsl:value-of select="$text2"/>
                            </fo:block>
                        </xsl:if>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="singleRow">
        <xsl:param name="text"/>
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-body>
                <fo:table-row xsl:use-attribute-sets="hR2">                  
                    <fo:table-cell xsl:use-attribute-sets="pad5">
                        <fo:block>
                            <xsl:apply-templates select="$text"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="singleRowB">
        <xsl:param name="text"/>
        <xsl:param name="b" select="1"/>
        <fo:table xsl:use-attribute-sets="table">
            <fo:table-column column-width="proportional-column-width(1)" column-number="1"/>
            <fo:table-body>
                <xsl:choose>
                    <xsl:when test="$b = 1">
                        <fo:table-row xsl:use-attribute-sets="headerRow">                    
                            <fo:table-cell xsl:use-attribute-sets="pad5">
                                <fo:block>
                                    <xsl:apply-templates select="$text"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:table-row xsl:use-attribute-sets="hR2">                    
                            <fo:table-cell xsl:use-attribute-sets="pad5">
                                <fo:block>
                                    <xsl:apply-templates select="$text"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:otherwise>
                </xsl:choose>              
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="sectionHeading">
        <xsl:param name="f" select="1"/>
        <fo:block><xsl:value-of select="substring-after(local-name(current()),'Section_')"/>. <xsl:choose>
            <xsl:when test="$f = 1"><xsl:apply-templates select="$schema/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='FieldText']"/></xsl:when>
            <xsl:otherwise><xsl:apply-templates select="$schema/xsd:element[@name = local-name(current())]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/></xsl:otherwise>
        </xsl:choose> 
        </fo:block>
    </xsl:template>
    
    <xsl:template name="beginNote">
        <fo:block font-weight="normal" font-size="10pt"><xsl:apply-templates select="$schema/xsd:element[@name = local-name(current())]/xsd:complexType/xsd:sequence/xsd:element[contains(@name,'BeginNote')]/xsd:annotation/xsd:documentation[@source='AdditionalRequirements']"/></fo:block>
    </xsl:template>
    
    <xsl:template name="foLayoutMasterSet">		
        <ibex:properties 
            title="{$schema/ancestor::xsd:schema//xsd:element[@name='DocID']//xsd:attribute[@name='docTitle']/@fixed}"
            subject="{$schema/ancestor::xsd:schema//xsd:element[@name='DocID']//xsd:attribute[@name='docType']/@fixed}"
            author="California Energy Commission">
            <ibex:custom name="Compliance Document GUID" value="{//*[local-name(.) = 'Payload']/@complianceDocumentGUID}"/>
            <ibex:custom name="Processed Date" value="{//*[local-name(.) = 'Payload']/@processedDate}"/>
            <ibex:custom name="Report Requestor" value="{//*[local-name(.) = 'Payload']/@reportRequestor}" />
            <ibex:custom name="IP Address" value="{//*[local-name(.) = 'Payload']/@reportRequestorIP_Address}" />
            <ibex:custom name="Validates" value="{//*[local-name(.) = 'Payload']/@validates}" />
            <ibex:custom name="Document Subtitle" value="{//*[local-name(.) = 'DocID']/@docVariantSubtitle }"/>
            <ibex:custom name="Revision" value="{//*[local-name(.) = 'Payload']/@revision }"/>
            <ibex:custom name="Compliance Document Schema Version" value="{//*[local-name(.) = 'Payload']/@complianceDocumentSchemaVersion }"/>			
        </ibex:properties>
        
        <fo:layout-master-set>	
            <fo:simple-page-master master-name="letterFirstMasterCF1R" page-height="279.4mm"
                page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body  margin-bottom="15mm"/>
                <fo:region-after region-name="regionAfterLetterFirstCF1R" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterEvenMasterCF1R" page-height="279.4mm" page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterEvenCF1R" extent="20mm"/>
                <fo:region-after region-name="regionAfterLetterEvenCF1R" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterOddMasterCF1R" page-height="279.4mm" page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterOddCF1R" extent="20mm"/>
                <fo:region-after region-name="regionAfterLetterOddCF1R" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterBlankMasterCF1R" page-height="279.4mm" page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterBlankCF1R" extent="20mm"/>
                <fo:region-after region-name="regionAfterLetterBlankCF1R" extent="15mm"/>
            </fo:simple-page-master>
            
            <fo:simple-page-master master-name="letterLandFirstMasterCF1R" page-height="215.9mm" page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-bottom="10.2mm"/>				
                <fo:region-after region-name="regionAfterLetterLandfirstCF1R" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandEvenMasterCF1R" page-height="215.9mm" page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="10.2mm"/>
                <fo:region-before region-name="regionBeforeLetterLandEvenCF1R" extent="5mm"/>
                <fo:region-after region-name="regionAfterLetterLandEvenCF1R" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandOddMasterCF1R" page-height="215.9mm" page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="10.2mm"/>
                <fo:region-before region-name="regionBeforeLetterLandOddCF1R" extent="5mm"/>
                <fo:region-after region-name="regionAfterLetterLandOddCF1R" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandBlankMasterCF1R" page-height="215.9mm" page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterLandBlankCF1R" extent="15mm"/>
                <fo:region-after region-name="regionAfterLetterLandBlankCF1R" extent="15mm"/>
            </fo:simple-page-master>            
            
            <fo:simple-page-master master-name="letterFirstMaster" page-height="279.4mm"
                page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body  margin-bottom="15mm"/>
                <fo:region-after region-name="regionAfterLetterFirst" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterEvenMaster" page-height="279.4mm"
                page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterEven" extent="15mm"/>
                <fo:region-after region-name="regionAfterLetterEven" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterOddMaster" page-height="279.4mm"
                page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterOdd" extent="15mm"/>
                <fo:region-after region-name="regionAfterLetterOdd" extent="15mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterBlankMaster" page-height="279.4mm"
                page-width="215.9mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterBlank" extent="15mm"/>
                <fo:region-after region-name="regionAfterLetterBlank" extent="15mm"/>
            </fo:simple-page-master>
            
            <fo:simple-page-master master-name="letterLandFirstMaster" page-height="215.9mm"
                page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-bottom="10.2mm"/>
                <fo:region-after region-name="regionAfterLetterLandFirst" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandEvenMaster" page-height="215.9mm"
                page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="10.2mm"/>
                <fo:region-before region-name="regionBeforeLetterLandEven" extent="5mm"/>
                <fo:region-after region-name="regionAfterLetterLandEven" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandOddMaster" page-height="215.9mm"
                page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="10.2mm"/>
                <fo:region-before region-name="regionBeforeLetterLandOdd" extent="5mm"/>
                <fo:region-after region-name="regionAfterLetterLandOdd" extent="10.2mm"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="letterLandBlankMaster" page-height="215.9mm"
                page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm"
                margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="15mm"/>
                <fo:region-before region-name="regionBeforeLetterLandBlank" extent="15mm"/>
                <fo:region-after region-name="regionAfterLetterLandBlank" extent="15mm"/>
            </fo:simple-page-master>            
            
            <fo:simple-page-master master-name="letter1FirstMaster" page-height="215.9mm" page-width="279.4mm" margin-top="12.7mm" margin-left="12.7mm" margin-right="12.7mm" margin-bottom="10.2mm">
                <fo:region-body margin-top="20mm" margin-bottom="10mm"/>
                <fo:region-before region-name="regionBeforeLetter1First" extent="20mm"/>
                <fo:region-after region-name="regionAfterLetter1first"  extent="10mm"/>
            </fo:simple-page-master>
            
            <fo:page-sequence-master master-name="repeatLetter1">
                <fo:single-page-master-reference master-reference="letter1FirstMaster"/>
            </fo:page-sequence-master>
            
            <fo:page-sequence-master master-name="repeatLetterLand">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="letterLandFirstMaster"
                        page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="letterLandBlankMaster"
                        blank-or-not-blank="blank"/>
                    <fo:conditional-page-master-reference master-reference="letterLandEvenMaster"
                        odd-or-even="even"/>
                    <fo:conditional-page-master-reference master-reference="letterLandOddMaster"
                        odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
            
            <fo:page-sequence-master master-name="repeatLetter">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="letterFirstMaster"
                        page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="letterBlankMaster"
                        blank-or-not-blank="blank"/>
                    <fo:conditional-page-master-reference master-reference="letterEvenMaster"
                        odd-or-even="even"/>
                    <fo:conditional-page-master-reference master-reference="letterOddMaster"
                        odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>  
            
            <fo:page-sequence-master master-name="repeatLetterLandCF1R">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="letterLandFirstMasterCF1R" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="letterLandBlankMasterCF1R" blank-or-not-blank="blank"/>
                    <fo:conditional-page-master-reference master-reference="letterLandEvenMasterCF1R" odd-or-even="even"/>
                    <fo:conditional-page-master-reference master-reference="letterLandOddMasterCF1R" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
            
            <fo:page-sequence-master master-name="repeatLetterCF1R">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="letterFirstMasterCF1R" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="letterBlankMasterCF1R" blank-or-not-blank="blank"/>
                    <fo:conditional-page-master-reference master-reference="letterEvenMasterCF1R" odd-or-even="even"/>
                    <fo:conditional-page-master-reference master-reference="letterOddMasterCF1R" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>
    
    <xsl:template name="foStaticContent">
        
        <fo:static-content flow-name="regionBeforeLetter1First">
            <xsl:call-template name="watermark"/>
            <fo:table xsl:use-attribute-sets="table">
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="cellNB pad6">
                            <fo:block xsl:use-attribute-sets="heading1 default">
                                <xsl:value-of select="//*[local-name() = 'DocID']/@docTitle"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cellNB  pad6">
                            <fo:block xsl:use-attribute-sets="heading1 default" text-align="right">
                                <xsl:value-of select="//*[local-name() = 'Footer']/*[local-name() = 'footer03_DataRegistryProvider']"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
                            <fo:block xsl:use-attribute-sets="heading1 default" text-align="right">
                                (Page <fo:page-number/>	of <fo:page-number-citation ref-id="last"/>)
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:static-content>
        
        <fo:static-content flow-name="regionAfterLetter1first">
            <xsl:call-template name="watermark"/>
            <fo:table xsl:use-attribute-sets="tableNB">
                <fo:table-column column-width="45%"/>
                <fo:table-column column-width="30%"/>
                <fo:table-column column-width="25%"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="cellNB pad6" number-columns-spanned="2">
                            <fo:block xsl:use-attribute-sets="default">
                                Date Generated: 	<xsl:value-of select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,'T')"/><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of select="substring(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,12,8)"/>
                                
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cellNB  pad6">
                            <fo:block xsl:use-attribute-sets="default" text-align="right">
                                HERS Provider: <xsl:value-of select="//*[local-name() = 'Footer']/*[local-name() = 'footer03_DataRegistryProvider']"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="cellNB pad6">
                            <fo:block xsl:use-attribute-sets="default">
                                CA Building Energy Efficiency Standards - Residential Compliance
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cellNB pad6">
                            <fo:block>Report Version: 
                                <xsl:value-of select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@revision"/>
                            </fo:block>
                            <fo:block>Schema Version: 
                                <xsl:value-of select="$schema/ancestor::xsd:schema/attribute::version"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="cellNB pad6">
                            <fo:block xsl:use-attribute-sets="default" text-align="right">
                                January 2016
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:static-content>
        
		<fo:static-content flow-name="regionBeforeLetterLandEvenCF1R">
		    <xsl:call-template name="beforeLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterLandOddCF1R">
            <xsl:call-template name="beforeLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterLandBlankCF1R">
            <xsl:call-template name="beforeLetter"/>
			<fo:block font-family="arial" font-size="10pt" font-weight="bold" font-style="italic" text-align="center" padding-top="150pt">This Page Intentionally Blank</fo:block>
		</fo:static-content>
                
        <fo:static-content flow-name="regionAfterLetterLandEvenCF1R">
            <xsl:call-template name="afterLetterLand"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandOddCF1R">
            <xsl:call-template name="afterLetterLand"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandBlankCF1R">
            <xsl:call-template name="afterLetterLand"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandfirstCF1R">
            <xsl:call-template name="afterLetterLand"/>
		</fo:static-content>
        
        <fo:static-content flow-name="regionBeforeLetterEvenCF1R">
            <xsl:call-template name="beforeLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterOddCF1R">
            <xsl:call-template name="beforeLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterBlankCF1R">
            <xsl:call-template name="beforeLetter"/>
			<fo:block font-family="arial" font-size="10pt" font-weight="bold" font-style="italic" text-align="center" padding-top="150pt">This Page Intentionally Blank</fo:block>
		</fo:static-content>
        
        <fo:static-content flow-name="regionAfterLetterFirstCF1R">
            <xsl:call-template name="afterLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterEvenCF1R">
            <xsl:call-template name="afterLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterOddCF1R">			
            <xsl:call-template name="afterLetter"/>
		</fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterBlankCF1R">
			<xsl:call-template name="afterLetter"/>
		</fo:static-content>
        
        <fo:static-content flow-name="regionBeforeLetterEven">
            <xsl:call-template name="beforeLetter"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterOdd">
            <xsl:call-template name="beforeLetter"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterBlank">
            <xsl:call-template name="beforeLetter"/>
            <fo:block font-family="arial" font-size="10pt" font-weight="bold" font-style="italic" text-align="center" padding-top="150pt">This Page Intentionally Blank</fo:block>
        </fo:static-content>
        
        <fo:static-content flow-name="regionAfterLetterFirst">
            <xsl:call-template name="afterLetter"/>
        </fo:static-content>
        <fo:static-content flow-name="regionAfterLetterEven">
            <xsl:call-template name="afterLetter"/>
        </fo:static-content>
        <fo:static-content flow-name="regionAfterLetterOdd">
            <xsl:call-template name="afterLetter"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterBlank">
            <xsl:call-template name="afterLetter"/>
        </fo:static-content>
        
        <fo:static-content flow-name="regionBeforeLetterLandEven">
            <xsl:call-template name="beforeLetter"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionBeforeLetterLandOdd">
            <xsl:call-template name="beforeLetter"/>
        </fo:static-content>  
        <fo:static-content flow-name="regionBeforeLetterLandBlank">
            <xsl:call-template name="beforeLetter"/>
            <fo:block font-family="arial" font-size="10pt" font-weight="bold" font-style="italic" text-align="center" padding-top="150pt">This Page Intentionally Blank</fo:block>
        </fo:static-content> 
        
        <fo:static-content flow-name="regionAfterLetterLandEven">
            <xsl:call-template name="afterLetterLand"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandOdd">
            <xsl:call-template name="afterLetterLand"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandBlank">
            <xsl:call-template name="afterLetterLand"/>
        </fo:static-content>        
        <fo:static-content flow-name="regionAfterLetterLandFirst">
            <xsl:call-template name="afterLetterLand"/>
        </fo:static-content>        
	</xsl:template> 
    
    <xsl:template name="afterLetter">
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-column column-width="42%"/>
            <fo:table-column column-width="34%"/>
            <fo:table-column column-width="24%"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer">Registration Number: <xsl:choose>
                            <xsl:when test="$draft != 'IsDraft'">
                                <xsl:value-of
                                    select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer01_RegistrationNumber"
                                />
                            </xsl:when>
                        </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer">Registration Date/Time: <xsl:choose>
                            <xsl:when test="$draft != 'IsDraft'">
                                <xsl:value-of
                                    select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer02_RegistrationDateTime,'T')"
                                /><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of
                                    select="substring(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer02_RegistrationDateTime,12,8)"
                                />
                            </xsl:when>
                        </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer right">HERS Provider:
                            <xsl:value-of
                                select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@reportRequestor"
                            />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-column column-width="42%"/>
            <fo:table-column column-width="25%"/>
            <fo:table-column column-width="33%"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer">CA Building Energy Efficiency Standards</fo:block>
                        <fo:block xsl:use-attribute-sets="footer">
                        		<xsl:choose>
                                <xsl:when test="contains($schema/ancestor::xsd:schema/@targetNamespace,'NRCV')">                                    
                                    <xsl:value-of select="$footerRevisionNR"/>
                                </xsl:when>
                                <xsl:otherwise>                                    
                                    <xsl:value-of select="$footerRevision"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer">Report Version: <xsl:value-of select="$schema/ancestor::xsd:schema/attribute::version"/>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="footer">Schema Version: <xsl:value-of select="$schema/ancestor::xsd:schema//xsd:attribute[@name='revision']/attribute::fixed"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell">
                        <fo:block xsl:use-attribute-sets="footer right">Report Generated:
                            <xsl:value-of
                                select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,'T')"
                            /><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of
                                select="substring(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,12,8)"
                            />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="afterLetterLand">
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-column column-width="45%"/>
            <fo:table-column column-width="30%"/>
            <fo:table-column column-width="25%"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer"> Registration Number:
                            <xsl:choose>
                                <xsl:when test="$draft != 'IsDraft'">
                                    <xsl:value-of select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer01_RegistrationNumber"/>
                                </xsl:when>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer"> Registration Date/Time:  
                            <xsl:choose>
                                <xsl:when test="$draft != 'IsDraft'">
                                    <xsl:value-of select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer02_RegistrationDateTime,'T')"/><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of select="substring(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'Footer']/ns2:footer02_RegistrationDateTime,12,8)"/>
                                </xsl:when>
                            </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer  right"> HERS Provider: <xsl:value-of select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@reportRequestor"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer"> CA Building Energy Efficiency Standards - 
                            <xsl:choose>
                               <xsl:when test="contains($schema/ancestor::xsd:schema/@targetNamespace,'NRCV')">                                    
                                   <xsl:value-of select="$footerRevisionNR"/>
                               </xsl:when>
                               <xsl:otherwise>                                    
                                   <xsl:value-of select="$footerRevision"/>
                               </xsl:otherwise>
                           </xsl:choose>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer">Report Version: <xsl:value-of select="$schema/ancestor::xsd:schema/attribute::version"/>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="footer">Schema Version: <xsl:value-of select="$schema/ancestor::xsd:schema//xsd:attribute[@name='revision']/attribute::fixed"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="footerCell pad6">
                        <fo:block xsl:use-attribute-sets="footer right">Report Generated: 
                            <xsl:value-of select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,'T')"/><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of select="substring(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'Payload']/@processedDate,12,8)"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="beforeLetter">
        <xsl:call-template name="watermark"/>
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-column column-width="50%"/>
            <fo:table-column column-width="50%"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
                        <fo:block xsl:use-attribute-sets="heading1 default" text-align-last="justify">
                            <xsl:value-of select="translate(//*[local-name() = 'DocID']/@docType,$lower,$upper)"/>
                            <fo:leader leader-pattern="space"/>
                            <xsl:value-of select="//*[local-name() = 'Payload']/@displayTag"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
                        <fo:block xsl:use-attribute-sets="heading1 default" text-align-last="justify">
                            <xsl:value-of select="$schema/ancestor::xsd:schema/xsd:element[@name='ComplianceDocumentPackage']//xsd:attribute[@name='docTitle']/@fixed"/>
                            <fo:leader leader-pattern="space"/> (Page <fo:page-number/> of <fo:page-number-citation ref-id="last"/>) </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>			
    </xsl:template>
    <!-- End Common templates  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  -->
        
    
    <!-- Table 5 common templates +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   -->
    <xsl:template match="ul" mode="table5">
        <fo:block margin-left="15pt">
            <fo:list-block>
                <xsl:apply-templates  mode="table5"/>
            </fo:list-block>
        </fo:block>
    </xsl:template>    
    
    <xsl:template match="li"  mode="table5">
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="parent::*/@class = 'italic' ">
                            <xsl:attribute name="font-style">italic</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates  mode="table5"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template match="p" mode="table5">
        <fo:block start-indent="5pt">
            <xsl:choose>
                <xsl:when test="@class='bold'">
                    <xsl:attribute name="font-weight">bold</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates  mode="table5"/>
        </fo:block>
    </xsl:template> 
    
    <xsl:template match="hr" mode="table5">
        <fo:leader leader-length="100%" leader-pattern="rule"/>
    </xsl:template>
    
    <xsl:template match="text()"   mode="table5"><xsl:copy/></xsl:template>
    
    <xsl:template match="table"  mode="table5">
        <fo:table xsl:use-attribute-sets="tableNB">
            <fo:table-header>
                <xsl:apply-templates select="thead/tr"  mode="table5"/>
            </fo:table-header>
            <fo:table-body>
                <xsl:apply-templates select="tbody/tr"  mode="table5"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template match="tr" mode="table5">
        <fo:table-row xsl:use-attribute-sets="table5Row">
            <xsl:apply-templates select="td | th"  mode="table5"/>
        </fo:table-row>
    </xsl:template>
    
    <xsl:template match="th" mode="table5">
        <fo:table-cell number-columns-spanned="{@colspan}" xsl:use-attribute-sets="table5Cells">
            <xsl:attribute name="text-align">
                <xsl:choose>
                    <xsl:when test="@class = 'left'">left</xsl:when>
                    <xsl:otherwise>center</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="following-sibling::th">
                    <xsl:attribute name="border-right">1pt solid black</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <fo:block><xsl:apply-templates  mode="table5"/></fo:block>
        </fo:table-cell>
    </xsl:template>
    
    <xsl:template match="td" mode="table5">
        <fo:table-cell number-columns-spanned="{@colspan}"  xsl:use-attribute-sets="table5Cells">
            <xsl:attribute name="text-align">
                <xsl:choose>
                    <xsl:when test="@class = 'left'">left</xsl:when>
                    <xsl:otherwise>center</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="following-sibling::td">
                    <xsl:attribute name="border-right">1pt solid black</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <fo:block><xsl:apply-templates  mode="table5"/></fo:block>
        </fo:table-cell>
    </xsl:template>
    <!-- End Table 5 common templates +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   -->
    
    
    
    <!-- Start d: namespace markup templates   -->
    <xsl:template match="d:sup">
        <fo:inline baseline-shift="super" font-size="smaller"><xsl:apply-templates/></fo:inline>
    </xsl:template>
    
    <xsl:template match="d:sub">
        <fo:inline font-size="7pt"><xsl:apply-templates/></fo:inline>
    </xsl:template>
        
    <xsl:template match="d:b">
        <fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
    </xsl:template>
    
    <xsl:template match="d:i">
        <fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
    </xsl:template>
    
    <xsl:template match="d:u">
        <fo:inline text-decoration="underline"><xsl:apply-templates/></fo:inline>
    </xsl:template>
    
    <xsl:template match="d:lte">
        <fo:inline>&lt;=</fo:inline>
    </xsl:template>
    
    <xsl:template match="d:gte">
        <fo:inline>>=</fo:inline>
    </xsl:template>
    
    <xsl:template match="d:micron">
        <fo:inline>&#181;</fo:inline>
    </xsl:template>
    
    <xsl:template match="d:deg">
        <fo:inline>&#176;</fo:inline>
    </xsl:template>
    
    <xsl:template match="d:line1">
        <fo:block></fo:block>
    </xsl:template>
    
    <xsl:template match="d:line2">
        <fo:block></fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
    </xsl:template>
           
    <xsl:template match="d:line3">
        <fo:block></fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
    </xsl:template>
    
    <xsl:template match="d:line4">
        <fo:block></fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
        <fo:block white-space-collapse="false" 
            white-space-treatment="preserve" 
            font-size="0pt" line-height="10px">.</fo:block>
    </xsl:template>
    
    <xsl:template match="d:tab1">
        <fo:inline>&#160;&#160;&#160;&#160;</fo:inline>
    </xsl:template>
    
    <xsl:template match="d:l">       
        <fo:list-block provisional-distance-between-starts="1cm">
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template match="d:list">
        <fo:list-item xsl:use-attribute-sets="declarationListBlock" margin-left="10pt">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:choose>                       
                        <xsl:when test="parent::d:l[@t='A']">
                            <xsl:number format="A."/>
                        </xsl:when>
                        <xsl:when test="parent::d:l[@t='a']">
                            <xsl:number format="a."/>
                        </xsl:when>
                        <xsl:when test="parent::d:l[@t='R#']">
                            <xsl:number format="i."/>
                        </xsl:when>
                        <xsl:when test="parent::d:l[@t='*']">•</xsl:when>
                        <xsl:when test="parent::d:l[@t='#']">
                            <xsl:number format="1."/>
                        </xsl:when>
                    </xsl:choose>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
</xsl:stylesheet>