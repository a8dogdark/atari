;	OPT NO LIST
;
; GRABADOR SISTEMA NHP VER 3.6
;
; SAVE #D8:GRABB
;
;
; ASM,,#D8:GRABB.COM
;
@LEN =  LEN+2
@LBAF = LEN+4
PPILA = LEN+5
PCRSR = $CB
ORG =   PCRSR
SVMSC = $58
POSXY = $54
LENGHT = $4000
BAFER = $4000
FR0 =   $D4
CIX =   $F2
AFP =   $D800
IFP =   $D9AA
FPI =   $D9D2
FASC =  $D8E6
ZFR0 =  $DA44
FDIV =  $DB28
FMUL =  $DADB
FMOVE = $DDB6
INBUFF = $F3
LBUFF = $0580
LLOAD = PAG7-LOAD
LAUTO = PAG4-PAG7
BL4 =   LAUTO/128
LAST =  LAUTO-128*BL4
GENDAT = $47
;
	ORG $2000
	.by 0,0
RY
	.BY 0,0
LEN
    .BY 0,0
CONT
    .BY 0,0
STARTF
    .BY 0,0
FINISH
    .BY 0,0
@BL4
    .BY 0
?FILE
    .BY 'D:'
??FILE
    .BY '                    '
BBLQS
    .BY "000",$9B
ALL
    .BY 'D:*.*',$9B
DNHP
    .BY $60,$00,$50,$80
    .WO ??DIR
    .BY $35,$00
    .wo $0100
    .by $00,$80
BAKBYT
    .SB "00000"
BAKBLQ
    .SB "000"
RESTORE
    LDY #$13
?RESTORE
    LDA #$20
    STA ??FILE,Y
    LDA #$00
    STA NAME,Y
    STA FILE,Y
	DEY
    BPL ?RESTORE
    LDY #$17
??RESTORE
    LDA #$00
    STA CRSR,Y
    DEY
    BPL ??RESTORE
    LDY #$22
???RESTORE
    LDA #$00
    STA FILE,Y
    DEY
    BPL ???RESTORE
    LDA #$3F
    STA CRSR
    STA FILE
    LDA #$10
    LDY #$04
RESNUM
    STA BYTES,Y
    DEY
    BPL RESNUM
    STA BLOQUES
    STA BLOQUES+1
    STA BLOQUES+2
    RTS
PARCHE
	.SB +128,"by parche negro soft"
ASCINT
    CMP #$20
    BCC ADD64
    CMP #$60
    BCC SUB32
    CMP #$80
    BCC REMAIN
    CMP #$A0
    BCC ADD64
    CMP #$E0
    BCC SUB32
    BCS REMAIN
ADD64
    CLC
    ADC #$40
    BCC REMAIN
SUB32
    SEC
    SBC #$20
REMAIN
    RTS
CLS
    LDX # <??DIR
    LDY # >??DIR
    STX PCRSR
    STY PCRSR+1
    LDY #$00
    LDX #$00
?CLS
    LDA #$00
    STA (PCRSR),Y
    INY
    BNE ??CLS
    INX
    INC PCRSR+1
??CLS
    CPY #$68	;$68
    BNE ?CLS
    CPX #$01
    BNE ?CLS
    RTS
OPEN
    LDX #$10
    LDA #$03
    STA $0342,X
    LDA # <?FILE
    STA $0344,X
    LDA # >?FILE
    STA $0345,X
    LDA #$04
    STA $034A,X
    LDA #$80
    STA $034B,X
    JSR $E456
    DEY
    BNE DIR
    RTS
CLOSE
    LDX #$10
    LDA #$0C
    STA $0342,X
    JMP $E456
DIR
    JSR CLOSE
    JSR CLS
    LDX # <?DIR
    LDY # >?DIR
    STX $0230
    STY $0231
    LDX # <??DIR
    LDY # >??DIR
    STX PCRSR
    STY PCRSR+1
    LDX #$10
    LDA #$03
    STA $0342,X
    LDA # <ALL
    STA $0344,X
    LDA # >ALL
    STA $0345,X
    LDA #$06
    STA $034A,X
    LDA #$00
    STA $034B,X
    JSR $E456
    LDA #$07
    STA $0342,X
    LDA #$00
    STA $0348,X
    STA $0349,X
    STA RY
    STA RY+1
