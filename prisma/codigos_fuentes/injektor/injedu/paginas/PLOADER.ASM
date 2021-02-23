;load_init =$CBFE
load_init =$CC00
;
l_load = [.len loader]

.proc	loader,load_init
BAFER = $0700
BUFAUX = $0800
?RUTINA = BUFAUX+JUMP-RUTINA
;
	;ORG $CC00
	.by $55,$55
    ldy #$00
    STY $0244
    INY
    STY $09
    JSR RECUPERO
    JMP START
?INICIO
	JSR GBYTE
	STA MEMORY+1
	JSR GBYTE
	STA MEMORY+2
	AND MEMORY+1
	CMP #$FF
	BEQ ?INICIO
	RTS
NBYTES
    .BY 252   ;$FC
FLAGY
    .BY 0
FINISH
    .BY 0,0
LSIOV
    .BY $60,$00,$52,$40
    .WO BAFER
    .BY $23,$00
    .WO $0100
    .BY $00,$80
DLIST
    .BY $70,$70,$70,$47
    .WO MENSAJE
    .BY $70,$02,$70,$02,$70,$70,$F0,$F0
    .by $F0,$F0,$F0,$F0,$70,$70,$70,$70
    .by $70,$46
DLERR
    .WO NAME
    .BY $70,$02,$41
    .WO DLIST
MENSAJE
    .SB "       "
    .sb +128,"prisma"
    .sb "  "
    .SB "           "
    .sb "PROGRAMAS "
    .sb "PARA COMPUTADORES   "
    .sb "              LINEA "
    .SB "ATARI INJEKTOR      "
    .SB "    "
NAME
    .SB "                    "
    .SB "     Cargara dentro "
    .sb "de "
CONTADOR
    .SB "    Bloques.     "
MERROR
    .SB "  -  E R R O R  -   "
    .SB " Retroceda 3 vueltas"
    .SB " y presione "
    .sb +128," START "
    .sb " "
TIEMPO
    LDA #$40
    STA $D40E
    LDX #$E4
    LDY #$5F
    LDA #$06
    JSR $E45C
    RTS
LNEW
    LDX #$04
XNEW
    LDA $02C4,X
    STA PFIN+1,X
    DEX
    BPL XNEW
    LDA $0230
    STA PFIN+6
    LDA $0231
    STA PFIN+7
    LDA $022F
    STA PFIN+8
    LDA $02F4
    STA PFIN+9
    LDA $02F3
    STA PFIN+10
    RTS
NEWL
    LDX #$04
YNEW
    LDA PFIN+1,X
    STA $02C4,X
    DEX
    BPL YNEW
    LDA PFIN+6
    STA $0230
    LDA PFIN+7
    STA $0231
    LDA PFIN+8
    STA $022F
    LDA PFIN+9
    STA $02F4
    LDA PFIN+10
    STA $02F3
    RTS
NEWDL
	lda $d40b
	bne NEWDL
	sta $d40a
    LDX # <DLIST
    LDA # >DLIST
    STX $0230
    STX $D402
    STA $0231
    STA $D403
    LDA #$22
    STA $022F
    STA $D400
    LDA #$E0
    STA $02F4
    STA $D409
    LDA #$02
    STA $02F3
    STA $D401
    LDX #$04
COLORLOOP
    LDA TABLA,X
    STA $02C4,X
    STA $D016,X
    DEX
    BPL COLORLOOP
    lda #<NAME
    ldx #>NAME
    sta DLERR
    stx DLERR+1
    LDX #>COLORDAT
    LDY #<COLORDAT
    LDA #$06
    JSR $E45C
    LDX #<?COLORDAT
    LDY #>?COLORDAT
    LDA #$C0
    STX $0200
    STY $0201
    STA $D40E
    RTS
COLORDAT
    LDA #$00
    STA NOSEPO
    LDA $02C6
    STA NOSEPO2
    JMP $E45F
