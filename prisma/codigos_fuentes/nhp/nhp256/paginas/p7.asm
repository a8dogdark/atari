;load_init =$CBFE
p7_init =$2000
;
;l_load = [.len loader]

.proc	p7,p7_init
INICIO
	.BY $00,$01
	.WO INICIO,FINAL
	LDX $0230
	LDY $0231
	STX $bffc
	STY $bffd
	LDX #<DLS
	LDY #>DLS
	LDA #$00
	STX $0230
	STX $D402
	STY $0231
	STY $D403
	STA $41
	JMP $0400
	.BY +128,'  Por Parche Negro Soft  '
DLS
:14	.BY $70
	.BY $47
	.WO SHOW
	.BY $41
	.WO DLS
SHOW
	.SB "  --   PRISMA   --  "
FINAL
	LDX $BFFC
	LDY $BFFD
	STX $0230
	STY $0231
	JMP ($0304)
.endp