p4_init =$03FD
;
.proc	p4,p4_init
;
GENDAT = $47
	.BYTE $55,$55,$FE
    LDA $D301
    AND #$02
    BEQ ERROR
    LDA $0464
    STA GENDAT
    LDX #$0B
MOVE
    LDA SIOV,X
    STA $0300,X
    DEX
    BPL MOVE
    JSR $E459
    BMI ERROR
    CLC
    RTS
ERROR
    LDX $BFFC
    LDY $BFFD
    STX $0230
    STY $0231
    LDY #$00
LER
    LDA TABLA,Y
    STA ($58),Y
    INY
    CPY #$1B
    BNE LER
    LDA #$3C
    STA $D302
LOOP
    BNE LOOP
TABLA
    .SB +128,"ERROR !!!"
    .SB " CARGU"
    .SB "E NUEV"
    .SB "AMENTE"
SIOV
    .BYTE $60,$00,$52,$40
    .WORD $06FE
    .BYTE $23,$00
    .WORD $02BA
    .BYTE $00,$80
FIN
.endp