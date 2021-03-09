@LEN =  LEN+2
@LBAF = LEN+4
PPILA = LEN+5
PCRSR = $CB
ORG =   PCRSR
SVMSC = $58
POSXY = $54
LENGHT = $4000
BAFER = $4000
FR0 =   $D4
CIX =   $F2
AFP =   $D800
IFP =   $D9AA
FPI =   $D9D2
FASC =  $D8E6
ZFR0 =  $DA44
FDIV =  $DB28
FMUL =  $DADB
FMOVE = $DDB6
INBUFF = $F3
LBUFF = $0580
LLOAD = PAG7-LOAD
LAUTO = PAG4-PAG7
BL4 =   LAUTO/128
LAST =  LAUTO-128*BL4
GENDAT = $47
;************************************************
; INICIO DE CODIGO PRINCIPAL
;************************************************
	ORG $2000
;************************************************
; INCLUIMOS LIBRERIAS
;************************************************
	icl "base/sys_equates.m65"
	ICL 'paginas/KEM.ASM'
	icl 'paginas/injektor.asm'
	ICL 'paginas/MEM256K.ASM'
	ICL 'paginas/HEXASCII.ASM'
LOAD	
	icl "paginas/load1.asm"

TITLO	= [[loader.titlo - loader] + load]
NME2	= [[loader.nme2 - loader] + load]

PAG7
	icl "paginas/PAGINA7.ASM"
TITLOP7		= [[pagina7.TITLOP7 - pagina7] + pag7]	
TITLO2P7	= [[pagina7.TITLO2P7 - pagina7] + pag7]
	
PAG4
	icl "paginas/PAGINA4.ASM"

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
;************************************************
;DEFINICION DEL DISPLAY
;PANTALLA PRINCIPAL
;************************************************
DLS
	.BYTE $70,$70,$70,$46
	.WORD SHOW
	.BYTE $70,$02,$02,$02,$02,$02
	.BYTE $02,$02,$02,$02,$02,$02
	.BYTE $70,$02,$02,$02,$02,$02
	.BYTE $02,$02,$70,$02
	.BYTE $41
	.WORD DLS
;************************************************
; DEFINICION DEL DISPLAY
; PARA DIRECTORIO
;************************************************
?DIR
	.BYTE $70,$70,$70,$46
	.WORD ???DIR
	.BYTE $70,$02,$02,$02,$02,$02,$02,$02
	.BYTE $02,$02,$41
	.WORD ?DIR
;************************************************
;VALORES PARA DIPLAY LIST
;PANTALLA PRINCIPAL
;************************************************
SHOW
	;   . DOGDARK  SOFTWARES .
	.SB "                    "
	.SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
	.SB "|DOGCOPY ULTRA 256K 3.4 BY DOGDARK 2020|"
	.SB +32,"ARRRRRRRRRRRRRRRWRRRRRRRRRRRRRRRRRRRRRRD"
	.SB "|"
	.SB +128,"DATA           "
	.SB "|"
	.SB +128," 12345678901234567890 "
	.SB "|"
	.SB "|BANCOS      "
MUESTROBANCOS
	.SB "00 | TITULO 01            |"
	.SB "|MEMORIA "
MUESTROMEMORIA
	.SB "000000 | "
TITULO01
 	.SB "******************** |"
	.SB "|PORTB      "
MUESTROPORTB
	.SB "000 | TITULO 02            |"
	.SB "|COPIAS       "
TOTALCOPIAS
	.SB "0"
	.SB " | "
TITULO02
	.SB "******************** |"
	.SB "|BYTES   "
BYTES
	.SB "000000 | FUENTE               |"
	.SB "|BLOQUES    "
BLOQUES	
	.SB "000 | "
FUENTE
	.SB "******************** |"
	.SB +32,"ZRRRRRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRRRC"
BANQUEO
	.SB "****************************************"
	.SB "****************************************"
	.SB "****************************************"
	.SB "****************************************"
	.SB "****************************************"
	.SB "****************************************"
	.SB "*************************************280"
	.SB "SISTEMAS PARA COMPUTADORAS ATARI DOGDARK"
;************************************************
;VALORES PARA PANTALLA DIRECTORIO
;************************************************
???DIR
	.SB "     DIRECTORIO     "
??DIR
:400	.SB " "

;************************************************
;BYTES RESERVADOS PARA ALGUNAS FUNCIONES
;************************************************
RY
	.BYTE 0,0,0
LEN
	.BYTE 0,0,0
CONT
	.BYTE 0,0
STARTF
	.BYTE 0,0
FINISH
	.BYTE 0,0
@BL4
	.BYTE 0
?FUENTE
	.BYTE 'D:'
??FUENTE
	.BYTE '                    '
BBLQS
	.BYTE "000",$9B
ALL
	.BYTE 'D:*.*',$9B
