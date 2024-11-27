    ICL 'sys_equates.m65'
    ICL 'sys_macros.m65'
    ORG $700
    INS 'mydos.dat'
MYDOS
    JSR $07E0
    RTS
    INI MYDOS
    ORG $2000
    ICL 'paginas.asm'
DISPLAY
:3  .BY $70
    .BY $46
    .WO SHOW
:14  .BY $02
:8    .BY $02
    .BY $41
    .WO DISPLAY
SHOW
:20 .SB " "
    .SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
    .SB "|  DOGDARK MULTIBANCOS NHP 3.0 - 2025  |"
    .SB +32,"ARRRRRRRRRRRRRRRWRRRRRRRRRRRRRRRRRRRRRRD"
    .SB "|MEMORIA        |              ******* |"
    .SB "|BANCOS DISPO.  |                   ** |"
    .SB "|PORTB EN USO   |                  $** |"
    .SB "|VELOCIDAD      |          600 BAUDIOS |"
    .SB "|BYTES X BLOQUES|            251 BYTES |"
    .SB "|BYTES LEIDOS   |              ******* |"
    .SB "|BLOQUES GRABAR |       **** RESTANTES |"
    .SB "|TITULO ARCHIVO | ******************** |"
    .SB "|TITULO OPCIONAL| ******************** |"
    .SB "|FUENTE         | ******************** |"
    .SB +32,"ZRRRRRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRRRC"
BANQUEO
    .SB "INICIO BANQUEO**************************"  ;40
    .SB "****************************************"  ;80
    .SB "****************************************"  ;120
    .SB "****************************************"  ;160
    .SB "****************************************"  ;200
    .SB "****************************************"  ;240
    .SB "*****************************FIN BANQUEO"  ;280
MENSAJES
:40    .SB +128," "
ARMOLOGO
    LDX #19
ARMOLOGO01
    LDA DATADISPLAY,X
    STA SHOW,X
    DEX
    BPL ARMOLOGO01
    RTS
RESETER
    JSR ARMOLOGO
    RTS
START
    JSR RESETER
    LDX #<DISPLAY
    LDY #>DISPLAY
    STX $230
    STY $231
    LDA #$60
    STA 710
    STA 712
    JMP *
INICIO
    JMP START
    RUN INICIO
DATADISPLAY
    .BY $00,$E4,$EF,$E7,$E4
    .BY $E1,$F2,$EB,$00,$00
    .BY $73,$6F,$66,$74,$77
    .BY $61,$72,$65,$73,$00

