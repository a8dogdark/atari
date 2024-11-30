;FUNCIONES DEL SISTEMA
;
; COPIA LA ROM A LA RAM
;
KEMBUFFERROMRAM =$B000
ROMRAM
	LDY #$00
KEMLOOP1ROMRAM
	LDA $E000,Y
	STA KEMBUFFERROMRAM,Y
	LDA $E100,Y
	STA KEMBUFFERROMRAM+$100,Y
	LDA $E200,Y
	STA KEMBUFFERROMRAM+$200,Y
	LDA $E300,Y
	STA KEMBUFFERROMRAM+$300,Y
	INY
	BNE KEMLOOP1ROMRAM
	LDA #>KEMBUFFERROMRAM
	STA CHBAS
	STA CHBASE
	LDX #$C0
	SEI
	STY $D40E
	STX $CC
	STY $CB
LOOPROMRAM
	LDA ($CB),Y
	DEC $D301
	STA ($CB),Y
	INC $D301
	INY
	BNE LOOPROMRAM
	INC $CC
	BEQ @EXITROMRAM
	LDA $CC
	CMP #$D0
	BNE LOOPROMRAM
	LDA #$D8
	STA $CC
	BNE LOOPROMRAM
@EXITROMRAM
	LDA #$E0
	STA CHBAS
	STA CHBASE
	TYA	//y está en cero, según el código de arriba
KEMLOOP2ROMRAM
	STA KEMBUFFERROMRAM,Y
	STA KEMBUFFERROMRAM+$100,Y
	STA KEMBUFFERROMRAM+$200,Y
	STA KEMBUFFERROMRAM+$300,Y
	INY
	BNE KEMLOOP2ROMRAM
	DEC $D301
	LDX #$01
	LDY #$4C
	LDA #$13
	STX $EE17
	STY $ED8F
	STA $ED67
	LDX #$80
	LDY #$03
	STX $EBA3
	STY $EBA8
	LDY #$04
	LDA #$EA
NOPROMRAM
	STA $ED85,Y
	DEY
	BPL NOPROMRAM
	LDY #STACFROMRAM-STACIROMRAM
MOVEROMRAM
	LDA STACIROMRAM,Y
	STA $ECEF,Y
	DEY
	BPL MOVEROMRAM
	LDA #$40
	STA NMIEN
	CLI
	CLC
	RTS
STACIROMRAM
	LDA #$7D
	LDX $62
	BEQ CC0ROMRAM
	LDA #$64
CC0ROMRAM
	CLC
	ADC $EE19,X
	DEY
	BPL CC0ROMRAM
	CLC
	ADC $0312
	SEC
	SBC #$64
	BCC CC3ROMRAM
	STA $0312
	LDY #$02
	LDX #$06
	LDA #$4F
CC2ROMRAM
	ADC $0312
	BCC CC1ROMRAM
	INY
	CLC
CC1ROMRAM
	DEX
	BNE CC2ROMRAM
	STA $02EE
	STY $02EF
	JMP $ED96
CC3ROMRAM
	JMP $ED3D
STACFROMRAM


;MEMORIA EXPANSIVA
TABMEMBANKS = $600
BANKOS
    .BY $00
RY
    .BY $00,$00,$00
LEN
    .BY $00,$00,$00
PCRSR   = $CB
;Deteccion de memoria adicional
;El programa verifica la 
;presencia de una extension
;de memoria basandose en los 
;codigos de banco dBANK 
;permitidos y guarda los bancos
;encontrados desde la direccion
;TABMEMBANKS+1.
;El metodo de prueba excluye la 
;posibilidad de duplicar 
;cualquier banco de memoria
;adicional.
;La primera entrada en la tabla
;TABMEMBANKS es el valor 
;$FF, este es el codigo del
;banco numero 0 en la memoria
;primaria.
;La tabla con los bancos de
;memoria encontrados puede
;contener como maximo 65
;entradas.
;(para 1 MB de memoria 
;adicional).
;El numero de bancos 
;encontrados se devuelve en
;el registro del acumulador
;A.
;numero maximo de bancos de
;memoria
MAXBANKS = 64		
MEMORIA
    .BY $00,$00,$00
