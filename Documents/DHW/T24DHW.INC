; t24dhw.inc for t24dhw.dll

VERSION equ 45

; day of week
SUNDAY		equ	1
MONDAY		equ	2
TUESDAY		equ	3
WEDNESDAY	equ	4
THURSDAY	equ	5
FRIDAY		equ	6
SATURDAY	equ	7

; EU.whSrc source fuel
WHSRC_ER	equ	0	; electric resistance
WHSRC_NG	equ	1	; natural gas
WHSRC_PR	equ	2	; propane
WHSRC_HP	equ	3	; heat pump
WHSRC_OIL	equ	4	; oil
WHSRC_WOOD	equ	5	; wood (not used 2013)

; choices for EU.whTy
WHTYPE_BOIL	equ 0		; boiler
WHTYPE_IND	equ 1		; indirect
WHTYPE_LINST	equ 2		; large instantaneous
WHTYPE_LSTOR	equ 3		; large storage
WHTYPE_LTANKLES	equ WHTYPE_LINST	; large tankless
WHTYPE_SINST	equ 5		; small instantaneous
WHTYPE_SSTOR	equ 6		; small storage
WHTYPE_STANKLES	equ WHTYPE_SINST	; small tankless
WHTYPE_STO	equ 7		; unfired storage tank
WHTYPE_MINI	equ 8		; electric mini-tank

RECIRC_DIST	equ 1000000000000000b
MFRECIRC_DIST	equ 1100000000000000b

; WHSYS.dsTy distribution system type
; pre-2013
WHDIST_STD	equ 1 SHL 16			; Standard
WHDIST_PIA	equ 2 SHL 16			; insulated pipe (all)
WHDIST_SNI	equ 3 SHL 16			; Standard/no insulation
WHDIST_POU	equ 4 SHL 16			; point of use
WHDIST_PP	equ 5 SHL 16			; parallel piping
WHDIST_UPBG	equ 6 SHL 16			; uninsulated pipe below grade
WHDIST_IPBG	equ 7 SHL 16			; insulated pipe below grade
WHDIST_RNC	equ 8 SHL 16 OR RECIRC_DIST	; Recirculating/no control
WHDIST_RTm	equ 9 SHL 16 OR RECIRC_DIST	; Recirculating/timer
WHDIST_RTmp	equ 10 SHL 16 OR RECIRC_DIST	; Recirculating/temp control
WHDIST_RTmTmp	equ 11 SHL 16 OR RECIRC_DIST	; Recirculation/time+temperature control
WHDIST_RDRmc	equ 12 SHL 16 OR RECIRC_DIST	; Recirculating/manual
WHDIST_RDRmsc	equ 13 SHL 16 OR RECIRC_DIST	; Recirculating/motion
WHDIST_TBT	equ 14 SHL 16			; Temperature buffer tank

; 2013
WHDIST2013_STD		equ 15 SHL 16				; Standard also for multi-family with individual water heaters
WHDIST2013_PIA		equ 16 SHL 16				; pipe insulation, all lines
WHDIST2013_IPBG		equ 17 SHL 16				; insulated and protected pipe below grade
WHDIST2013_PP		equ 18 SHL 16				; parallel piping
WHDIST2013_RND		equ 19 SHL 16 OR RECIRC_DIST		; recirculation, non-demand control
WHDIST2013_RDMan	equ 20 SHL 16 OR RECIRC_DIST		; recirculation, demand control push button
WHDIST2013_RDAuto	equ 21 SHL 16 OR RECIRC_DIST		; recirculation, demand control occupancy/motion
HERS_REQUIRED		equ 1 SHL 31
WHDIST2013_HERSPIA	equ WHDIST2013_PIA OR HERS_REQUIRED	; pipe insulation, all lines
WHDIST2013_HERSIPBG	equ WHDIST2013_IPBG OR HERS_REQUIRED	; insulated and protected pipe below grade
WHDIST2013_HERSPP	equ WHDIST2013_PP OR HERS_REQUIRED	; parallel piping
WHDIST2013_HERSRND	equ WHDIST2013_RND OR HERS_REQUIRED	; recirculation, non-demand control
WHDIST2013_HERSRDMan	equ WHDIST2013_RDMan OR HERS_REQUIRED	; recirculation, demand control push button
WHDIST2013_HERSRDAuto	equ WHDIST2013_RDAuto OR HERS_REQUIRED	; recirculation, demand control occupancy/motion
WHDIST2013_HERSPOU	equ 22 SHL 16 OR HERS_REQUIRED		; point of use
WHDIST2013_HERSCDS	equ 23 SHL 16 OR HERS_REQUIRED		; compact distribution system