LEDIR
    JSR $E456
    BMI ?EXIT
    CMP #155
    BEQ EXIT
    JSR ASCINT
    LDY RY
    STA (PCRSR),Y
    INC RY
    BNE F0
    INC PCRSR+1
    INC RY+1
F0
    LDY RY+1
    CPY #$01
    BNE F1
    LDY RY
    CPY #$68	;$68
    BCC F1
    JSR PAUSE
F1
    JMP LEDIR
EXIT
    INC RY
    INC RY
    INC RY
    JMP LEDIR
?EXIT
    JSR CLOSE
    JSR PAUSE
    JSR CLS
    PLA
    PLA
    JMP START
PAUSE
    LDA 53279
    CMP #$06
    BNE PAUSE
    JSR CLS
    LDA #$00
    STA RY
    STA RY+1
    LDA # <??DIR
    STA PCRSR
    LDA # >??DIR
    STA PCRSR+1
    LDX #$10
    RTS
FLSH
    LDY RY
    LDA (PCRSR),Y
    EOR #$3F
    STA (PCRSR),Y
    LDA #$10
    STA $021A
    RTS
OPENK
    LDA #$FF
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
RUTLEE
    LDX # <FLSH
    LDY # >FLSH
    LDA #$10
    STX $0228
    STY $0229
    STA $021A
    JSR OPENK
GETEC
    JSR $E456
    CMP #$7E
    BNE C0
    LDY RY
    BEQ GETEC
    LDA #$00
    STA (PCRSR),Y
    LDA #$3F		;$3F
    DEY
    STA (PCRSR),Y
    DEC RY
    JMP GETEC
C0
    CMP #$9B	;$9B
    BEQ C2
    JSR ASCINT
    LDY RY
    STA (PCRSR),Y
    CPY #$14	;#14
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
    RTS
FGET
    LDA #$00
    STA LEN
    STA LEN+1
    LDA #$DD
    STA $D301
LOPFGET
    LDX #$10
    LDA #$07
    STA $0342,X
    LDA # <BAFER
    STA $0344,X
    LDA # >BAFER
    STA $0345,X
    LDA # <LENGHT
    STA $0348,X
    LDA # >LENGHT
    STA $0349,X
??FGET
    JSR $E456
    LDA $0349,X
    CMP #>LENGHT
    BNE ?FGET
    LDA $0348,X
    CMP #$00
    BNE ?FGET
    CLC
    LDA $D301
    ADC #$04
    STA $D301
    CLC
    LDA #$00
    ADC LEN
    STA LEN
    LDA #$40
    ADC LEN+1
    STA LEN+1
    JMP ??FGET
?FGET
    JSR ZFR0
    LDA #$FC	;$FC
    STA FR0
    JSR IFP
    JSR FMOVE
    LDX #$10
    CLC
    LDA $0348,X
    ADC LEN
    STA LEN
    STA FR0
    LDA $0349,X
    ADC LEN+1
    STA LEN+1
    STA FR0+1
    JSR IFP
    JSR PONBYTES
    JSR FDIV
    JSR PONBLOQUES
    JSR FPI
    LDA FR0
    PHA
    DEC FR0
    JSR IFP
    JSR FMOVE
    LDA #$FC	;$FC
    STA FR0
    LDA #$00
    STA FR0+1
    JSR IFP
    JSR FMUL
    JSR FPI
    SEC
    LDA LEN
    SBC FR0
    STA CONT+1
    INC CONT+1
    PLA
    STA CONT
    LDX #$10
    RTS
PONBYTES
    JSR NBYTES
    STY RY
    LDY #$04
?PONBYTES
    LDA LBUFF,X
    AND #$5F
    STA BYTES,Y
    DEY
    DEX
    DEC RY
    BPL ?PONBYTES
    RTS
PONBLOQUES
    JSR NBYTES
    STY RY
    LDY #$02
?PONBLOQUES
    LDA LBUFF,X
    AND #$5F
    STA BLOQUES,Y
    DEY
    DEX
    DEC RY
    BPL ?PONBLOQUES
    LDA BLOQUES+2
    CMP #$19
    BEQ ??PP0
    INC BLOQUES+2
