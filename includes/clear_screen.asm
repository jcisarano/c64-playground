init_scr:	ldx #$00
			stx $d020
			stx $d021

			//writes a space character ($20) to each screen location
clear_scr:	lda #$20
			sta $0400,x
			sta $0500,x
			sta $0600,x
			sta $06e8,x

			//sets text color for each screen location ($01 is white).
			//this is different from setting text color at $0286
			lda #$00
			sta $d800,x
			sta $d900,x
			sta $da00,x
			sta $dae8,x
			inx
			bne clear_scr
			
			rts
			