;SAVE#D:HEXASCII.ASM
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