MEM
    LDA #$00
    STA MEMORIA
    STA MEMORIA+1
    STA MEMORIA+2
;byte de la memoria primaria
	LDA $7FFF	
	STA TEMP
    LDX #MAXBANKS-1
S1 
    LDA DBANK,X
    STA PORTB
    LDA $7FFF
    STA TABMEMBANKS,X
    DEX
    BPL S1
    LDX #MAXBANKS-1
S2 
    LDA DBANK,X
    STA PORTB
    STA $7FFF
    DEX
    BPL S2
;volvemos a la memoria basica,
;aqui debajo de $7FFF
;escribimos el valor $FF
	LDA #$FF
	STA PORTB
	STA $7FFF
	STA TABMEMBANKS ; primera
;entrada en TABMEMBANKS = $FF
;comprobamos la presencia de
;bancos de memoria adicionales,
;guardamos los bancos detectados
;desde la direccion 
;TABMEMBANKS+1 el registro
;Y cuenta los bancos de memoria
;encontrados
	LDY #0
    LDX #MAXBANKS-1
LOP	
    LDA DBANK,X
    STA PORTB
    CMP $7FFF
    BNE SKP
	STA TABMEMBANKS+1,Y
    INY
    STY BANKOS
SKP
    DEX
    BPL LOP
    LDX #MAXBANKS-1
R3 
    LDA DBANK,X
    STA PORTB
    LDA TABMEMBANKS,X
    STA $7FFF
    DEX
    BPL R3
;Terminamos restaurando la 
;memoria primaria.
    LDA #$FF
    STA PORTB
;Restauramos el contenido 
	LDA #0		
;antiguo de la celda de memoria
;desde la direccion $7FFF en la
;memoria primaria.
	STA $7FFF
;en regla el numero de bancos 
;de memoria adicionales
;encontrados
	TYA		
    LDX BANKOS
    DEX
CALMEM
    LDA MEMORIA
	ADC #$00
	STA MEMORIA
	LDA MEMORIA+1
	ADC #$40
	STA MEMORIA+1
	LDA MEMORIA+2
	ADC #$00
	STA MEMORIA+2
	DEX
    BPL CALMEM
    RTS
;La tabla DBANK contiene codigos
;permitidos para los bancos
;habilitados para PORTB
TEMP
    .BY $00
DBANK
	.BY $E3,$C3,$A3,$83,$63,$43,$23,$03
    .BY $E7,$C7,$A7,$87,$67,$47,$27,$07
    .BY $EB,$CB,$AB,$8B,$6B,$4B,$2B,$0B
    .BY $EF,$CF,$AF,$8F,$6F,$4F,$2F,$0F
    .BY $ED,$CD,$AD,$8D,$6D,$4D,$2D,$0D
    .BY $E9,$C9,$A9,$89,$69,$49,$29,$09
    .BY $E5,$C5,$A5,$85,$65,$45,$25,$05
    .BY $E1,$C1,$A1,$81,$61,$41,$21,$01

;CONVIERTE BYTES A ATASCII
RESATASCII
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
RESBCD
	.BYTE $00,$00,$00,$00
VAL	
	.BYTE $00,$00,$00
LIMPIORES
	LDX #7
	LDA #0
LIMPIORES01
	STA RESATASCII,X
	DEX
	BPL LIMPIORES01
	LDX #3
LIMPIORES02
	STA RESBCD,X
	STA HEXATASCII,X
	DEX
	BPL LIMPIORES02
	RTS
LIMPIOVAL
	LDX #2
	LDA #$00
LIMPIOVAL01
	STA VAL,X
	DEX
	BPL LIMPIOVAL01
	RTS