PP0
    LDY #$02
MVBLQ
    LDA BLOQUES,Y
    ORA #$20
    STA BBLQS,Y
    DEY
    BPL MVBLQ
    LDX # <BBLQS
    LDY # >BBLQS
    LDA #$00
    STX INBUFF
    STY INBUFF+1
    STA CIX
    JMP AFP
??PP0
    LDA #$10
    STA BLOQUES+2
    LDA BLOQUES+1
    CMP #$19
    BEQ ???PP0
    INC BLOQUES+1
    JMP PP0
???PP0
    LDA #$10
    STA BLOQUES+1
    INC BLOQUES
    JMP PP0
NBYTES
    JSR FASC
    LDX #$00
    LDY #$00
    LDA LBUFF
    CMP #$30	;'0
    BNE PL0
    INX
PL0
    LDA LBUFF,X
    CMP #$80
    BCS PL1
    CMP #$2E		;'.
    BEQ PL2
    INX
    INY
    JMP PL0
PL1
    RTS
PL2
	DEX
    LDA LBUFF,X
    ORA #$80
    STA LBUFF,X
    DEY
    RTS
;************************************
; pagina load
;************************************
LOAD
	ICL 'paginas/ploader.asm'
;************************************
; pagina pag7
;************************************
PAG7
	ICL 'paginas/p7.asm'
;************************************
; pagina pag4
;************************************
PAG4
	ICL 'paginas/p4.asm'
@GENDAT
	.BYTE 0
ESPSIO
	.BYTE $55,$55
NME
	.BYTE '....................'
BLQ
	.BYTE '...'
PFIN
	.BYTE 0
ESIO
	.BYTE $60,$00,$50,$80
    .WORD ESPSIO
    .BYTE $23,$00
    .WORD 26
    .BYTE $00,$80
OPENC
	LDA $D40B
    BNE OPENC
    LDA #$FF
    STA 764		;$02FC
?OPENC
    LDA $02FC
    CMP #$FF
    BEQ ?OPENC
    LDA #$FF
    STA $02FC
    JMP $FD40
PONDATA
	LDY #$02
??PONDATA
    LDA BLOQUES,Y
    STA BLQ,Y
    DEY
    BPL ??PONDATA
    LDY #$13
?PONDATA
	LDA NAME,Y
	STA NME,Y
	DEY
	BPL ?PONDATA   
    RTS
INITSIOV
    LDY #$0B
?INITSIOV
    LDA DNHP,Y
    STA $0300,Y
    DEY
    BPL ?INITSIOV
    LDA #$00
    STA 77		;$4D
    RTS
AUTORUN
    LDX # <PAG7
    LDY # >PAG7
    LDA #$00
    STX MVPG7+1
    STY MVPG7+2
    STA @BL4
FALTA
    JSR INITSIOV
    LDX #<??DIR
    LDY #>??DIR
    STX $0304
    STY $0305
    LDX #131	; $83
    LDY #$00	; $00
    STX $0308
    STY $0309
    LDY #$00
    TYA
CLBUF
    STA ??DIR,Y
    INY
    CPY #131	;$83
    BNE CLBUF
    LDA #$55
    STA ??DIR
    STA ??DIR+1
    LDX #$FC
    LDY #127	;$7F
    DEC @BL4
    BPL NOFIN
    LDX #$FA
    LDY #LAST
    STY ??DIR+130
NOFIN
    STX ??DIR+2
MVPG7
    LDA PAG7,Y
    STA ??DIR+3,Y
    DEY
    BPL MVPG7
    JSR $E459
    CLC
    LDA MVPG7+1
    ADC #$80
    STA MVPG7+1
    LDA MVPG7+2
    ADC #$00
    STA MVPG7+2
    LDA @BL4
    BPL FALTA
    RTS
GAUTO
	LDA $D20A
	STA GENDAT
	STA @GENDAT
    JSR AUTORUN
    JSR INITSIOV
    LDX # <131
    LDY # >131
    STX $0308
    STY $0309
    LDX # <PAG4
    LDY # >PAG4
    STX $0304
    STY $0305
    JSR $E459
    JSR INITSIOV
    LDX #$BA
    LDY #$02
    STX $0308
    STY $0309
    LDX # <LOAD
    LDY # >LOAD
    STX $0304
    STY $0305
    JSR $E459
    RTS