BAKBYT
	.SB "000000"
BAKBLQ
	.SB "000"
BANCA
	.BYTE 0,0
MOM
	.BYTE 0,0,0
BLOCK
	.BYTE 0,0
;************************************************
;ANTIPIRATEO
;************************************************
ROMCEANDO
	LDX #19
ROMCEANDO1
	CLC
	LDA MODIFICOROM,X
	ADC #46
	STA SHOW,X
	DEX
	BPL ROMCEANDO1
	RTS
PIRATEO
	LDA SHOW+10
	CMP #$73
	BEQ PIRATEO2
	JMP PIRERROR
PIRATEO2
	LDA SHOW+4
	CMP #$E4
	BEQ PIRATEO3
	JMP PIRERROR
PIRATEO3
	RTS
PDLS
	.BYTE $70,$70,$70,$42
	.WORD SHP
	.BYTE $41
	.WORD PDLS
SHP 
	.SB "ERROR.....                              "
PIRERROR
	LDX # <PDLS
	LDY # >PDLS
	STX $230
	STY $231
PIRLOOP
	JMP PIRLOOP
;************************************************
;VALORES PARA MOSTRAR EN PANTALLA, EN EL
;PROCESO DE GRABACION
;************************************************
ESRETURN
	.SB +128," RETURN "
	.SB " PARA GRABAR"
ESSTART
	.SB +128," START "
	.SB " OTRA COPIA"
ESGRABANDO
	.SB "GRABANDO CASETTE ..."
ESCASETTE
	.SB "CARGANDO CASETTE ..."
;************************************************
;FUNCIONES PARA MOSTRAR EN PANTALLA EN EL CAMPO
;FUENTE, DONDE AVISAMOS LA ACCION QUE SE ESTA
;REALIZANDO EN ESE MOMENTO 
;************************************************
VEOGRABANDO
	JSR LIMPIOFUENTE
	LDX #19
VEOGRABANDO1
	LDA ESGRABANDO,X
	STA FUENTE,X
	DEX
	BPL VEOGRABANDO1
	RTS
VEORETURN
	JSR LIMPIOFUENTE
	LDX #19
VEORETURN1
	LDA ESRETURN,X
	STA FUENTE,X
	DEX
	BPL VEORETURN1	
	RTS
VEOSTART
	JSR LIMPIOFUENTE
	LDX #17
VEOSTART1
	LDA ESSTART,X
	STA FUENTE,X
	DEX
	BPL VEOSTART1
	RTS
VEOCASETTE
	JSR LIMPIOFUENTE
	LDX #19
VEOCASETTE1
	LDA ESCASETTE,X
	STA FUENTE,X
	DEX
	BPL VEOCASETTE1
	RTS
;************************************************
;FUNCION QUE NOS MUESTRA EN PANTALLA EL VALOR
;DE PORTB ($D301 )ALOJADO EN MEMORIA
;************************************************
ESPORTB
	JSR LIMPIOVAL
	LDA PORTB
	STA VAL
	JSR BIN2BCD
	LDX #7
	LDY #2
ESPORTB1
	LDA RESATASCII,X
	STA MUESTROPORTB,Y
	DEX
	DEY
	BPL ESPORTB1
	RTS
;************************************************
;LIMPIEZA GENERAL DE VALORES Y SEGMENTOS
;************************************************
;
;
;************************************************
;LIMPIO SEGMENTO BANQUEO DONDE MOSTRARE LOS BYTES
;QUE SE VAN GRABANDO EN LA DATA
;************************************************
LIMPIOBANQUEO
	LDX #0
	LDA #$00
LIMPIOBANQUEO1
	STA BANQUEO,X
	CPX #$FF
	BEQ LIMPIOBANQUEO2
	INX
	JMP LIMPIOBANQUEO1
LIMPIOBANQUEO2
	LDX #0
LIMPIOBANQUEO3
	STA BANQUEO+255,X
	CPX #$18
	BEQ FINLIMPIOBANQUEO
	INX
	JMP LIMPIOBANQUEO3
FINLIMPIOBANQUEO
	RTS
;************************************************
;LIMPIO SEGMENTO FUENTE DONDE MOSTRAREMOS A 
;POSTERIOR LOS MENSAJES DE PROCESO
;************************************************
LIMPIOFUENTE
	LDX #19
	LDA #$00
LIMPIOFUENTE1
	STA FUENTE,X
	DEX
	BPL LIMPIOFUENTE1
	RTS
;************************************************
;LIMPIO BLOCK, DONDE SE ALOJAN LOS BYTES PARA
;REALIZAR EL CONTEO DE BLOQUES EN DESENSO
;************************************************
LIMPIOBLOCK
	LDX #0
	STX BLOCK
	STX BLOCK+1
	RTS