; Convert an 16 bit binary value into a 24bit BCD value
BIN2BCD
	JSR LIMPIORES
	LDA #0		  ;Clear the result area
	STA RESBCD+0
	STA RESBCD+1
	STA RESBCD+2
	STA RESBCD+3
	LDX #24		 ;Setup the bit counter
	SED			 ;Enter decimal mode
LOOPHEX
	ASL VAL+0	   ;Shift a bit out of the binary
	ROL VAL+1
	ROL VAL+2	   ;... value
	LDA RESBCD+0	   ;And add it into the result, doubling
	ADC RESBCD+0	   ;... it at the same time
	STA RESBCD+0
	LDA RESBCD+1
	ADC RESBCD+1
	STA RESBCD+1
	LDA RESBCD+2
	ADC RESBCD+2
	STA RESBCD+2
	LDA RESBCD+3
	ADC RESBCD+3
	STA RESBCD+3
	DEX			 ;More bits to process?
	BNE LOOPHEX
	CLD			 ;Leave decimal mode
	;BRK
BCD2ATASCII
	LDX #4
	LDY #0
LOOP2
	LDA RESBCD-1,X
	LSR
	LSR
	LSR
	LSR
	ORA #$10
	STA RESATASCII,Y
	LDA RESBCD-1,X
	AND #$0F
	ORA #$10
	STA RESATASCII+1,Y
	INY
	INY
	DEX
	BNE LOOP2
	RTS

HEXATASCII
	.BYTE $00,$00,$00,$00
;
BIN3BCD
	JSR LIMPIORES
	LDX #1	;X BYTES DE INDICE
	LDY #0
ROTATE
;OBTENEMOS EL NIBBLE ALTO
	LDA VAL,X
	LSR 
	LSR
	LSR
	LSR
;GUARDAMOS EL NIBLE ALTO
	STA HEXATASCII,Y
;AHORA OBTENEMOS EL NYBBLE BAJO
	LDA VAL,X
	AND #$0F	;NYBBLE BAJO
	INY
	STA HEXATASCII,Y
	INY
	DEX
	BPL ROTATE
	LDY #0
	LDX #3
BYTEHEX
	LDA HEXATASCII,Y
	CMP #$0A 
	BCC ADD48
	ADC #$06 ; "A-0"
ADD48
	ADC #$10
	STA HEXATASCII,Y
	INY
	DEX
	BPL BYTEHEX
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
NOGETEC
	JSR OPENK
GETEC
	JSR $E456
	CMP #$7E	
	BNE C0		;ES DIFERENTE A DELETE
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
	CMP #155	;$9B RETURN
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
FINRUTLEE
	RTS
;************************************************
;VALORES PRINCIPALES QUE REGULA LOS BAUDIOS
;CODIGO DONADO POR WILLYSOFT
;************************************************
B00600 	= $05CC		;TIMER  600 BPS
B00800 	= $0458  	;TIMER  800 BPS
B00990 	= $0380  	;TIMER  991 BPS
B01150 	= $0303  	;TIMER 1150 BPS
B01400	= $0278		;TIMER 1400 BPS
;************************************************
;************************************************
;FUNCION PARA REGULAR LA VELOCIDAD AL GRABAR
;************************************************
;
BAUD.600
	LDA # <B00600
	JSR BAUD.M1
	LDA # >B00600
	JMP BAUD.M2
BAUD.800
	LDA # <B00800
	JSR BAUD.M1
	LDA # >B00800
	JMP BAUD.M2
BAUD.990
	LDA # <B00990
	JSR BAUD.M1
	LDA # >B00990
	JMP BAUD.M2
BAUD.1150
	LDA # <B01150
	JSR BAUD.M1
	LDA # >B01150
	JMP BAUD.M2
BAUD.1400
	LDA # <B01400
	JSR BAUD.M1
	LDA # >B01400
BAUD.M2
	STA $EBA8
	STA $FD46
	STA $FCE1
	RTS
BAUD.M1
	STA $EBA3
	STA $FD41
	STA $FCDC
	RTS