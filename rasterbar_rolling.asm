//this is similar to the "rasterbar_alternate_method" except that I have changed the way the counters work
//so they reset separately from each other. By doing that, I create a rolling color effect
//so that the color bars appear to move. The only problem with it is the jitter in the last line.

//Tweaking the max value for the X register will affect how quickly the colors appear to move, and in what direction.

BasicUpstart2(main)

			* = $4000 "Main Program"

main:		sei

			lda $d011   
			and #$6f		//$6f is 01101111 in binary, turns off raster line high bit and also screen (so raster lines are full screen)
			sta $d011		//to keep the screen, use 01111111 instead ($7f)

			ldy #$7a		//first rasterline for the color bar
			ldx #$00		//starting value for x counter
					
loop:		lda colors,x	//load a color value from the data array

			cpy $d012		//does the value in y match the current raster position?
			bne *-3			//if not, jump backwards 3 bytes from the current position to do the cpy again
			
			sta $d020		//store a color value from accumulator to the border color
			//sta $d021		//if you don't turn off the screen above, this will write your color bars there, too.
			
increment:	inx				//x is the counter (basically the index if you think of colors as an array)
			iny				//y is the raster line to compare against
			
			cpx #$35		//check the counter to see if all values have been read yet -- this is where the "rolling" effect is created
			bne next
			ldx #$00

next:		cpy #$ae
			bne loop
			ldy #$00		//write black to all other raster lines, to serve as the background
			sty $d020		
			ldy #$7a		//reset to the first line
			
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
         	.byte $06,$06,$06
