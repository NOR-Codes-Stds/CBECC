' version 2013.WH.28 30 October 2012

' distribution system types for 2008 calcs
%WHDIST_STD =    &B00010000000000000000				' Standard
%WHDIST_PIA =    &B00100000000000000000				' insulated pipe (all)
%WHDIST_SNI =    &B00110000000000000000				' Standard/no insulation
%WHDIST_POU =    &B01000000000000000000				' point of use
%WHDIST_PP =     &B01010000000000000000				' parallel piping
%WHDIST_UPBG =   &B01100000000000000000				' uninsulated pipe below grade
%WHDIST_IPBG =   &B01110000000000000000				' insulated pipe below grade
%WHDIST_RNC =    &B10000000000000000000				' Recirculating/no control
%WHDIST_RTm =    &B10010000000000000000				' Recirculating/timer
%WHDIST_RTmp =   &B10100000000000000000				' Recirculating/temp control
%WHDIST_RTmTmp = &B10110000000000000000				' Recirculation/time+temperature control
%WHDIST_RDRmc =  &B11000000000000000000				' Recirculating/manual
%WHDIST_RDRmsc = &B11010000000000000000				' Recirculating/motion
%WHDIST_TBT =    &B11100000000000000000				' Temperature buffer tank

%RECIRC_DIST =           &B00000000000000001000000000000000     ' flags recirculating distribution system
%MFRECIRC_DIST =         &B00000000000000001100000000000000     ' flags central multi-family recirculating distribution system

' distribution system types for 2013 calcs
%WHDIST2013_STD =        &B00000000000011110000000000000000     ' Standard
%WHDIST2013_PIA =        &B00000000000100000000000000000000     ' pipe insulation, all lines
%WHDIST2013_IPBG =       &B00000000000100010000000000000000     ' insulated and protected pipe below grade
%WHDIST2013_PP =         &B00000000000100100000000000000000     ' parallel piping
%WHDIST2013_RND =        &B00000000000100111000000000000000     ' recirculation, non-demand control
%WHDIST2013_RDMan =      &B00000000000101001000000000000000     ' recirculation, demand control push button
%WHDIST2013_RDAuto =     &B00000000000101011000000000000000     ' recurculation, demand control occupancy/motion
%HERS_REQUIRED =         &B10000000000000000000000000000000
%WHDIST2013_HERSPIA =    &B10000000000100000000000000000000	' pipe insulation, all lines
%WHDIST2013_HERSPP =     &B10000000000100100000000000000000     ' parallel piping
%WHDIST2013_HERSRND =    &B10000000000100111000000000000000     ' recirculation, non-demand control
%WHDIST2013_HERSRDMan =  &B10000000000101001000000000000000     ' recirculation, demand control push button
%WHDIST2013_HERSRDAuto = &B10000000000101011000000000000000     ' recirculation, demand control occupancy/motion
%WHDIST2013_HERSPOU =    &B10000000000101100000000000000000     ' point of use
%WHDIST2013_HERSCDS =    &B10000000000101110000000000000000     ' compact distribution system
%WHDIST2013_CRND =       &B00000000000100111100000000000000     ' multi-family central recirc non-demand control
%WHDIST2013_CRM =        &B00000000000110001100000000000000     ' multi-family central recirc monitoring
%WHDIST2013_CRD =        &B00000000000110011100000000000000     ' multi-family central demand recirc - std design for new construction
%WHDIST2013_HERSCRND =   &B10000000000100111100000000000000     ' multi-family central recirc non-demand control
%WHDIST2013_HERSCRM =    &B10000000000110001100000000000000     ' multi-family central recirc monitoring
%WHDIST2013_HEERSCRD =   &B10000000000110011100000000000000     ' multi-family central demand recirc - std design for new construction

' calculation control for T24DHWHr
%DHWCALC_STD = 0		' calculate Standard Design energy use
%DHWCALC_PROP = 1		' calculate Proposed Design energy use
%DHWCALC_SITE = 0		' returns site non-electric DHW energy use
%DHWCALC_SITEKW = 2		' returns site electric DHW energy use
%DHWCALC_LOAD = 4		' returns energy load instead of site energy
%DHWCALC_GPH = 8		' returns gallons used instead of energy
%DHWCALC_SCH = 10		' draw schedule
%DHWCALC_TG = 12		' ground temp
%DHWCALC_TS = 14		' supply temp
%DHWCALC_HSEU = 16
%DHWCALC_HRDL = 18
%DHWCALC_SSF = 20		' solar savings fraction
%DHWCALC_DLM = 22
%DHWCALC_SITE_NG = 64		' returns site natural gas DHW energy use
%DHWCALC_SITE_PR = 66		' returns site propane DHW energy use
%DHWCALC_SITE_OIL = 68		' returns site oil DHW energy use
%DHWCALC_SITE_ER = 72		' returns site electric resistance DHW energy use
%DHWCALC_SITE_HP = 74		' returns site electric heat pump DHW energy use
%DHWCALC_SITE_PUMP = 76		' returns site electric recirculation pump energy use

%DHWCALC_2015 = 32


' fuel source type indexes
%WHSRC_ER = 0			' electric resistance
%WHSRC_NG = 1			' natural gas / oil
%WHSRC_PR = 2			' propane
%WHSRC_HP = 3			' heat pump

