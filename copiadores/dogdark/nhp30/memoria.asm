TABMEMBANKS	= $600
BANKOS
    .BYTE $00
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
    .BYTE $00,$00,$00
MEM
    LDA #$00
    STA MEMORIA
    STA MEMORIA+1
    STA MEMORIA+2
;byte de la memoria primaria
	LDA $7FFF	
	STA TEMPMEM
    LDX #MAXBANKS-1
S1MEM 
    LDA DBANK,X
    STA $D301 ;PORTB
    LDA $7FFF
    STA TABMEMBANKS,X
    DEX
    BPL S1MEM
    LDX #MAXBANKS-1
S2MEM
    LDA DBANK,X
    STA $D301 ;PORTB
    STA $7FFF
    DEX
    BPL S2MEM
;volvemos a la memoria basica,
;aqui debajo de $7FFF
;escribimos el valor $FF
	LDA #$FF
	STA $D301 ;PORTB
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
LOPMEM
    LDA DBANK,X
    STA $D301 ;PORTB
    CMP $7FFF
    BNE SKPMEM
	STA TABMEMBANKS+1,Y
    INY
    STY BANKOS
SKPMEM
    DEX
    BPL LOPMEM
    LDX #MAXBANKS-1
R3MEM 
    LDA DBANK,X
    STA $D301 ;PORTB
    LDA TABMEMBANKS,X
    STA $7FFF
    DEX
    BPL R3MEM
;Terminamos restaurando la 
;memoria primaria.
    LDA #$FF
    STA $D301 ;PORTB
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
TEMPMEM
    .BYTE $00
DBANK
	.BYTE $E3,$C3,$A3,$83,$63,$43,$23,$03
    .BYTE $E7,$C7,$A7,$87,$67,$47,$27,$07
    .BYTE $EB,$CB,$AB,$8B,$6B,$4B,$2B,$0B
    .BYTE $EF,$CF,$AF,$8F,$6F,$4F,$2F,$0F
    .BYTE $ED,$CD,$AD,$8D,$6D,$4D,$2D,$0D
    .BYTE $E9,$C9,$A9,$89,$69,$49,$29,$09
    .BYTE $E5,$C5,$A5,$85,$65,$45,$25,$05
    .BYTE $E1,$C1,$A1,$81,$61,$41,$21,$01