REST
    LDY #$04
??REST
    LDA BYTES,Y
    STA BAKBYT,Y
    DEY
    BPL ??REST
    LDY #$02
???REST
    LDA BLOQUES,Y
    STA BAKBLQ,Y
    DEY
    BPL ???REST
    RTS
?REST
    LDY #$04
????REST
    LDA BAKBYT,Y
    STA BYTES,Y
    DEY
    BPL ????REST
    LDY #$02
?????REST
    LDA BAKBLQ,Y
    STA BLOQUES,Y
    DEY
    BPL ?????REST
    LDA CONT
    STA PFIN
    RTS
SAVESIO
    LDX #$0B
?SAVESIO
	LDA ESIO,X
    STA $0300,X
    DEX
    BPL ?SAVESIO
    JMP $E459   
EXNHPUT
    LDA #$80
    STA 77
    PLA
    PLA
    PLA
    PLA
    RTS
SEPAR
	LDY #$13
	STY $00
?SEPAR
	LDA PARCHE,Y
	STA SPARCHE,Y    
    DEY
    BPL ?SEPAR
    LDX #$28
    LDY #$A7
    LDA #$07
    JSR $E45C
LOOPSEPAR
	BNE LOOPSEPAR
	LDY $00
	LDA SPARCHE,Y
	EOR #$80
	STA SPARCHE,Y
	DEC $00
	BPL ??SEPAR
	LDY #$13
	STY $00
??SEPAR
	JMP $E462
???SEPAR
	ADC SPARCHE,Y
	DEY
	BPL ???SEPAR
	CMP #$94
	BNE SEPAR
NHPUT
    JSR SAVESIO
    LDA #$55
    STA ??DIR
    STA ??DIR+1
    LDA #$FC	;$FC
    STA ??DIR+255
	LDA #$DD
	STA $D301
    LDA # >BAFER
    STA GBYTE+7
    LDX #$00
    LDY #$00
    STY $02E2
    JSR GRABACION
    JMP ?MVBF
GRABACION
    LDA PFIN
    STA ??DIR+2
    BEQ EXNHPUT
    CMP #$01
    BNE RETURN
    LDA CONT+1
    STA ??DIR+255
RETURN
    RTS
?MVBF
    JSR GBYTE
    STA STARTF
    JSR GBYTE
    STA STARTF+1
    AND STARTF
    CMP #$FF
    BEQ ?MVBF
    JSR GBYTE
    STA FINISH
    JSR GBYTE
    STA FINISH+1
NHLOP
    JSR GBYTE
    LDA STARTF
    CMP #$E3
    BNE ?NHLOP
    LDA STARTF+1
    CMP #$02
    BNE ?NHLOP
    STA $02E2
?NHLOP
    LDA STARTF
    CMP FINISH
    BNE NHCONT
    LDA STARTF+1
    CMP FINISH+1
    BEQ ?MVBF
NHCONT
    INC STARTF
    BNE NOHI
    INC STARTF+1
NOHI
    JMP NHLOP
GBYTE
	CPY ??DIR+255
    BEQ EGRAB
    LDA BAFER,X
    STA $44
    PHA
    TYA
M
    EOR $44
    EOR GENDAT
    STA ??DIR+3,Y
    INY
    INX
    BNE EXNHPIT
    INC GBYTE+7
    BPL EXNHPIT
    LDA #>BAFER
    STA GBYTE+7
    CLC
    LDA $D301
    ADC #$04
    STA $D301
EXNHPIT
	PLA
	INC GENDAT
    RTS
EGRAB
    DEC PFIN
    TXA
    PHA
    JSR INITSIOV
    JSR $E459
    LDX #$02
DECBL01
    LDA BLOQUES,X
    CMP #$10
    BNE DECBL02
    LDA #$19
    STA BLOQUES,X
    DEX
    BPL DECBL01
DECBL02
    DEC BLOQUES,X
    PLA
    TAX
	LDA $02E2
    BNE SLOWB
SIGUE
    JSR GRABACION
    LDY #$00
    JMP GBYTE