;************************************************
;LIMPIO RY, QUE SE OCUPA PARA REALZIAR VARIAS
;FUNCIONES DENTRO DEL CODIGO
;************************************************
LIMPIORY
	LDA #$00
	STA RY
	STA RY+1
	STA RY+2
	RTS
;************************************************
;FUNCION QUE NOS PERMITE PODER REALIZAR UNA
;LIMPIEZA GENERAL DE TODOS LOS VALORES DEL
;PROGRAMA
;************************************************
RESTORE
	LDY #19
?RESTORE
	LDA #$20
	STA ??FUENTE,Y
	LDA #$00
	STA NME,Y
	STA NME2,Y
	STA FUENTE,Y
	STA TITLO,Y
	STA TITLOP7,Y
	STA TITLO2P7,Y
	STA TITULO01,Y
	STA TITULO02,Y
	DEY
	BPL ?RESTORE
	JSR LIMPIOFUENTE
	LDA #63
	STA TITULO01
	STA TITULO02
	STA FUENTE
	LDA #$00
	STA PFIN
	STA PFIN+1
	LDA #$10
	LDY #$05
RESNUM
	STA BYTES,Y
	STA BAKBYT,Y
	DEY
	BPL RESNUM
	STA BLOQUES
	STA BBLQS
	STA BLQ
	STA BLOQUES+1
	STA BBLQS+1
	STA BLQ+1
	STA BLOQUES+2
	STA BBLQS+2
	STA BLQ+2
	JSR LIMPIOBANQUEO
	JSR LIMPIOVAL
	JSR MEMORIA
	JSR LIMPIOBLOCK
	LDA BANKOS
	STA VAL
	JSR BIN2BCD
	LDA RESATASCII+7
	STA MUESTROBANCOS+1
	LDA RESATASCII+6
	STA MUESTROBANCOS
	JSR LIMPIOVAL
	LDA MEMORY
	STA VAL
	LDA MEMORY+1
	STA VAL+1
	LDA MEMORY+2
	STA VAL+2
	JSR BIN2BCD
	LDX #7
	LDY #5
RESMEMO
	LDA RESATASCII,X
	STA MUESTROMEMORIA,Y
	DEX
	DEY
	BPL RESMEMO
	LDX #$FF
	STX $D301
	JSR ESPORTB
	RTS
SETCOPIAS
	JSR OPENK
?SETCOPIAS
	LDX #<?COPIAS
	LDY #>?COPIAS
	LDA #$10
	STX $0228
	STY $0229
	STA $021A
	LDX #$10
	JSR $E456
	PHA
	LDA #$00
	STA $021A
	LDA TOTALCOPIAS
	AND #$7F
	STA TOTALCOPIAS
	PLA
	CMP #$2D
	BEQ MCOPIAS
	CMP #$3D
	BEQ ?MCOPIAS
	CMP #$9B
	BNE ?SETCOPIAS
	JMP CLOSE
MCOPIAS
	LDA TOTALCOPIAS
	CMP #$19
	BEQ ?SETCOPIAS
	INC TOTALCOPIAS
	BNE ?SETCOPIAS
?MCOPIAS
	LDA TOTALCOPIAS
	CMP #$10
	BEQ ?SETCOPIAS
	DEC TOTALCOPIAS
	BNE ?SETCOPIAS
?COPIAS
	LDA TOTALCOPIAS
	EOR #$80
	STA TOTALCOPIAS
	LDA #$10
	STA $021A
	RTS
;************************************************
;FUNCION QUE NOS PERMITE PODER CONVERTIR UN BYTE
;EN ATASCII, USADO PARA INGRESO DE TITULOS Y
;FUENTE, NO TIENE LIMITACIONES MAYORES EN LAS
;PULSACIONES DEL TECLADO
;************************************************
ASCINT
	CMP #32
	BCC ADD64
	CMP #96
	BCC SUB32
	CMP #128
	BCC REMAIN
	CMP #160
	BCC ADD64
	CMP #224
	BCC SUB32
	BCS REMAIN
ADD64
	CLC
	ADC #64
	BCC REMAIN
SUB32
	SEC
	SBC #32
REMAIN
	RTS
;************************************************
;GENERA UNA LIMPIEZA TOTAL DEL DISPLAY DEL
;DIRECTORIO
;************************************************
CLS
	LDX # <??DIR
	LDY # >??DIR
	STX PCRSR
	STY PCRSR+1
	LDY #$00
	LDX #$00
?CLS
	LDA #$00
	STA (PCRSR),Y
	INY
	BNE ??CLS
	INX
	INC PCRSR+1
??CLS
	CPY #104	;$68
	BNE ?CLS
	CPX #$01
	BNE ?CLS
	RTS
;************************************************
;FUNCION QUE ABRE PERIFERICOS
;************************************************
OPEN
	LDX #$10
	LDA #$03
	STA $0342,X
	LDA # <??FUENTE
	STA $0344,X
	LDA # >??FUENTE
	STA $0345,X
	LDA #$04
	STA $034A,X
	LDA #$80
	STA $034B,X
	JSR $E456
	DEY
	BNE DIR
	RTS
