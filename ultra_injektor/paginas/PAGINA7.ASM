//	icl "../base/sys_equates.m65"


l_pag7=[.len pagina7]

.proc pagina7,$2000
INICIO 
	.BYTE $00
	.byte [l_pag7+127]/128
	.WORD INICIO,FIN7
	JSR KEM7
	LDX $230	;SDLSTL
	LDY $231	;SDLSTL+1
	STX $BFFC
	STY $BFFD
	LDX # <DLIST
	LDY # >DLIST
	LDA #$00
	STX $230	;SDLSTL
	STX $d402	;DLISTL
	STY $231	;SDLSTL+1
	STY $d403	;DLISTL+1
;	STA $41
	jsr INJK7
	ldx #$90
	ldy #$00
	jsr PAUSA7
	JMP $400
KEM7        
	ldx #$C0
	ldy #$00
	sei
	sty $D40E
	stx $CC
	sty $CB
LOOP7       
	lda ($CB),Y
	dec $D301
	sta ($CB),Y
	inc $D301
	iny
	bne LOOP7
	inc $CC
	beq EXIT7
	lda $CC
	cmp #$D0
	bne LOOP7
	lda #$D8
	sta $CC
	bne LOOP7
EXIT7       
	dec $D301
	cli
	sec
	lsr $D40E
	rts
INJK7       
	ldx #$17
?INJK7      
	lda FINAL7,X
	sta $ED3D,X
	dex
	bpl ?INJK7
	lda #$12
	sta $EBE2
	lda #$60
	sta $FDFC
	lda #$04
	sta $2A
	lda #$80
	sta $2B
	lda #$0C
	sta $02FC
	ldx $62
	lda #$01
	sta $FE93,X
	lda #$00
	sta $FE91,X
	ldx #$10
	jmp $FCE6
FINAL7      
	.by $8F,$06,$D2,$8F,$31,$00
	.by $8F,$0F,$D2,$18,$EB,$27
	.by $AA,$8F,$04,$D2,$AF,$32
	.by $02,$8F,$0F,$D2,$18,$60
PAUSA7      
	stx $021C
	sty $021D
?PAUSA7     
	lda $021C
	ora $021D
	bne ?PAUSA7
	rts
DLIST
	.BY $70,$70,$70,$70,$70,$70,$70,$70
	.BY $70,$70,$70,$70,$70,$46
	.WORD SHOW
	.BY $70,$06,$41
	.WORD DLIST
SHOW
TITLOP7
	.SB "--ACA VA EL TITULO--"
TITLO2P7
	.SB "--ACA VA EL TITULO--"
fin7
	jmp ($0304)
;LOOPCITO
	;JMP LOOPCITO
	.SB "AGRADEZCO AL TIO PARCHE POR"
	.SB " DONAR EL CODIGO FUENTE Y A ASCRNET "
	.SB "POR LA AYUDA, HTTP://DOGDARK.CL"
FIN
.endp