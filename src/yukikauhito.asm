
	; INESヘッダー
	.inesprg 1
	.ineschr 1
	.inesmir 0
	.inesmap 0

	.bank 1
	.org $FFFA

	.dw 0
	.dw Start
	.dw 0

	.bank 0
	.org $0000
	X_Pos   .db 0	 ; スプライトX座標の変数($0000)
	Y_Pos   .db 0	 ; スプライトY座標の変数($0001)
	X_Pos2  .db 0	 ; スプライトX座標の変数($0002)
	Y_Pos2  .db 0	 ; スプライトY座標の変数($0003)
	X_Pos3  .db 0	 ; スプライトX座標の変数($0004)
	Y_Pos3  .db 0	 ; スプライトY座標の変数($0005)
	X_Pos4  .db 0	 ; スプライトX座標の変数($0006)
	Y_Pos4  .db 0	 ; スプライトY座標の変数($0007)
	X_Pos5  .db 0	 ; スプライトX座標の変数($0008)
	Y_Pos5  .db 0	 ; スプライトY座標の変数($0009)

	.org $8000
Start:

	sei
	cld
	ldx #$ff
	txs

	; PPUコントロールレジスタ1初期化
	lda #%00001000
	sta $2000


	lda $2002
	bpl Start

	; PPUコントロールレジスタ初期化
	lda #%00001000 
	sta $2000
	lda #%00000110
	sta $2001

	ldx #$00

	lda #$3F
	sta $2006
	lda #$00
	sta $2006

loadPal:
	lda tilepal, x

	sta $2007

	inx

	cpx #32
	bne loadPal

	; スプライト座標初期化
	lda X_Pos_Init
	sta X_Pos
	lda Y_Pos_Init
	sta Y_Pos
	lda X_Pos_Init2
	sta X_Pos2
	lda Y_Pos_Init2
	sta Y_Pos2
	lda X_Pos_Init3
	sta X_Pos3
	lda Y_Pos_Init3
	sta Y_Pos3
	lda X_Pos_Init4
	sta X_Pos4
	lda Y_Pos_Init4
	sta Y_Pos4
	lda X_Pos_Init5
	sta X_Pos5
	lda Y_Pos_Init5
	sta Y_Pos5

	; PPUコントロールレジスタ2初期化
	lda #%00011110
	sta $2001
	; メインループ
mainLoop:
	lda $2002
	bpl mainLoop

	; スプライト描画
	lda #$00
	sta $2003

	lda Y_Pos
	sta $2004

	lda #00
	sta $2004
	sta $2004

	lda X_Pos
	sta $2004

	; スプライト描画2
	lda Y_Pos2
        inc Y_Pos2

	sta $2004

	lda #01
	sta $2004
	sta $2004

	lda X_Pos2
	sta $2004

	; スプライト描画3
	lda Y_Pos3
	sta $2004

	lda #02
	sta $2004
	sta $2004

	lda X_Pos3
        inc X_Pos3
        inc X_Pos3
	sta $2004

	; スプライト描画4
	lda Y_Pos4
	sta $2004

	lda #03
	sta $2004
	sta $2004

	lda X_Pos4
        inc X_Pos4
	sta $2004

	; スプライト描画5
        inc Y_Pos5
	lda Y_Pos5
	sta $2004

	lda #04
	sta $2004
	sta $2004

	lda X_Pos5
	sta $2004
            
	; パッドI/Oレジスタの準備
	lda #$01
	sta $4016
	lda #$00 
	sta $4016

	; パッド入力チェック
	lda $4016
	lda $4016
	lda $4016
	lda $4016
	lda $4016
	and #1
	bne UPKEYdown
	
	lda $4016
	and #1
	bne DOWNKEYdown

	lda $4016
	and #1
	bne LEFTKEYdown

	lda $4016
	and #1
	bne RIGHTKEYdown
	jmp NOTHINGdown

UPKEYdown:
	dec Y_Pos

	jmp NOTHINGdown

DOWNKEYdown:
	inc Y_Pos
	jmp NOTHINGdown

LEFTKEYdown:
	dec X_Pos
	jmp NOTHINGdown 

RIGHTKEYdown:
	inc X_Pos

NOTHINGdown:
        jmp mainLoop

; 初期データ
	X_Pos_Init   .db 20       ; X座標初期値
	Y_Pos_Init   .db 40       ; Y座標初期値
	X_Pos_Init2  .db 100      ; X座標初期値
	Y_Pos_Init2  .db 100      ; Y座標初期値
	X_Pos_Init3  .db 150      ; X座標初期値
	Y_Pos_Init3  .db 130      ; Y座標初期値
	X_Pos_Init4  .db 100      ; X座標初期値
	Y_Pos_Init4  .db 140      ; Y座標初期値
	X_Pos_Init5  .db 150      ; X座標初期値
	Y_Pos_Init5  .db 200      ; Y座標初期値

tilepal: .incbin "giko5.pal"

	.bank 2
	.org $0000

	.incbin "giko5.bkg"
	.incbin "test.spr"
