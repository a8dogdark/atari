GENDAT = $47
;
	ORG $03FD
	.BYTE $55,$55,$FE
    LDA $D301
    AND #$02
    BEQ ERROR
    LDX #$0B
MOVE
    LDA SIOV,X
    STA $0300,X
    DEX
    BPL MOVE
    JSR $E459
    BMI ERROR
    LDA FIN+1
    STA GENDAT
    CLC
    RTS
ERROR
    LDX $CFFC
    LDY $CFFD
    STX $0230
    STY $0231
    LDY #$00
LER
    LDA TABLA,Y
    STA ($58),Y
    INY
    CPY #27
    BNE LER
    LDA #$3C
    STA $D302
LOOP
    BNE LOOP
TABLA
    .SB +128,"ERROR !!!"
    .SB " CARGUE NUEVAMENTE"
SIOV
    .BYTE $60,$00,$52,$40
    .WORD $CC00
    .BYTE $23,$00
    .WORD $03BC
    .BYTE $00,$80
FIN