

init_irq:	ldy #$7f		//turns off CIA interrupts
			sty $dc0d
			sty $dd0d
			lda $dc0d
			lda $dd0d
			
			lda #$01		//interrupt type set to raster
			sta $d01a
			
			lda #$05
			sta $d012		//init the first interrupt line
			
			lda $d011   
			and #$7f		//$6f is 01101111 in binary, turns off raster line high bit and also screen (so raster lines are full screen)
			sta $d011		//to keep the screen, use 01111111 instead ($7f)
			
			rts