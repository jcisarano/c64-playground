//this is similar to the "rasterbar_alternate_method" except that I have changed the way the counters work
//so they reset separately from each other. By doing that, I can create a rolling color effect
//so that the colors in the raster bar appear to move.

//The bars are nice and solid at the top and bottom on my emulator, set to PAL

//X used as a counter for accessing the color data
//Y used to store the rasterline for checks
//A used to store the current color

//Tweaking the max value for the X register will affect how quickly the colors appear to move, and in what direction.

//How the rolling effect works:
//Let Z be the difference between the start Y and max Y values. If the max X value is less than Z, the bar will 
//appear to roll up. If max X is greater than Z, it will appear to roll down. If they are the same, the colors will stand still.

BasicUpstart2(main)

			* = $4000 "Main Program"

main:		sei

			lda $d011   
			and #$6f		//$6f is 01101111 in binary, zeroes the raster line high bit and also turns off screen (so raster lines are full screen)
			sta $d011		//Using AND with this mask makes sure other bits in this memory location remain unchanged

			ldy #$7a		//first rasterline for the color bar
			ldx #$00		//starting value for x counter
					
loop:		lda colors,x	//load a color value from the data array
			
			cpy $d012		//does the value in y match the current raster position?
			bne *-3			//if not, jump backwards 3 bytes from the current position to do the cpy again
			
			sta $d020		//store a color value from accumulator to the border color
	
			inx				//x is the counter (basically the index if you think of colors as an array)
			iny				//y is the raster line to compare against
			
			cpx #$34		//check the counter to see if all color values have been read yet - try changing this to $32 or $33
			bne next		//if not skip to the rasterline check
			ldx #$00		//if so, reset the counter to zero

next:		cpy #$ad
			bne loop

			nop				//Patience is a virtue! Do nothing until it is safe to set a new color below
			nop				//Without this pause, there will be jitter!
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop

			ldy #$00		//write black to all other raster lines, to serve as the background
			sty $d020		
			ldy #$7a		//reset to the first line		
						
			jmp loop
			
				
colors:
         	.byte $06,$06,$06, $0e,$06,$0e
         	.byte $0e,$06,$0e, $0e,$0e,$03
         	.byte $0e,$03,$03, $0e,$03,$03
         	.byte $03,$01,$03, $01,$01,$03
         	
         	.byte $01,$01,$01, $03,$01,$01
         	.byte $03,$01,$03, $03,$03,$0e
         	.byte $03,$03,$0e, $03,$0e,$0e
         	.byte $0e,$06,$0e, $0e,$06,$0e
         	.byte $06,$06,$06, $06
