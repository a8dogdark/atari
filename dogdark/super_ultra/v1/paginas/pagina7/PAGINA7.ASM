	ORG $2000
INICIO 
	.BYTE $00,$03
	.WORD INICIO,PANTALLA
	JSR KEM
	LDX $0230
	LDY $0231
	STX $BFFC
	STY $BFFD
	LDX # <DLIST
	LDY # >DLIST
	LDA #$00
	STX $0230
	STX $D402
	STY $0231
	STY $D403
;	STA $41
	JMP $0400
KEM
	LDX #$C0
    LDY #$00
    SEI
    LDA $D40E
    PHA
    STY $D40E
    STX $CC
    STY $CB
LOOP
    LDA ($CB),Y
    DEC $D301
    STA ($CB),Y
    INC $D301
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
NOP
    STA $ED85,Y
    DEY
    BPL NOP
    LDY #STACF-STACI
MOVE
    LDA STACI,Y
    STA $ECEF,Y
    DEY
    BPL MOVE
    PLA
    STA $D40E
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
	.BYTE "By Dogdark Softwares 2020"
DLIST
	.BYTE $70,$70,$70,$70,$70,$70,$70,$70
	.BYTE $70,$70,$70,$70,$70,$46
	.WORD SHOW
	.BYTE $70,$06,$41
	.WORD DLIST
SHOW
	.SB "--ACA VA EL TITULO--"
	.SB "--ACA VA EL TITULO--"
PANTALLA
	LDX $BFFC
	LDY $BFFD
	STX $0230
	STY $0231
PIRATEO
	LDA SHOW+10
	CMP #$73
	BEQ PIRATEO2
	JMP LOOPCITO
PIRATEO2
	LDA SHOW+4
	CMP #$E4
	BEQ PIRATEO3
	JMP LOOPCITO
PIRATEO3
	JMP ($0304)
LOOPCITO
	JMP LOOPCITO
	.SB "AGRADESCO A VITOCO Y WILLYSOFT"