;************************************************
;FUNCION QUE CIERRA PERIFERICOS
;************************************************
CLOSE
	LDX #$10
	LDA #$0C
	STA $0342,X
	JMP $E456
;************************************************
;MUESTRA EL DIRECTORIO EN PANTALLA
;************************************************
DIR
	JSR CLOSE
	JSR CLS
	LDX # <?DIR
	LDY # >?DIR
	STX $0230
	STY $0231
	LDX # <??DIR
	LDY # >??DIR
	STX PCRSR
	STY PCRSR+1
	LDX #$10
	LDA #$03
	STA $0342,X
	LDA # <ALL
	STA $0344,X
	LDA # >ALL
	STA $0345,X
	LDA #$06
	STA $034A,X
	LDA #$00
	STA $034B,X
	JSR $E456
	LDA #$07
	STA $0342,X
	LDA #$00
	STA $0348,X
	STA $0349,X
	STA RY
	STA RY+1
LEDIR
	JSR $E456
	BMI ?EXIT
	CMP #155
	BEQ EXIT
	JSR ASCINT
	LDY RY
	STA (PCRSR),Y
	INC RY
	BNE F0
	INC PCRSR+1
	INC RY+1
F0
	LDY RY+1
	CPY #$01
	BNE F1
	LDY RY
	CPY #104	;$68
	BCC F1
	JSR PAUSE
	INC RY
F1
	JMP LEDIR
EXIT
	INC RY
	INC RY
	JMP LEDIR
?EXIT
	JSR CLOSE
	JSR PAUSE
	JSR CLS
	PLA
	PLA
	JMP START
PAUSE
	LDA 53279
	CMP #$06
	BNE PAUSE
	JSR CLS
	LDA #$00
	STA RY
	STA RY+1
	LDA # <??DIR
	STA PCRSR
	LDA # >??DIR
	STA PCRSR+1
	LDX #$10
	RTS
;************************************************
;RUTINA QUE NOS PERMMITE PODER INGRESAR INFORMA-
;CION A UN CAMPO ESPECIFICO YA ANTES DECLARADO
;MOSTRANDO UN CURSOR EN FORMA PARPADEANTE
;************************************************
;
;************************************************
;CURSOR PARPADEANTE
;************************************************
FLSH
	LDY RY
	LDA (PCRSR),Y
	EOR #63
	STA (PCRSR),Y
	LDA #$10
	STA $021A
	RTS
;************************************************
;ABRE PERIFERICO TECLADO
;************************************************
OPENK
	LDA #255
	STA 764
	LDX #$10
	LDA #$03
	STA $0342,X
	STA $0345,X
	LDA #$26
	STA $0344,X
	LDA #$04
	STA $034A,X
	JSR $E456
	LDA #$07
	STA $0342,X
	LDA #$00
	STA $0348,X
	STA $0349,X
	STA RY
	RTS
;************************************************
;RUTINA QUE LEE LO TECLEADO
;************************************************
RUTLEE
	LDX # <FLSH
	LDY # >FLSH
	LDA #$10
	STX $0228
	STY $0229
	STA $021A
	JSR OPENK
GETEC
	JSR $E456
	CMP #$7E
	BNE C0
	LDY RY
	BEQ GETEC
	LDA #$00
	STA (PCRSR),Y
	LDA #63		;$3F
	DEY
	STA (PCRSR),Y
	DEC RY
	JMP GETEC
C0
	CMP #155	;$9B
	BEQ C2
	JSR ASCINT
	LDY RY
	STA (PCRSR),Y
	CPY #20		;#14
	BEQ C1
	INC RY
C1
	JMP GETEC
C2
	JSR CLOSE
	LDA #$00
	STA $021A
	LDY RY
	STA (PCRSR),Y
	RTS
;************************************************
;FUNCION QUE PERMITE PODER REALIZAR CAMBIOS
;DE BANCOS DE MEMORIA EN UNA CARGA
;************************************************
CAMBIOBANCO
	LDX BANCA
	LDA B,X
	STA $D301
	STA BANCA+1
	CPX BANKOS
	BEQ ERRORBANQUEO
	INX
	STX BANCA
	RTS
;************************************************
;EN CASO QUE SOBREPASE LA CANTIDAD DE BANCOS
;ENCONTRADOS NOS REDIRECCIONA A MOSTRAR EL
;DIRECTORIO EN PANTALLA
;************************************************
ERRORBANQUEO
	JMP DIR
;************************************************
;FUNCION QUE NOS PERMITE PODER REALIZAR CARGA
;DE DATOS EN MEMORIA
;************************************************
FGET
	LDA #$00
	STA LEN
	STA LEN+1
	STA LEN+2
	STA BANCA
	STA BANCA+1