?COLORDAT
    PHA
    TXA
    PHA
    LDX NOSEPO
    LDA NOSEPO1,X
    STA $D40A
    STA $D01A
    INC NOSEPO
    PLA
    TAX
    PLA
    RTI
NOSEPO
    .BY $00
NOSEPO1
    .BY $52,$72,$B4,$EA,$32
NOSEPO2
    .BY $FF,$FF
TABLA
    .BY $28,$CA,$00,$44,$00
ERROR
    LDA #<MERROR
    LDX #>MERROR
    STA DLERR
    STX DLERR+1
    rts
VUELTA
    sty $d302
    CLC
    ADC $14
SEARCH
	CMP $14
	BNE SEARCH
	RTS
?SEARCH
    LDY #$34
    LDA #$1E
    JSR VUELTA
SPEED
	LDX #$FE
	STX $14
SIGUE
    LDA $D20F
    AND #$10
    BEQ SPEED
    LDX $14
    BNE SIGUE
    JMP NEWDL
BUSCA
	JSR ERROR
	LDA #$3C
	STA $D302
    LDA #$FD
    JSR $F2B0
?BUSCA
	LDA $D01F
	CMP #$06
	BNE ?BUSCA
    JSR ?SEARCH
    JMP GRAB
GBYTE
    CPY NBYTES
    BEQ GRAB
    TYA
    EOR BAFER+3,Y
    INY
    RTS
GRAB
    LDA PFIN
    BEQ BYE
    JSR LNEW
    JSR NEWDL
?GRAB
    LDX #$0B
MSIO
    LDA LSIOV,X
    STA $0300,X
    DEX
    BPL MSIO
    JSR $E459
    BMI BUSCA
    LDA BAFER+2
    CMP PFIN
    BCC BUSCA
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
    JSR NEWL
    DEC PFIN
    LDY #$00
    STY $4D
    JMP GBYTE
BYE
    JSR TIEMPO
    LDA #$E0
    LDY #$4C
    STA JUMP+1
   	STY esrutina
    LDX #$00
    TXS
    JMP RINIT
START
    LDY NBYTES
    JSR ?INICIO
    LDA MEMORY+1
    LDY MEMORY+2
    STA $02E0
	STY $02E1
	LDY #$00
LOOP
	JSR ?INICIO
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
    JSR TIEMPO
    JSR NEWL
    JSR RINIT
    JSR LNEW
    JSR ?SEARCH
    LDY FLAGY
    LDX #$00
    TXS
    STX $02E2
    STX $02E3
    JMP LOOP
RINIT
    LDX #PFIN-RUTINA-1
MVRUT
    LDA RUTINA,X
    STA BUFAUX,X
    DEX
    BPL MVRUT
    JMP BUFAUX
RUTINA
    LDA #$3C
    STA $D302
    LDA #$FF
    STA $D301
esrutina
	JSR BUFAUX+19
	LDA #$FE
	STA $D301
    RTS
JUMP
    JMP ($02E2)
PFIN
    .BY $00,$00,$00,$00,$00,$00
    .BY $00,$00,$00,$00,$00
RECUPERO
	LDX #$12
	LDY #$08
	STX $0C
	STY $0D
	LDX FINRECUPERO+50
	LDY FINRECUPERO+51
	STX $0230
	STY $0231
    JSR LNEW
    JSR NEWDL
    LDX #$13
RECUPERO2
    LDA FINRECUPERO,X
    STA NAME,X
    DEX
    BPL RECUPERO2
    LDX #$02
RECUPERO3
    LDA FINRECUPERO+20,X
    STA CONTADOR,X
    DEX
    BPL RECUPERO3
    LDX #$03
    LDA FINRECUPERO+23
    STX $41
    STA PFIN
    LDY #$7F
    LDA #$00
RECUPERO4
    STA $0400,Y
    DEY
    BPL RECUPERO4
    LDY #$3C
    LDA #$14
    JSR VUELTA
    JSR ?SEARCH
    JMP NEWL
FINRECUPERO
.endp