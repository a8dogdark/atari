LOAD
INITLOAD = $CC00
.PROC PAGINALOAD,INITLOAD
BAFERLOAD = $0700
BUFAUXLOAD = $0800
?RUTINALOAD = BUFAUXLOAD+PFINLOAD-RUTINALOAD
	.BYTE $55,$55
    LDY #$00
    STY $0244
    INY
    STY $09
    JSR RECUPEROLOAD
    JMP STARTLOAD
NBYTESLOAD
    .BYTE 252   ;$FC
FLAGYLOAD
    .BYTE 0
FINISHLOAD
    .BYTE 0,0
MMMSIOV
    .BYTE $60,$00,$52,$40
    .WORD BAFERLOAD
    .BYTE $23,$00
    .WORD $0100
    .BYTE $00,$80
DLISTLOAD
    .BYTE $70,$70,$70,$47
    .WORD MENSAJELOAD
    .BYTE $70,$02,$70,$02,$70,$70
    .BYTE $F0,$F0,$F0,$F0,$F0,$F0
    .BYTE $70,$70,$70,$70,$70,$46
DLERRLOAD
    .WORD NAMELOAD
    .BYTE $70,$02,$41
    .WORD DLISTLOAD
MENSAJELOAD
    .SB "       "
    .SB +128,"prisma"
    .SB "       "
    .SB "      PROGRAMAS PARA COMPUTADORES       "
    .SB "              LINEA ATARI               "
NAMELOAD
    .SB "                    "
    .SB "     Cargara dentro de "
CONTADORLOAD
    .SB "    Bloques.     "
MERRLOAD
    .SB "  -  E R R O R  -   "
    .SB " Retroceda 3 vueltas y presione  START  "
TIEMPOLOAD
    LDA #$40
    STA $D40E
    LDX #$E4
    LDY #$5F
    LDA #$06
    JSR $E45C
    RTS
LNEWLOAD
    LDX #$04
XNEWLOAD
    LDA $02C4,X
    STA PFINLOAD+1,X
    DEX
    BPL XNEWLOAD
    LDA $0230
    STA PFINLOAD+6
    LDA $0231
    STA PFINLOAD+7
    LDA 559     ;$022F
    STA PFINLOAD+8
    LDA 756     ;$02F4
    STA PFINLOAD+9
    LDA 755     ;$02F3
    STA PFINLOAD+10
    RTS
NEWLLOAD
    LDX #$04
YNEWLOAD
    LDA PFINLOAD+1,X
    STA $02C4,X
    DEX
    BPL YNEWLOAD
    LDA PFINLOAD+6
    STA $0230
    LDA PFINLOAD+7
    STA $0231
    LDA PFINLOAD+8
    STA 559
    LDA PFINLOAD+9
    STA 756
    LDA PFINLOAD+10
    STA 755
    RTS
NEWDLLOAD
    LDX # <DLISTLOAD
    LDA # >DLISTLOAD
    STX $0230
    STX $D402
    STA $0231
    STA $D403
    LDA #$22
    STA 559
    STA $D400
    LDA #224
    STA 756
    STA $D409
    LDA #$02
    STA 755
    STA $D401
    LDX #$04
COLORLOOPLOAD
    LDA TABLALOAD,X
    STA $02C4,X
    STA $D016,X
    DEX
    BPL COLORLOOPLOAD
    LDA # <NAMELOAD
    LDX # >NAMELOAD
    STA DLERRLOAD
    STX DLERRLOAD+1
    LDX #$CD
    LDY #$D7
    LDA #$06
    JSR $E45C
    LDX #$E5
    LDY #$CD
    LDA #$C0
    STX $0200
    STY $0201
    STA $D40E
    RTS
    LDA #$00
    STA NOSEPOLOAD
    LDA $02C6
    STA NOSEPOLOADR02
    JMP $E45F
    PHA
    TXA
    PHA
    LDX NOSEPOLOAD
    LDA NOSEPOLOAD01,X
    STA $D40A
    STA $D01A
    INC NOSEPOLOAD
    PLA
    TAX
    PLA
    RTI
NOSEPOLOAD
    .BYTE 0
NOSEPOLOAD01
    .BYTE $52,$72,$B4,$EA,$32
NOSEPOLOADR02
    .BYTE $FF,$FF
TABLALOAD
    .BYTE $28,$CA,$00,$44,$00
CONCHATLOAD
    LDA # <MERRLOAD
    LDX # >MERRLOAD
	STA DLERRLOAD
    STX DLERRLOAD+1
    RTS
ERRORLOAD
    JSR CONCHATLOAD
    LDA #$3C
    STA $D302
    LDA #$FD
    JSR $F2B0
VUELTALOAD
    LDA 53279
    CMP #$06
    BNE VUELTALOAD
    JSR SEARCHLOAD
    JMP GRABLOAD
SEARCHLOAD
    LDA #$34
    STA $D302
    LDX #$10
    STX $021C
SPEEDLOAD
    LDX $021C
    BNE SPEEDLOAD
SIGUELOAD
    LDX #$FD
    STX $14
