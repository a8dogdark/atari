;load_init =$CBFE
pload_init =$6FE
;
;l_load = [.len loader]

.proc	pload,pload_init
BAFER = $095F
BUFAUX = $0800
;?RUTINA = BUFAUX+JUMP-RUTINA
;
INICIO
	.BYTE $55,$55
    LDX #$00
    TXS
    STX $0244
    INX
    STX $09
    JSR RECUPERO
    JMP START
NBYTES
    .BYTE 252   ;$FC
FLAGY
    .BYTE 0
FINISH
    .BYTE 0,0
MMMSIOV
    .BYTE $60,$00,$52,$40
    .WORD BAFER
    .BYTE $23,$00
    .WORD $0100
    .BYTE $00,$80
DLIST
    .BYTE $70,$70,$70,$47
    .WORD MENSAJE
    .BYTE $70,$02,$70,$02,$70,$70,$70,$70
    .BYTE $70,$70,$70,$70,$70,$70,$70,$70
    .BYTE $70,$46
DLERR
    .WORD NAME
    .BYTE $70,$02,$41
    .WORD DLIST
MENSAJE
    .SB "       "
    .SB +128,"prisma"
    .SB "       "
    .SB "    PROGRAMAS PARA M"
    .SB "ICROCOMPUTADORES    "
    .SB "       ATARI CON SIS"
    .SB "TEMA "
    .SB +128," N.H.P. "
    .SB "       "
NAME
    .SB "                    "
    .SB "     Cargara dentro de "
CONTADOR
    .SB "    Bloques.     "
DERR
    .SB "  -  E R R O R  -   "
    .SB " Retroceda"
MERR
   	.SB " 3 vueltas y presione "
   	.SB +128," START "
   	.SB " "
NEWDL
    LDX # <DLIST
    LDY # >DLIST
    LDA $02C8
    STX $0230
    STX $D402
    STY $0231
    STY $D403
    STA $02C6
    STA $D018
    RTS
ERROR
    LDA #$3C
    STA $D302
    LDA #$FD
    JSR $F2B0
    JSR NEWDL
    LDX #<DERR
    LDY #>DERR
    STX DLERR
    STY DLERR+1
VUELTA
    LDA 53279
    CMP #$06
    BNE VUELTA
    JSR SEARCH
    LDX #<NAME
    LDY #>NAME
    STX DLERR
    STY DLERR+1
    JMP GRAB
SEARCH
    LDA #$34
    STA $D302
    LDX #$10
    STX $021C
SPEED
    LDX $021C
    BNE SPEED
SIGUE
    LDX #$FD
    STX $14
BUSCA
    LDA $D20F
    AND #$10
    BEQ SIGUE
    LDX $14
    BNE BUSCA
    RTS
GBYTE
    CPY NBYTES
    BEQ GRAB
    TYA
    EOR BAFER+3,Y
    EOR GENDAT
    INC GENDAT
    INY
    RTS
GRAB
    LDA $D40B
    BNE GRAB
    LDA PFIN
    BEQ BYE
?GRAB
    LDX #$0B
MSIO
    LDA MMMSIOV,X
    STA $0300,X
    DEX
    BPL MSIO
    JSR $E459
    BMI ERROR
    LDA BAFER+2
    CMP PFIN
    BCC ERROR
    BEQ RETURN
    JMP ?GRAB
RETURN
    LDA BAFER+255
    STA NBYTES
    LDX #$02
C01
    LDA CONTADOR,X
    CMP #$10
    BNE C02
    LDA #$19
    STA CONTADOR,X
    DEX
    BPL C01
C02
    DEC CONTADOR,X
    DEC PFIN
    LDY #$00
    STY 77
    JMP GBYTE
BYE
    LDX #$00
    TXS
    LDA #$3C
    STA $D302
    JMP ($02E0)
START
    LDY NBYTES
LOOP
    JSR GBYTE
    STA MEMORY+1
    JSR GBYTE
    STA MEMORY+2
    AND MEMORY+1
    CMP #$FF
    BEQ LOOP
    JSR GBYTE
    STA FINISH
    JSR GBYTE
    STA FINISH+1
MBTM
    JSR GBYTE
MEMORY
    STA $FFFF
    LDA MEMORY+1
    CMP FINISH
    BNE OK
    LDA MEMORY+2
    CMP FINISH+1
    BEQ VERFIN
OK
    INC MEMORY+1
    BNE NIM
    INC MEMORY+2
NIM
    JMP MBTM
VERFIN
    LDA $02E2
    ORA $02E3
    BEQ LOOP
    LDX #$F0
    TXS
    STY FLAGY
    JSR RUTINA
    JSR SEARCH
    LDY FLAGY
    LDX #$00
    TXS
    STX $02E2
    STX $02E3
    JMP LOOP
RUTINA
    LDA #$3C
    STA $D302
    JMP ($02E2)
PFIN
    .BYTE $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE $00,$00,$00
RECUPERO
    LDX #$0B
RECUPERO2
    LDA FINRECUPERO,X
    STA $0300,X
    DEX
    BPL RECUPERO2
    JSR $E459
    BPL RECUPERO3
    JMP $E477
RECUPERO3
    LDX #$13
RECUPERO4
    LDA FINRECUPERO+2,X
    STA NAME,X
    DEX
    BPL RECUPERO4
    LDX #$02
RECUPERO5
    LDA FINRECUPERO+22,X
    STA CONTADOR,X
    DEX
    BPL RECUPERO5
    LDX #$03
    LDY #$22
    LDA FINRECUPERO+25
    STX $41
    STY $022F
    STY $D400
    STA PFIN
    LDX #$00
    TXA
RECUPERO6
    STA $0400,X
    INX
    BPL RECUPERO6
    STA INICIO
    STA INICIO+1
    JMP NEWDL
FINRECUPERO
    .BYTE $60,$00,$52,$40
    .WORD FINRECUPERO
    .BYTE $23,$00
    .WORD $001A
    .BYTE $00,$80
.endp