LOPFGET
	JSR CAMBIOBANCO	;REALIZO CAMBIO DE BANCO
	JSR ESPORTB		;MUESTRO EL PORTB EN PANTALLA
	LDX #$10
	LDA #$07
	STA $0342,X
	LDA # <BAFER	;SE CARGA EN $4000
	STA $0344,X
	LDA # >BAFER
	STA $0345,X
	LDA # <LENGHT	;CANTIDAD DE BYTES QUE SE CARGAN
	STA $0348,X
	LDA # >LENGHT
	STA $0349,X
??FGET
	JSR $E456
;************************************************
;REALIZO SUMA DE BYTES POR BANCO Y LO GUARDO EN
;LA VARIABLE VOLATIL LEN
;************************************************
	CLC
	LDA LEN
	ADC $0348,X
	STA LEN
	LDA LEN+1
	ADC $0349,X
	STA LEN+1
	LDA LEN+2
	ADC #$00
	STA LEN+2
	LDA $0349,X
	CMP # >LENGHT
	BEQ LOPFGET
	CPY #136	;$88
	BEQ ?FGET
	JSR CLOSE
	JSR CLS
	LDX #$00
	TXS
	JMP START
?FGET
	JSR LIMPIOVAL
	JSR LIMPIORY
	JSR PONBYTES
	JSR PONBLOQUES
;	SEC
;	LDA LEN
;	SBC RY
;	STA CONT+1
	INC CONT+1
	LDX #$10
	RTS
;************************************************
;REALIZO EL CALCULO DE BYTES LEIDOS Y LOS MUESTRO
;EN PANTALLA
;************************************************
PONBYTES
	JSR LIMPIOVAL
	LDA LEN
	STA VAL
	LDA LEN+1
	STA VAL+1
	LDA LEN+2
	STA VAL+2
	JSR BIN2BCD
	LDX #7
	LDY #5
PONBYTES1
	LDA RESATASCII,X
	STA BYTES,Y
	DEX
	DEY
	BPL PONBYTES1
	RTS
;************************************************
;REALIZO EL CALCULO DE BLOQUES SEGUN BYTES LEIDOS
;LOS BLOQUES ESTAN COMPUESTO POR 252 BYTES
;************************************************
PONBLOQUES
	JSR LIMPIORY
	JSR LIMPIOBLOCK
	CLC
	LDA LEN
	STA RY
	LDA LEN+1
	STA RY+1
	LDA LEN+2
	STA RY+2
PONBLOQUES1
;RESTO BYTES
	SEC
	LDA RY
	SBC #252
	STA RY
	STA CONT+1	;se agrega para obtener la
				;ultima cantida de bytes restantes
	LDA RY+1
	SBC #0
	STA RY+1
	
	LDA RY+2
	SBC #0
	STA RY+2
;SUMO BLOKES
	CLC
	LDA BLOCK
	ADC #$01
	STA BLOCK
	LDA BLOCK+1
	ADC #$00
	STA BLOCK+1
;
	LDA RY+2
	CMP #$00
	BNE PONBLOQUES1
	LDA RY+1
	CMP #$00
	BNE PONBLOQUES1
	CLC
	LDA BLOCK
	ADC #$01
	STA BLOCK
	LDA BLOCK+1
	ADC #$00
	STA BLOCK+1
	JSR LIMPIOVAL
	LDA BLOCK
	STA VAL
	LDA BLOCK+1
	STA VAL+1
	JSR BIN2BCD
	LDX #7
	LDY #2
PONBLOQUES2
	LDA RESATASCII,X
	STA BLOQUES,Y
	STA BLQ,Y
	STA BAKBLQ,Y
	DEX
	DEY
	BPL PONBLOQUES2
	RTS
;************************************************
;FUNCION QUE NOS PERMITE ABRIR EL PERIFERICO
;CASETERA ESPERANDO QUE SE PRESIONE RETURN
;************************************************
OPENC
	LDA $D40B
    BNE OPENC
    LDA #$FE
    STA $d301		;$02FC
	jsr preinj
	jmp ?piratas
;************************************************
;COLOCAMOS LOS DATOS EN LAS VARIABLES
;************************************************
PONDATA
	LDA BLOQUES
	STA BLQ
	LDA BLOQUES+1
	STA BLQ+1
	LDA BLOQUES+2
	STA BLQ+2
	LDX #19
?PONDATA
	LDA SHOW,X
	STA TITLO,X
	STA TITLOP7,X
	DEX
	BPL ?PONDATA
	RTS
;************************************************
;FUNCION QUE INICIA EL SIOV PARA GRABAR DATA EN
;LA CINTA
;************************************************
INITSIOV
	LDY #$0B