BUSCALOAD
    LDA $D20F
    AND #$10
    BEQ SIGUELOAD
    LDX $14
    BNE BUSCALOAD
    JMP NEWDLLOAD
GBYTELOAD
    CPY NBYTESLOAD
    BEQ GRABLOAD
    TYA
    EOR BAFERLOAD+3,Y
    EOR GENDAT
    INC GENDAT
    INY
    RTS
GRABLOAD
    LDA $D40B
    BNE GRABLOAD
    LDA PFINLOAD
    BEQ BYELOAD
    JSR LNEWLOAD
    JSR NEWDLLOAD
?GRABLOAD
    LDX #$0B
MSIOLOAD
    LDA MMMSIOV,X
    STA $0300,X
    DEX
    BPL MSIOLOAD
    JSR $E459
    BMI ERRORLOAD
    LDA BAFERLOAD+2
    CMP PFINLOAD
    BCC ERRORLOAD
    BEQ RETURNLOAD
    JMP ?GRABLOAD
RETURNLOAD
    LDA BAFERLOAD+255
    STA NBYTESLOAD
    LDX #$02
C01LOAD
    LDA CONTADORLOAD,X
    CMP #$10
    BNE C02LOAD
    LDA #$19
    STA CONTADORLOAD,X
    DEX
    BPL C01LOAD
C02LOAD
    DEC CONTADORLOAD,X
    JSR NEWLLOAD
    DEC PFINLOAD
    LDY #$00
    STY 77
    JMP GBYTELOAD
BYELOAD
    JSR TIEMPOLOAD
    LDA #$3C
    LDX #$00
    LDY #$60
    STA $D302
    TXS
    STY BAFERLOAD
    JMP ($02E0)
STARTLOAD
    LDY NBYTESLOAD
LOOPLOAD
    JSR GBYTELOAD
    STA MBTMLOADLOAD+1
    JSR GBYTELOAD
    STA MBTMLOADLOAD+2
    AND MBTMLOADLOAD+1
    CMP #$FF
    BEQ LOOPLOAD
    JSR GBYTELOAD
    STA FINISHLOAD
    JSR GBYTELOAD
    STA FINISHLOAD+1
MBTMLOAD
    JSR GBYTELOAD
MBTMLOADLOAD
    STA $FFFF
    LDA MBTMLOADLOAD+1
    CMP FINISHLOAD
    BNE OKLOAD
    LDA MBTMLOADLOAD+2
    CMP FINISHLOAD+1
    BEQ VERFINLOAD
OKLOAD
    INC MBTMLOADLOAD+1
    BNE NIMLOAD
    INC MBTMLOADLOAD+2
NIMLOAD
    JMP MBTMLOAD
VERFINLOAD
    LDA $02E2
    ORA $02E3
    BEQ LOOPLOAD
    LDX #$F0
    TXS
    STY FLAGYLOAD
    JSR TIEMPOLOAD
    JSR NEWLLOAD
    JSR RINITLOAD
    JSR LNEWLOAD
    JSR SEARCHLOAD
    LDY FLAGYLOAD
    LDX #$00
    TXS
    STX $02E2
    STX $02E3
    JMP LOOPLOAD
RINITLOAD
    LDX #PFINLOAD-RUTINALOAD-1
MVRUTLOAD
    LDA RUTINALOAD,X
    STA BUFAUXLOAD,X
    DEX
    BPL MVRUTLOAD
    JMP BUFAUXLOAD
RUTINALOAD
    LDA #$3C
    STA $D302
    JSR ?RUTINALOAD
    LDA #$FE
    STA $D301
    RTS
JUMPLOAD
    JMP ($02E2)
PFINLOAD
    .BYTE $00,$00,$00,$00,$00,$00
    .BYTE $00,$00,$00,$00,$00
RECUPEROLOAD
    JSR LNEWLOAD
    LDX #$0B
RECUPEROLOAD02
    LDA FINRECUPEROLOAD,X
    STA $0300,X
    DEX
    BPL RECUPEROLOAD02
    JSR $E459
    BPL RECUPEROLOAD03
    LDA #$3C
    STA $D302
    LDA $D301
    AND #$FD
    STA $D301
    JMP $0400
RECUPEROLOAD03
    LDX #$13
RECUPEROLOAD04
    LDA FINRECUPEROLOAD+2,X
RECUPEROLOAD05
    STA NAMELOAD,X
    DEX
    BPL RECUPEROLOAD04
    LDX #$02
RECUPEROLOAD06
    LDA FINRECUPEROLOAD+22,X
    STA CONTADORLOAD,X
    DEX
    BPL RECUPEROLOAD06
    LDX #$03
    LDA FINRECUPEROLOAD+25
    STX $41
    STA PFINLOAD
    LDY #$7F
    LDA #$00
RECUPEROLOAD07
    STA $0400,Y
    DEY
    BPL RECUPEROLOAD07
    JSR NEWDLLOAD
    JMP NEWLLOAD
FINRECUPEROLOAD
    .BYTE $60,$00,$52,$40
    .WORD FINRECUPEROLOAD
    .BYTE $23,$00
    .WORD 26
    .BYTE $00,$80
.ENDP