; for WHSYS.MFdsTy 2013+
WHDIST2013_CRNC		equ WHDIST2013_RND OR MFRECIRC_DIST	; multi-family central recirc no control
WHDIST2013_CRDC		equ 24 SHL 16 OR MFRECIRC_DIST		; multi-family central demand recirc - std design for new construction
WHDIST2013_CRTM		equ 25 SHL 16 OR MFRECIRC_DIST		; multi-family central recirc temperature mod
WHDIST2013_CRTMM	equ 26 SHL 16 OR MFRECIRC_DIST		; multi-family central recirc temperature mod & monitoring
WHDIST2013_HERSCRNC	equ WHDIST2013_CRNC OR HERS_REQUIRED	; multi-family central recirc no control
WHDIST2013_HERSCRDC	equ WHDIST2013_CRDC OR HERS_REQUIRED	; multi-family central demand recirc
WHDIST2013_HERSCRTM	equ WHDIST2013_CRTM OR HERS_REQUIRED	; multi-family central recirc temperature mod
WHDIST2013_HERSCRTMM	equ WHDIST2013_CRTMM OR HERS_REQUIRED	; multi-family central recirc temperature mod monitoring

; for alternate funcion redirection
WHCALC_GPD	equ	0
WHCALC_GPH	equ	1

; recirculation pipe types
PIPETYPE_SUPPLY	equ	0
PIPETYPE_RETURN	equ	1

; recirculation pipe locations
PIPELOC_COND	equ	0
PIPELOC_SC	equ	1			; semi-conditioned space
PIPELOC_UC	equ	2			; unconditioned space
PIPELOC_UG	equ	3			; underground / under slab / buried in spab


IF 0
; hydronic types for HYD.hydtype
HYDTYPE_BASE		equ 0			; Baseboard
HYDTYPE_DHWCR		equ 1			; DHW Central Recirc
HYDTYPE_DHWCRMCS	equ 2			; DHW Central RecircMCS
HYDTYPE_FANCOIL		equ 3			; fan coil
HYDTYPE_NONE		equ 4			; none
HYDTYPE_RADIANT		equ 5			; radiant
HYDTYPE_PIPERUN		equ 6			; pipe run
END IF


SFTYPE_ANN	equ 0			; annual solar fraction
SFTYPE_MLY	equ 1			; monthly solar fractions
SFTYPE_DLY	equ 2			; daily solar fractions

DHWCALC_STD	equ 0			; hourly calculation flag bit 0 = 0
DHWCALC_PROP	equ 1			; hourly calculation flag bit 0 = 1

DHWCALC_FIELDMASK	equ	1011110b OR MFRECIRC_DIST
DHWCALC_SITE		equ	00000b	; hourly calculation flag bit field = 0 for non-electric site load
DHWCALC_SITEKW		equ	00010b	; hourly calculation flag bit field = 1 for electric site load
DHWCALC_LOAD		equ 	00100b	; hourly calculation flag bit field = 2 for HARL
DHWCALC_GPH		equ	01000b	; hourly calculation flag bit field = 4 for GPH
DHWCALC_SCH		equ	01010b	; draw schedule
DHWCALC_TG		equ	01100b	; ground temp
DHWCALC_TS		equ	01110b	; supply temp
DHWCALC_HSEU		equ	10000b
DHWCALC_HRDL		equ	10010b
DHWCALC_SSF		equ	10100b	; solar savings multiplier
DHWCALC_DLM		equ	10110b
DHWCALC_RCHRLL		equ	00000b OR MFRECIRC_DIST	; recirc HRLL
DHWCALC_RCHRDL		equ	00010b OR MFRECIRC_DIST	; recirc HRDL
DHWCALC_RCHRBL		equ	00100b OR MFRECIRC_DIST	; recirc HRBL
DHWCALC_RCHBUL		equ	00110b OR MFRECIRC_DIST	; recirc HBUL
DHWCALC_RCHBWL		equ	01000b OR MFRECIRC_DIST	; recirc HBWL
DHWCALC_RCSCH		equ	01010b OR MFRECIRC_DIST	; recirc SCH
DHWCALC_RCSFLOW		equ	01100b OR MFRECIRC_DIST	; recirc supply flow
DHWCALC_RCRFLOW		equ	01110b OR MFRECIRC_DIST	; recirc return flow

DHWCALC_2015		equ	100000b		; 16 April 2015 or later Standard Design

DHWCALC_SITE_NG		equ	1000000b	; returns site natural gas DHW energy use
DHWCALC_SITE_PR		equ	1000010b	; returns site propane DHW energy use
DHWCALC_SITE_OIL	equ	1000100b	; returns site oil DHW energy use
DHWCALC_SITE_WOOD	equ	1000110b	; returns site wood DHW energy use
DHWCALC_SITE_ER		equ	1001000b	; returns site electric resistance DHW energy use
DHWCALC_SITE_HP		equ	1001010b	; returns site electric heat pump DHW energy use
DHWCALC_SITE_PUMP	equ	1001100b	; returns site electric recirculation pump energy use

; bit flags for T24DHWSystemInit option flags
SYSTEM_NONCOMPLIANT	equ	1

; bit flags for T24DHWRecircInit options
RCOPTIONS_XINS		equ	1