?INITSIOV
	LDA DNHP,Y
	STA $0300,Y
	DEY
	BPL ?INITSIOV
	LDA #$00
	STA 77		;$4D
	RTS
SAVESIO
	LDX #$0B
?SAVESIO
	LDA ESIO,X
	STA $0300,X
	DEX
	BPL ?SAVESIO
	JMP $E459
ESIO
	.BYTE $60,$00,$52,$80
	.WORD ESPSIO
	.BYTE $23,$00
	.WORD 27
	.BYTE $00,$80
DNHP
	.BYTE $60,$00,$52,$80
	.WORD BANQUEO
	.BYTE $35,$00
	.WORD $0100
	.BYTE $00,$80
MODIFICOROM
	;46
	.BYTE $12,$B6,$C1,$B9,$B6,$B3
	.BYTE $C4,$BD,$12,$12,$45,$41
	.BYTE $38,$46,$49,$33,$44,$37
	.BYTE $45,$12
;************************************************
;GRABA LOS 3 PRIMEROS BLOQUES EN LA CINTA
;************************************************
AUTORUN
	LDX # <PAG7
	LDY # >PAG7
	LDA #$02	;02 graba 3 bloques en cinta
	STX MVPG7+1
	STY MVPG7+2
	STA @BL4
FALTA
	JSR INITSIOV
	LDX #<??DIR
	LDY #>??DIR
	STX $0304
	STY $0305
	LDX #131	; $83
	LDY #$00	; $00
	STX $0308
	STY $0309
	LDY #$00
	TYA
CLBUF
	STA ??DIR,Y
	INY
	CPY #131	;$83
	BNE CLBUF
	LDA #$55
	STA ??DIR
	STA ??DIR+1
	LDX #$FC
	LDY #127	;$7F
	DEC @BL4
	BPL NOFIN
	LDX #$FA
	LDY #LAST
	STY ??DIR+130
NOFIN
	STX ??DIR+2
MVPG7
	LDA PAG7,Y
	STA ??DIR+3,Y
	DEY
	BPL MVPG7
	JSR $E459
	ldx #$10
    ldy #$00
    jsr time
	CLC
	LDA MVPG7+1
	ADC #$80
	STA MVPG7+1
	LDA MVPG7+2
	ADC #$00
	STA MVPG7+2
	LDA @BL4
	BPL FALTA
	RTS
;************************************************
;INICIO DE GRABACION EN CINTA
;************************************************
GAUTO
;	LDA $D20A
;	STA GENDAT
;	STA @GENDAT
;	LDA #$FF
;	STA $D301
 	JSR AUTORUN	;LLAMA A LOS 3 PRIMEROS BLOQUES
	JSR INITSIOV	;
	LDX # <131		;GRABA EL 4 BLOQUE CON LA INFORMACION
	LDY # >131		;QUE CARGARA EL LOADER 
	STX $0308
	STY $0309
	LDX # <PAG4
	LDY # >PAG4
	STX $0304
	STY $0305
	JSR $E459
	jsr injektor
	JSR INITSIOV
;	LDX #$f0
;    ldy #$00
;    jsr time
	LDX # <LLOAD	;GRABAMOS EL LOADER EN PANTALLA
	LDY # >LLOAD
	STX $0308
	STY $0309
	LDX # <LOAD
	LDY # >LOAD
	STX $0304
	STY $0305
	JSR $E459
	ldx #$10
    ldy #$00
    jsr time
	JSR SAVESIO		;ENVIAMOS EL TITULO Y LOS BYTES A CINTA
	ldx #$10
    ldy #$00
    jsr time
	RTS
time
	stx $021c
	sty $021d
?time
	lda $021c
	ora $021d
	bne ?time
	rts
;************************************************
;RESTAURAMOS BLOQUES Y BYTES EN PANTALLA
;************************************************
REST
	LDY #$05
??REST
	LDA BYTES,Y
	STA BAKBYT,Y
	DEY
	BPL ??REST
	LDY #$02
???REST
	LDA BLOQUES,Y
	STA BAKBLQ,Y
	DEY
	BPL ???REST
	RTS
?REST
	LDY #$05
????REST
	LDA BAKBYT,Y
	STA BYTES,Y
	DEY
	BPL ????REST
	LDY #$02
?????REST
	LDA BAKBLQ,Y
	STA BLOQUES,Y
	DEY
	BPL ?????REST
	LDA BLOCK+1
	STA PFIN+1
	LDA BLOCK	;$FC
	STA CONT
	STA PFIN
	RTS
EXNHPUT
;	LDA #$80	elimino bloqueo
;	STA 77		de pantalla
	PLA
	PLA
	PLA
	PLA
	RTS
