<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:ibex="http://www.xmlpdf.com/2003/ibex/Format"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:svg="http://www.w3.org/2000/svg" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:ns2="http://www.lmonte.com/besm/comp"
	xmlns:com="http://www.lmonte.com/besm/com"
	xmlns:dtyp="http://www.lmonte.com/besm/dtyp"
	xmlns:user="urn:my-scripts"
	version="1.0">
	
	<xsl:include href="../common.xsl"/>
	
	<xsl:variable name="templates" select="document('')/*/xsl:template"/>
	
	<xsl:attribute-set name="cellSmall">
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
		<xsl:attribute name="padding">2pt 2pt 2pt 2pt</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>	
	
	<xsl:attribute-set name="numberCellR2pt">
		<xsl:attribute name="padding-right">2pt</xsl:attribute>
		<xsl:attribute name="padding-left">2pt</xsl:attribute>
		<xsl:attribute name="padding-top">5pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">5pt</xsl:attribute>
		<xsl:attribute name="border-right">1pt solid black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="numberCellNH">
		<xsl:attribute name="padding-top">5pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">5pt</xsl:attribute>
		<xsl:attribute name="border-right">1pt solid black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>		
	
	<xsl:attribute-set name="numberCellNoBorder">
		<xsl:attribute name="padding">5pt 5pt 5pt 5pt</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="numberCellNoPad">
		<xsl:attribute name="border-right">1pt solid black</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="numberCellNoPadNoBorder">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table5NoBorder">
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>		
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>	
	
	<xsl:attribute-set name="tableInTable"> 
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="width">98%</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="border">1pt solid black</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="centerAlign">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="centerAfterBold">
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="page-break-after">avoid</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="normal">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="f8">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="tableSigBlock">
		<fo:table xsl:use-attribute-sets="tableSet1" page-break-before="always" id="Declaration">
			<fo:table-column column-width="50%" column-number="1"/>
			<fo:table-column column-width="50%" column-number="2"/>
			<fo:table-header>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
						<fo:block>Documentation Author's Declaration Statement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">
							<fo:inline font-weight="bold">1.</fo:inline> I certify that this Certificate of Compliance documentation is accurate and complete.</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-header>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor01Name"/>
						</fo:block>                        
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor03Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Signature Date:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">						
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'DocAuthor']/ns2:documentAuthor04SignatureDate,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor05Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>CEA/ HERS Certification Identification (if applicable):</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor06Certification"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor07City,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor08State ,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor09Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor10Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">Responsible Person's Declaration statement </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cell2P" number-columns-spanned="2">
						<fo:block font-size="8pt">
							<fo:block>I certify the following under penalty of perjury, under the laws of the State of California:</fo:block>
							<fo:block margin-left="15pt" margin-top="2pt">
								<fo:list-block>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>1.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The information provided on this Certificate of Compliance is true and correct.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>2.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I am eligible under Division 3 of the Business and Professions Code to accept responsibility for the building design or system design identified on this Certificate of Compliance (responsible designer).</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>3.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>That the energy features and performance specifications, materials, components, and manufactured devices for the building design or system design identified on this Certificate of Compliance conform to the requirements of Title 24, Part 1 and Part 6 of the California Code of Regulations.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>4.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The building design features or system design features identified on this Certificate of Compliance are consistent with the information provided on other applicable compliance documents, worksheets, calculations, plans and specifications submitted to the enforcement agency for approval with this building permit application.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>5.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I will ensure that a registered copy of this Certificate of Compliance shall be made available with the building permit(s) issued for the building, and made available to the enforcement agency for all applicable inspections. I understand that a registered copy of this Certificate of Compliance is required to be included with the documentation the builder provides to the building owner at occupancy.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson01_Name"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company :</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson03_Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Date Signed:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'RespPerson']/ns2:responsiblePerson04_DateSigned,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson06_Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>License:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson07_License"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson08_City,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson09_State ,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson10_Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson11_Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
		
	<xsl:template name="tableSigBlockLandscape">
		<fo:table xsl:use-attribute-sets="tableSet1" page-break-before="always"  id="Declaration">
			<fo:table-column column-width="50%" column-number="1"/>
			<fo:table-column column-width="50%" column-number="2"/>
			<fo:table-header>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
						<fo:block>Documentation Author's Declaration Statement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">
							<fo:inline font-weight="bold">1.</fo:inline> I certify that this Certificate of Compliance documentation is accurate and complete.</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-header>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor01Name"/>
						</fo:block>                        
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor03Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Signature Date:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">							
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'DocAuthor']/ns2:documentAuthor04SignatureDate,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor05Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>CEA/ HERS Certification Identification (if applicable):</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor06Certification"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor07City,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor08State ,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor09Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'DocAuthor']/ns2:documentAuthor10Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">Responsible Person's Declaration statement </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cell2P" number-columns-spanned="2">
						<fo:block font-size="8pt">
							<fo:block>I certify the following under penalty of perjury, under the laws of the State of California:</fo:block>
							<fo:block margin-left="15pt" margin-top="2pt">
								<fo:list-block>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>1.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The information provided on this Certificate of Compliance is true and correct.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>2.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I am eligible under Division 3 of the Business and Professions Code to accept responsibility for the building design or system design identified on this Certificate of Compliance (responsible designer).</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>3.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>That the energy features and performance specifications, materials, components, and manufactured devices for the building design or system design identified on this Certificate of Compliance conform to the requirements of Title 24, Part 1 and Part 6 of the California Code of Regulations.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>4.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The building design features or system design features identified on this Certificate of Compliance are consistent with the information provided on other applicable compliance documents, worksheets, calculations, plans and specifications submitted to the enforcement agency for approval with this building permit application.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>5.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I will ensure that a registered copy of this Certificate of Compliance shall be made available with the building permit(s) issued for the building, and made available to the enforcement agency for all applicable inspections. I understand that a registered copy of this Certificate of Compliance is required to be included with the documentation the builder provides to the building owner at occupancy.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson01_Name"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company :</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson03_Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Date Signed:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() =  'RespPerson']/ns2:responsiblePerson04_DateSigned,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson06_Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>License:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson07_License"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat(//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson08_City,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson09_State ,' ',//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson10_Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="//*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'RespPerson']/ns2:responsiblePerson11_Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>	
	
	<xsl:template name="firstPageHeader">
		<xsl:call-template name="watermark"/>
		<fo:table xsl:use-attribute-sets="tableNB">
			<fo:table-column column-width="65%"/>
			<fo:table-column column-width="35%"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
						<fo:block xsl:use-attribute-sets="heading1 default" text-align-last="justify">
							<xsl:value-of select="//*[local-name() = 'DocID']/@docType"/>
							<fo:leader leader-pattern="space"/>
							<xsl:value-of select="//*[local-name() = 'Payload' ]/@displayTag"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
						<fo:block xsl:use-attribute-sets="heading1 default" text-align-last="justify">
							<xsl:value-of select="$schema/ancestor::xsd:schema/xsd:element[@name='ComplianceDocumentPackage']//xsd:attribute[@name='docTitle']/@fixed"/>
							<fo:leader leader-pattern="space"/> (Page <fo:page-number/>
							of <fo:page-number-citation ref-id="last"/>) </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell pad6">
						<fo:block xsl:use-attribute-sets="default" text-align-last="justify">
							<fo:inline xsl:use-attribute-sets="heading1">Project Name: </fo:inline>
							<fo:leader leader-pattern="space"/>
							<xsl:value-of select="/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'Header']/ns2:header01_ProjectName/text()"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="headerCell pad6">
						<fo:block xsl:use-attribute-sets="default" text-align-last="justify">
							<fo:inline xsl:use-attribute-sets="heading1"> Date Prepared: </fo:inline>
							<fo:leader leader-pattern="space"/>
							<xsl:value-of select="substring-before(/*[local-name() = 'ComplianceDocumentPackage']/*[local-name() = 'DocumentData']/*[local-name() = 'Header']/ns2:header07_DatePrepared/text(),'T')"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template name="columnsTableDataOnlyMultiRow">
		<xsl:param name="path2"/>
		<xsl:for-each select="current()/*/*[local-name(.) = 'Row']">  
			<fo:table-row xsl:use-attribute-sets="row">
				<xsl:for-each select="*">
					<fo:table-cell xsl:use-attribute-sets="numberCell2pt">
						<fo:block>
							<xsl:call-template name="render">
								<xsl:with-param name="ele" select="current()"/>
								<xsl:with-param name="path2" select="$path2"/>
							</xsl:call-template>
						</fo:block>
					</fo:table-cell>
				</xsl:for-each>
				<xsl:variable name="countEmpty" select="count($path2/child::*) - count(current()/*)"/> 
				<xsl:for-each select="$path2/child::*[$countEmpty &gt;= position()]">
					<fo:table-cell xsl:use-attribute-sets="numberCell">
						<fo:block/>
					</fo:table-cell>
				</xsl:for-each>
			</fo:table-row>
		</xsl:for-each> 
	</xsl:template>
	
	<xsl:template name="rowsTableDataOnly">
		<xsl:param name="path" />
		<xsl:param name="start" select="0" />
		<xsl:for-each select="child::*[not(contains(name(.),'BeginNote')) and not(*[local-name(.)='Row'])]">
			<fo:table-row xsl:use-attribute-sets="row">
				<fo:table-cell xsl:use-attribute-sets="numberCell">
					<fo:block>
						<xsl:choose>
							<xsl:when test="$start + position() &lt; 10">0<xsl:value-of select="$start + position()"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$start + position()"/></xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell  xsl:use-attribute-sets="cell">
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
	</xsl:template>
	
	<xsl:template match="xsl:template[@name='tableSigBlockLandscape']">
		<xsl:param name="root"/>
		<fo:table xsl:use-attribute-sets="tableSet1" page-break-before="always"  id="Declaration">
			<fo:table-column column-width="50%" column-number="1"/>
			<fo:table-column column-width="50%" column-number="2"/>
			<fo:table-header>
				<fo:table-row xsl:use-attribute-sets="headerRow">
					<fo:table-cell number-columns-spanned="2" xsl:use-attribute-sets="headerCell pad6">
						<fo:block>Documentation Author's Declaration Statement</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">
							<fo:inline font-weight="bold">1.</fo:inline> I certify that this Certificate of Compliance documentation is accurate and complete.</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-header>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:documentAuthor01Name"/>
						</fo:block>                        
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall" number-columns-spanned="1">
						<fo:block>Documentation Author Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:documentAuthor03Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Signature Date:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">							
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring($root//ns2:documentAuthor04SignatureDate,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:documentAuthor05Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>CEA/ HERS Certification Identification (if applicable):</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:documentAuthor06Certification"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat($root//ns2:documentAuthor07City,' ',$root//ns2:documentAuthor08State ,' ',$root//ns2:documentAuthor09Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:documentAuthor10Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="headerCell2" number-columns-spanned="2">
						<fo:block xsl:use-attribute-sets="headBlock">Responsible Person's Declaration statement </fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cell2P" number-columns-spanned="2">
						<fo:block font-size="8pt">
							<fo:block>I certify the following under penalty of perjury, under the laws of the State of California:</fo:block>
							<fo:block margin-left="15pt" margin-top="2pt">
								<fo:list-block>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>1.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The information provided on this Certificate of Compliance is true and correct.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>2.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I am eligible under Division 3 of the Business and Professions Code to accept responsibility for the building design or system design identified on this Certificate of Compliance (responsible designer).</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>3.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>That the energy features and performance specifications, materials, components, and manufactured devices for the building design or system design identified on this Certificate of Compliance conform to the requirements of Title 24, Part 1 and Part 6 of the California Code of Regulations.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>4.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>The building design features or system design features identified on this Certificate of Compliance are consistent with the information provided on other applicable compliance documents, worksheets, calculations, plans and specifications submitted to the enforcement agency for approval with this building permit application.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
									<fo:list-item xsl:use-attribute-sets="declarationListBlock">
										<fo:list-item-label end-indent="label-end()">
											<fo:block>5.</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>I will ensure that a registered copy of this Certificate of Compliance shall be made available with the building permit(s) issued for the building, and made available to the enforcement agency for all applicable inspections. I understand that a registered copy of this Certificate of Compliance is required to be included with the documentation the builder provides to the building owner at occupancy.</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Name:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:responsiblePerson01_Name"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Responsible Designer Signature:</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Company :</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:responsiblePerson03_Company"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Date Signed:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:choose>
								<xsl:when test="$draft != 'IsDraft'">
									<xsl:value-of select="substring($root//ns2:responsiblePerson04_DateSigned,1,10)"/>
								</xsl:when>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Address:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:responsiblePerson06_Address"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>License:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:responsiblePerson07_License"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>City/State/Zip:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="concat($root//ns2:responsiblePerson08_City,' ',$root//ns2:responsiblePerson09_State ,' ',$root//ns2:responsiblePerson10_Zipcode)"/>
						</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="cellSmall">
						<fo:block>Phone:</fo:block>
						<fo:block xsl:use-attribute-sets="declarationEntry">
							<xsl:value-of select="$root//ns2:responsiblePerson11_Phone"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template name="root">
		<xsl:param name="mainTag"/>
		<xsl:param name="sigBlock"/>
		<xsl:param name="masterReference"/>
		<fo:root xsl:use-attribute-sets="default">
			
			<xsl:call-template name="foLayoutMasterSet"/>
			
			<xsl:call-template name="bookmarkTreeSchema"/>
			
			<fo:page-sequence master-reference="{$masterReference}" format="1" initial-page-number="1">
				
				<xsl:call-template name="foStaticContent"/>
				
				<fo:flow flow-name="xsl-region-body">
					<fo:block>
						<xsl:call-template name="firstPageHeader"/>
					</fo:block>
					<fo:block>
						<xsl:apply-templates select="$mainTag"/>
					</fo:block>
					<fo:block>
						<xsl:apply-templates select="$templates[@name=$sigBlock]">
							<xsl:with-param name="root" select="/*[local-name() = 'ComplianceDocumentPackage']"/>
						</xsl:apply-templates>
					</fo:block>
					<fo:block id="last">&#160;</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
</xsl:stylesheet>