SLOWB
    TXA
    PHA
    LDX # <350	;$015e
    LDY # >350
    STX $021C
    STY $021D
IRG
    LDA $021D
    BNE IRG
    LDA $021C
    BNE IRG
    LDA #$00
    STA $02E2
    PLA
    TAX
    JMP SIGUE
DLS
    .BYTE $70,$70,$70,$46
    .WORD SHOW
	.BYTE $70,$06,$70,$70,$02,$02,$70,$70
    .BYTE $70,$06,$70,$70,$70,$02,$70,$70
    .BYTE $70,$70,$70,$70,$70,$02,$41
    .WORD DLS
; -------------------------
; DEFINICION DEL DISPLAY
; PARA DIRECTORIO
; -------------------------
?DIR
    .BYTE $70,$70,$70,$70,$70,$70,$70,$70
    .BYTE $46
    .WORD ???DIR
    .BYTE $70,$02,$02,$02,$02,$02,$02,$02
    .BYTE $02,$02,$41
    .WORD ?DIR
SHOW
    .SB " COPIADOR NHP 2.56  "
SPARCHE
    .SB +128,"by parche negro soft"
    .SB "               12345"
    .SB "678901234567890     "
    .SB +128,"NOMBRE PORTADA:"
CRSR
    .SB "_                   "
    .SB "     "
NAME
    .SB "                    "
    .SB +128,"FILE:"
FILE
    .SB "_                   "
    .SB "               "
    .SB +128,"BYTES"
    .SB +128," LEIDOS:"
    .SB " "
BYTES
    .SB "*****       "
    .SB +128,"BLOQUES:"
    .SB " "
BLOQUES
    .SB "***  "
???DIR
    .SB "     DIRECTORIO     "
??DIR
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
	.SB "                                        "
CLAVE
	PHA
	LDY #$02
??CLAVE
	LDA CRSR,Y
	CMP ????CLAVE,Y
	BNE ???CLAVE
	DEY
	BPL ??CLAVE
	PLA
	PLA
	JMP ($0A)
???CLAVE
	PLA
	RTS
????CLAVE
	.BY $24,$2F,$33
DOS
    JMP ($0C)
@START
	JSR DOS
START
    LDX # <DLS
    LDY # >DLS
    STX $0230
    STY $0231
    LDA #$CA
    STA $02C5
    LDA #$00
    STA $02C6
    JSR RESTORE
    LDX # <CRSR
    LDY # >CRSR
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
    TYA
    BEQ NOTITLE
    JSR CLAVE
    LSR 
    STA RY+1
    LDA #$0A
    SEC
    SBC RY+1
    STA RY+1
    LDX #$00
    LDY RY+1
WRITE
    LDA CRSR,X
    STA NAME,Y
    INY
    INX
    CPX RY
    BNE WRITE
NOTITLE
    LDX # <FILE
    LDY # >FILE
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
    LDY #19
CONV
    LDA FILE,Y
    BEQ ?REMAIN
    AND #$7F
    CMP #64
    BCC ADD32
    CMP #96
    BCC SUB64
    BCS ?REMAIN
ADD32
    CLC
    ADC #32
    BCC OKLET
SUB64
    SEC
    SBC #64
?REMAIN
    LDA #$9B
OKLET
    STA ??FILE,Y
    DEY
    BPL CONV
    JSR OPEN
    JSR FGET
    JSR CLOSE
    JSR PONDATA
    JSR REST
OTRACOPIA
    JSR ?REST
    JSR OPENC
    JSR GAUTO
    LDY #$27
    LDA #$00
    CLC
    JSR ???SEPAR
    LDX #$3C
    LDA #$03
    STA $D20F
    STX $D302
WAIT
    LDA 53279
    CMP #$07
    BEQ WAIT
    CMP #$06
    BEQ OTRACOPIA
    CMP #$03
    BNE WAIT
    JMP START
PIRATAS
    JSR CLOSE
    LDX # <OPENK
    LDY # >OPENK
    NOP
    NOP
    NOP
    JSR CLOSE
    LDX # <@START
    LDY # >@START
    LDA #$03
    STX $02
    STY $03
    STA $09
    LDY #$FF
    STY $08
    INY   
    STY $0244
	JMP START
	RUN PIRATAS