;************************************************
;1ER 2DO  ID DATA	ULTIMO
;$55 $55 $ID $00-$00 $FF
;GRABACION DE DATA EN LA CINTA
;ESTRUCTURA
;DOS PRIMERO BYTES EN $55
;TERCER BYTE ID
;4 BYTE EN ADELANTE DATA DEL JUEGO, SON 252 BYTES
;ULTIMO BYTE $FF
;************************************************
NHPUT
	LDA #0
	STA BANCA
	STA BANCA+1
	JSR CAMBIOBANCO
	JSR ESPORTB
	LDA #$55		;agrego los 2 primeros bytes
	STA BANQUEO
	STA BANQUEO+1
;	LDA #252	;$FC - agrego el ultimo byte
;	STA BANQUEO+255
	lda #$de
	sta $d301
	LDX # <BAFER
	LDY # >BAFER
	STX M+1
	STY M+2
	LDX #$00
	LDY #$00
	STY $02E2
	JSR GRABACION
	JMP ?MVBF

GRABACION
;CARGO VALOR DE PORTB A USAR
	LDA BANCA+1
	STA $D301
	LDA #$FC
	STA BANQUEO+255
;FORZAMOS EL ULTIMO BYTE A 252
	LDA PFIN
	STA BANQUEO+2
	CMP #$00
	BEQ GRABUNO
;
	CMP #$01
	BNE RETURN
	LDA PFIN+1
	CMP #$00
	BNE RETURN
	LDA CONT+1
	STA BANQUEO+255
RETURN
	RTS
GRABUNO
	LDA PFIN+1
	CMP #$00
	BEQ EXNHPUT
	DEC PFIN+1
	JMP RETURN
	
;GRABACION
	;LDA BANCA+1		;cargo el valor rescatado
;	STA $D301		;en portb
;FORZAMOS EL ULTIMO BYTE A 252
;	LDA #$FC
;	STA BANQUEO+255
;COMENZAMOS CON LAS VALIDACIONES
;GRABACION2	
;SI PFIN+1 NO SE ENCUENTRA EN 0 LO
;REDIRECCIONAMOS A GRABACION3
;	LDA PFIN		;comparamos si pfin
;	STA BANQUEO+2	;lo guardo en banqueo como id contador
;	CMP PFIN+1		;es igual a pfin+1
;	BNE GRABACION3	;si es diferente redireccionamos	
;	BEQ EXNHPUT		;si ambos son 0 terminamos
;GRABACION3
;VALIDO EL ULTIMO BYTE SI SERA 252 O
;LO QUE RESTA EN BYTES PARA LA CARGA
;	CMP $01
;	BNE RETURN		;DIFERENTE
;GRABACION4
;	LDA PFIN+1
;	CMP #$00
;	BEQ GRABACION5	;ES DIFERENTE
;	DEC PFIN+1
;	JMP RETURN
;GRABACION5
;agregamos el ultimo byte diferente
;	LDA CONT+1
;	STA BANQUEO+255
;RETURN
;	RTS


;funci�n agrega bytes a bloques
?MVBF
	JSR GBYTE
	STA STARTF
	JSR GBYTE
	STA STARTF+1
	AND STARTF
	CMP #$FF
	BEQ ?MVBF
	JSR GBYTE
	STA FINISH
	JSR GBYTE
	STA FINISH+1
NHLOP
	JSR GBYTE
	LDA STARTF
	CMP #$E3
	BNE ?NHLOP
	LDA STARTF+1
	CMP #$02
	BNE ?NHLOP
	STA $02E2
?NHLOP
	LDA STARTF
	CMP FINISH
	BNE NHCONT
	LDA STARTF+1
	CMP FINISH+1
	BEQ ?MVBF
NHCONT
	INC STARTF
	BNE NOHI
	INC STARTF+1
NOHI
	JMP NHLOP
GBYTE
	CPY BANQUEO+255
	BEQ EGRAB
M
	LDA BAFER,X
;	EOR BAFER,X
;	EOR GENDAT
	STA BANQUEO+3,Y
;	TYA
;	EOR BANQUEO+3,Y
;	EOR GENDAT
	INC GENDAT
	INY
	INX
	BNE EXNHPIT
	INC M+2
	BPL EXNHPIT
	PHA
	CLC
	STA MOM
	STX MOM+1
	STY MOM+2
	JSR CAMBIOBANCO
	JSR ESPORTB
	LDA MOM
	LDX MOM+1
	LDY MOM+2
	LDA # >BAFER
	STA M+2
	PLA
EXNHPIT
	RTS
EGRAB
	DEC PFIN
	TXA
	PHA
	JSR INITSIOV		;grabo el bloke cargada a casette
	JSR $E459
	LDX #$10
    ldy #$00
    jsr time
	LDX #$02
;proceso contador
;que aparece en pantalla
;en uno
DECBL01					
	LDA BLOQUES,X		
	CMP #$10			
	BNE DECBL02
	LDA #$19
	STA BLOQUES,X
	DEX
	BPL DECBL01