' water heater types
%WHTYPE_BOIL =     0		' boiler
%WHTYPE_IND =      1		' indirect
%WHTYPE_LINST =    2		' large instantaneous
%WHTYPE_LSTOR =    3		' large storage
%WHTYPE_LTANKLES = 2		' large tankless, same as large instantaneous
%WHTYPE_SINST =    5		' small instantaneous
%WHTYPE_SSTOR =    6		' small storage
%WHTYPE_STANKLES = 5		' small tankless, same as small instantaneous
%WHTYPE_STO =      7		' unfired storage tank

' weather DLL field indexes
%WthrDB = 1
%WthrTG = 4

' recirculation pipe types
%PIPETYPE_SUPPLY = 0
%PIPETYPE_RETURN = 1

' recirculation pipe locations
%PIPELOC_COND = 0                   ' conditioned space
%PIPELOC_SC = 1	                    ' semi-conditioned space
%PIPELOC_UC = 2                     ' unconditioned space
%PIPELOC_UG = 3                     ' underground / under slab / buried in spab

' bit flags for T24DHWSystemInit option flags
' only one so far
%SYSTEM_NONCOMPLIANT = 1            ' DHW system is not compliant

' bit flags options of rT24DHWRecircInit
' only one so far
%RCOPTION_XINS = 1                  ' multi-family recirculation loop has extra insulation

DECLARE FUNCTION T24DHWInit CDECL LIB "T24DHW.DLL" ALIAS "T24DHWInit" _
    (BYVAL CFA AS LONG, _           ' Conditioned Floor Area of the entire buidling being simulated.
     BYVAL nUnits AS LONG, _        ' number of housing units simulated.
     BYVAL STORIES AS LONG, _       ' the number of stories in the simulated building.
     BYVAL CZ AS LONG, _            ' California Climate Zone 1-16
     BYVAL HasGas AS LONG, _        ' flags natural gas available at site
     BYVAL pVer AS DWORD, _         ' pointer to caller's version buffer
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG

DECLARE FUNCTION T24DHWSystemInit CDECL LIB "T24DHW.DLL" ALIAS "T24DHWSystemInit" _
    (BYVAL DIST AS LONG, _          ' Distribution system type index
     BYVAL SYSTEM_OPTIONS AS LONG, _ ' bit flags for calculation options
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG

DECLARE FUNCTION T24DHWItem CDECL LIB "T24DHW.DLL" ALIAS "T24DHWItem" _
    (BYVAL hSys AS LONG, _          ' DHW system HANDLE returned by T24DHWSystemInit
     BYVAL iFuel AS LONG, _         ' fuel source index [described in text above]
     BYVAL iTYPE AS LONG, _         ' type index for allowed items [described in text above]
     BYVAL iInput AS LONG, _        ' input rating: watts for electric, Btu/hr for gas
     BYVAL EF AS SINGLE, _          ' energy factor or efficiency
     BYVAL tkVOL AS LONG, _         ' tank volume, gallons
     BYVAL n AS LONG, _             ' number of identical items
     BYVAL RTI AS SINGLE, _         ' tank interior insulation R-value
     BYVAL REI AS SINGLE, _         ' tank exterior insulation R-value
     BYVAL ambient AS LONG, _       ' index TO indicate item ambient conditions
     BYVAL sbl AS SINGLE, _         ' standby Loss, fraction of input rating or pilot energy, Btu/hr
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG

DECLARE FUNCTION T24DHWHr CDECL LIB "T24DHW.DLL" ALIAS "T24DHWHr" _
    (BYVAL MONTH AS LONG, _         ' month
     BYVAL DAY AS LONG, _           ' day
     BYVAL HOUR AS LONG, _          ' hour
     BYVAL TEMPERATURE AS SINGLE, _ ' hourly conditioned space air temperature
     BYVAL FLAGS AS LONG, _         ' calculation control bits. BIT 0 IF SET = Proposed Design, IF CLEAR = Standard Design.  See %DHWCALC_STD and %DHWCALC_PROP.
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS SINGLE

DECLARE FUNCTION T24DHWSF CDECL LIB "T24DHW.DLL" ALIAS "T24DHWSF" _
    (BYVAL hSys AS DWORD, _         ' DHW system handle
     BYVAL pSF AS DWORD, _          ' pointer to array of up TO 8760 Solar Fractions
     BYVAL iSF AS LONG, _           ' an index that tells T24DHWSF what size the array of the Solar Fractions is
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG

DECLARE FUNCTION T24DHWRecircInit CDECL LIB "T24DHW.DLL" ALIAS "T24DHWRecircInit" _
    (BYVAL hSys AS LONG, _          ' DHW system handle returned by T24DHWSystemInit
     BYVAL MFDIST AS LONG, _        ' multi-family distribution loop type
     BYVAL RECIRC_OPTIONS AS LONG, _      ' calculation control bit flag(s)
     BYVAL nLoops AS LONG, _        ' number of loops, ignored if HERS verification not required
     BYVAL pPwr AS SINGLE, _        ' recirculation pump power, bhp
     BYVAL pEff AS SINGLE, _        ' pump efficiency, 0.0 - 1.00
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG

DECLARE FUNCTION T24DHWRecircPipe CDECL LIB "T24DHW.DLL" ALIAS "T24DHWRecircPipe" _
    (BYVAL hSys AS LONG, _          ' DHW system handle returned by T24DHWSystemInit
     BYVAL PipeType AS LONG, _      ' supply or return
     BYVAL Length AS SINGLE, _      ' ft
     BYVAL Diameter AS SINGLE, _    ' inches
     BYVAL Ambient AS DWORD, _      ' WthrDB, etc.
     BYVAL pErr AS DWORD _          ' pointer to caller's error message buffer
    ) AS LONG
