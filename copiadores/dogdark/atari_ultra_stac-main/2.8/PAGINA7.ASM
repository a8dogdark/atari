//	icl "../base/sys_equates.m65"


l_pag7=[.len pagina7]

.proc pagina7,$2000
kem_buffer =$b000
INICIO 
	.BYTE $00
	.byte [l_pag7+127]/128
	.WORD INICIO,PANTALLA
	JSR KEM
	LDX SDLSTL
	LDY SDLSTL+1
	STX $BFFC
	STY $BFFD
	LDX # <DLIST
	LDY # >DLIST
	LDA #$00
	STX SDLSTL
	STX DLISTL
	STY SDLSTL+1
	STY DLISTL+1
	STA $41
	JMP $400
KEM
	ldy #$00
kem_loop1
	lda $e000,y
	sta kem_buffer,y
	lda $e100,y
	sta kem_buffer+$100,y
	lda $e200,y
	sta kem_buffer+$200,y
	lda $e300,y
	sta kem_buffer+$300,y
	iny
	bne kem_loop1
	lda #>KEM_BUFFER
	sta chbas
	sta chbase
	LDX #$C0
//	LDY #$00
	SEI
//	LDA $D40E
//	PHA
	STY $D40E
	STX $CC
	STY $CB
LOOP
	LDA ($CB),Y
	DEC PORTB
	STA ($CB),Y
	INC PORTB
	INY
	BNE LOOP
	INC $CC
	BEQ @EXIT
	LDA $CC
	CMP #$D0
	BNE LOOP
	LDA #$D8
	STA $CC
	BNE LOOP
@EXIT
	lda #$e0
	sta chbas
	sta chbase
	tya	//y está en cero, según el código de arriba
kem_loop2
	sta kem_buffer,y
	sta kem_buffer+$100,y
	sta kem_buffer+$200,y
	sta kem_buffer+$300,y
	iny
	bne kem_loop2
	DEC PORTB
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
NOPER
	STA $ED85,Y
	DEY
	BPL NOPER
	LDY #STACF-STACI
MOVE
	LDA STACI,Y
	STA $ECEF,Y
	DEY
	BPL MOVE
	lda #$40
	STA NMIEN
	CLI
	CLC
	RTS
STACI
	LDA #$7D
	LDX $62
	BEQ CC0
	LDA #$64
CC0
	CLC
	ADC $EE19,X
	DEY
	BPL CC0
	CLC
	ADC $0312
	SEC
	SBC #$64
	BCC CC3
	STA $0312
	LDY #$02
	LDX #$06
	LDA #$4F
CC2
	ADC $0312
	BCC CC1
	INY
	CLC
CC1
	DEX
	BNE CC2
	STA $02EE
	STY $02EF
	JMP $ED96
CC3
	JMP $ED3D
STACF
	.by "Dogdark Software 2020"
DLIST
	.BY $70,$70,$70,$70,$70,$70,$70,$70
	.BY $70,$70,$70,$70,$70,$46
	.WORD SHOW
	.BY $70,$06,$41
	.WORD DLIST
SHOW
TITLOP7
	.SB "--ACA VA EL TITULO--"
TITLO2P7
	.SB "--ACA VA EL TITULO--"
PANTALLA
	LDX $BFFC
	LDY $BFFD
	STX SDLSTL
	STY SDLSTL+1
PIRATEO
//	LDA SHOW+10
//	CMP #$73
//	BEQ PIRATEO2
//	JMP LOOPCITO
PIRATEO2
//	LDA SHOW+4
//	CMP #$E4
//	BEQ PIRATEO3
//	JMP LOOPCITO
PIRATEO3
	JMP $700
;LOOPCITO
	;JMP LOOPCITO
	.SB "AGRADEZCO A VITOCO Y WILLYSOFT"
FIN
.endp