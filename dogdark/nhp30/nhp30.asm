    ICL 'sys_equates.m65'
    ICL 'sys_macros.m65'
    ORG $700
MYDOS
    INS 'mydos.dat'
    JSR $07E0
    INI MYDOS
    ORG $2000
    ICL 'paginas.asm'
    ICL 'funciones.asm'
DLSPRINCIPAL
:3  .BY $70
    .BY $46
    .WO SHOWPRINCIPAL
:14  .BY $02
    .BY $70
:8    .BY $02    
    .BY $41
    .WO DLSPRINCIPAL
SHOWPRINCIPAL
:20    .SB " "
    .SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
    .SB "|  DOGDARK MULTIBANCOS NHP 3.0 - 2025  |"
    .SB +32,"ARRRRRRRRRRRRRRRWRRRRRRRRRRRRRRRRRRRRRRD"
    .SB "|MEMORIA        |              ******* |"
    .SB "|BANCOS         |                   ** |"
    .SB "|PORTB          |                  $** |"
    .SB "|SISTEMA        |VELOCIDAD 600 BAUDIOS |"
    .SB "|BLOQUES GRABAR | 251 BYTES POR BLOQUE |"
    .SB "|BYTES LEIDOS   |              ******* |"
    .SB "|BLOQUES        |        **** A GRABAR |"
    .SB "|TITULO ARCHIVO | ******************** |"
    .SB "|TITULO OPCIONAL| ******************** |"
    .SB "|FUENTE         | ******************** |"
    .SB +32,"ZRRRRRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRRRC"
BANQUEOPRINCIPAL
    .SB "INICIO BANQUEO**************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "*****************************FIN BANQUEO"
MENSAJESPRINCIPAL
    .SB +128,"                                        "   
AGREGOLOGO
    LDX #19
AGREGOLOGO01
    LDA DATALOGO,X
    STA SHOWPRINCIPAL,X
    DEX
    BPL AGREGOLOGO01
    RTS
RESETER
    JSR AGREGOLOGO
    RTS
;************************************************
;DISPLAY DE INICIO DEL PROGRAMA Y FUNCIONALIDAD
;DIRECTA A TODAS SUS FUNCIONES
;************************************************
DOSPRINCIPAL
	JMP ($0C)
@STARTPRINCIPAL
	JSR DOSPRINCIPAL
STARTPRINCIPAL
    JSR RESETER
    LDX #<DLSPRINCIPAL
    LDY #>DLSPRINCIPAL
    STX $230
    STY $231
    LDA #$60
    STA 710
    STA 712

    JMP *
INICIOPRINCIPAL
    JSR ROMRAM
    JSR MEM
    LDX # <@STARTPRINCIPAL
    LDY # >@STARTPRINCIPAL
    LDA #$03
    STX $02
    STY $03
	STA $09
	LDY #$FF
	STY $08
	INY   
	STY $0244
    JMP STARTPRINCIPAL
    RUN INICIOPRINCIPAL
DATALOGO
    .BY $00,$E4,$EF,$E7,$E4
    .BY $E1,$F2,$EB,$00,$00
    .BY $73,$6F,$66,$74,$77
    .BY $61,$72,$65,$73,$00