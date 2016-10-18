//another style of raster line effect that I ran across on codebase64
//I'm looking at changing the colors over time to try and create some different effects

BasicUpstart2(main)

			* = $4000 "Main Program"

main:		sei

			lda $d011   
			and #$6f		//$6f is 01101111 in binary, turns off raster line high bit and also screen (so raster lines are full screen)
			sta $d011		//to keep the screen, use 01111111 instead ($7f)
			ldy #$7a
			
init:		ldy #$7a		//starting rasterline value
			ldx #$00		//starting value for x counter
					
loop:		lda colors,x	//load a color value from the data array

			cpy $d012		//does the value in y match the current raster position?
			bne *-3			//if not, jump backwards 3 bytes from the current position to do the cpy again
			
			sta $d020		//store a color value from accumulator to the border color
			//sta $d021
			
			//cpy #$ae
			//bne next
			//ldy #$7a
			
next:		cpx #$34		//check the counter to see if all values have been read yet
			beq init
			
			inx				//x is the counter (basically the index if you think of colors as an array)
			iny				//y is the raster line to compare against
			
			cpy #$ae
			bne loop
			ldy #$7a
			
			jmp loop
			
colors:
         	.byte $06,$06,$06,$0e,$06,$0e
         	.byte $0e,$06,$0e,$0e,$0e,$03
         	.byte $0e,$03,$03,$0e,$03,$03
         	.byte $03,$01,$03,$01,$01,$03
         	.byte $01,$01,$01,$03,$01,$01
         	.byte $03,$01,$03,$03,$03,$0e
         	.byte $03,$03,$0e,$03,$0e,$0e
         	.byte $0e,$06,$0e,$0e,$06,$0e
         	.byte $06,$06,$06,$00
         	
         	.byte $06,$06,$06,$0e,$06,$0e
         	.byte $0e,$06,$0e,$0e,$0e,$03
         	.byte $0e,$03,$03,$0e,$03,$03
         	.byte $03,$01,$03,$01,$01,$03
         	.byte $01,$01,$01,$03,$01,$01
         	.byte $03,$01,$03,$03,$03,$0e
         	.byte $03,$03,$0e,$03,$0e,$0e
         	.byte $0e,$06,$0e,$0e,$06,$0e
         	.byte $06,$06,$06,$00      	