DECBL02
	DEC BLOQUES,X
	PLA
	TAX
	LDA $02E2
	BNE SLOWB
SIGUE
	JSR GRABACION
	LDY #$00
	JMP GBYTE
SLOWB
	TXA
	PHA	
	LDX # <350	;$015e
	LDY # >350
	STX $021C
	STY $021D
IRG
	LDA $021D
	BNE IRG
	LDA $021C
	BNE IRG
	LDA #$00
	STA $02E2
	PLA
	TAX
	JMP SIGUE
;************************************************
;DISPLAY DE INICIO DEL PROGRAMA Y FUNCIONALIDAD
;DIRECTA A TODAS SUS FUNCIONES
;************************************************
DOS
	JMP ($0C)
@START
	JSR DOS
START
	LDX # <DLS
	LDY # >DLS
	STX $0230
	STY $0231
	LDA #$02
	STA 710
	STA 712

	JSR ROMCEANDO
	JSR PIRATEO
	JSR RESTORE
;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <TITULO01
	LDY # >TITULO01
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
;************************************************
;VALIDO SI HAY CAMBIO DE SISTEMA
;************************************************
	TYA
	BEQ NOTITLE
	LSR 
	STA RY+1
	LDA #10
	SEC
	SBC RY+1
	STA RY+1
	LDX #$00
	LDY RY+1
WRITE
;************************************************
;AGREGO EL TITULO 01 AL LOADER
;************************************************
	LDA TITULO01,X
	STA NME2,Y
	INY
	INX
	CPX RY
	BNE WRITE
NOTITLE
;************************************************
;INGRESO TITULO 02
;************************************************
	LDX # <TITULO02
	LDY # >TITULO02
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
	TYA
	BEQ NOTITLE2
	LSR 
	STA RY+1
	LDA #10
	SEC
	SBC RY+1
	STA RY+1
	LDX #$00
	LDY RY+1
WRITE2
;************************************************
;AGREGO EL TITULO02 AL LOADER
;************************************************
	LDA TITULO02,X
	STA NME,Y
	STA TITLO2P7,Y
	INY
	INX
	CPX RY
	BNE WRITE2
NOTITLE2
;************************************************
;INGRESO FUENTE
;************************************************
	LDX # <FUENTE
	LDY # >FUENTE
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
	LDY #19
CONV
	LDA FUENTE,Y
	BEQ ?REMAIN
	AND #$7F
	CMP #64
	BCC ADD32
	CMP #96
	BCC SUB64
	BCS ?REMAIN
ADD32
	CLC
	ADC #32
	BCC OKLET
SUB64
	SEC
	SBC #64
?REMAIN
	LDA #$9B
OKLET
	STA ??FUENTE,Y
	DEY
	BPL CONV
;************************************************
;ABRO PERIFERICO
;************************************************
	JSR OPEN
;************************************************
;CARGO DATA A MEMORIA
;************************************************
	JSR FGET
;************************************************
;CIERRO PERIFERICO
;************************************************
	JSR CLOSE
;************************************************
;COLOCO LA DATA 
;************************************************
	JSR PONDATA
	JSR REST
OTRACOPIA
	JSR SETCOPIAS
	JSR ?REST
;	JSR VEORETURN	;MUESTRO RETURN EN PANTALLA
	JSR OPENC	;ABRO CASETTE PARA GRABAR
	JSR VEOGRABANDO	;MUESTRO MENSAJE GRABANDO	
	JSR GAUTO		;GRABO LOS 4 PRIMEROS BLOQUES
?OTRACOPIA
	JSR ?REST
	JSR NHPUT		;GRABO LA DATA DEL JUEGO EN BLOQUES
	JSR LIMPIOBANQUEO
	LDX #$fe
    LDY #$80
    stx $13
    sty $14
??otracopia
	lda $13
	ora $14
	bne ??otracopia
	lda totalcopias
	and #$0f
	beq ???otracopia
	dec totalcopias
	bpl ?OTRACOPIA
???otracopia   
	ldx #$3c
	ldy #$80
	lda #$03
	sta $d20f
	stx $d302
	JSR VEOSTART	;MUESTRO OTRA COPIA
WAIT
	lda #$00
	sta $4d
	LDA 53279		;VALIDO START
	CMP #$07
	BEQ WAIT
	CMP #$06
	BEQ OTRACOPIA	;SI ES START ENVIO A OTRA COPIA
	CMP #$03
	BNE WAIT
	JMP START		;SI NO ES START REINICIO PROGRAMA
INICIO
	JSR CLOSE
	JSR kKEM			;COPIO LA ROM A LA RAM
	jsr ?piratas
	jmp start
?piratas
	LDX # <@START
	LDY # >@START
	LDA #$03
	STX $02
	STY $03
	STA $09
	LDY #$FF
	STY $08
	INY   
	STY $0244
	rts
	RUN INICIO
