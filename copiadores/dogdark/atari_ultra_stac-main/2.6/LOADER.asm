//	icl "../base/sys_equates.m65"
//	org $1000 
LOAD	
	icl "load1.asm"

TITLO	= [[loader.titlo - loader] + load]
NME2	= [[loader.nme2 - loader] + load]

PAG7
	icl "PAGINA7.ASM"
TITLOP7		= [[pagina7.TITLOP7 - pagina7] + pag7]	
TITLO2P7	= [[pagina7.TITLO2P7 - pagina7] + pag7]
	
PAG4
	icl "PAGINA4.ASM"

@GENDAT
	.BYTE 0
ESPSIO
    .BYTE $55,$55
NME
    .BYTE "...................."
BLQ
    .BYTE "..."
PFIN
    .BYTE 0,0
