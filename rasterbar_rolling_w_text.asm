

BasicUpstart2(main)

			* = $4000 "Main Program"

main:		jsr init_scr
			jsr write_text

			sei

			lda $d011   
			and #$7f		//$6f is 01101111 in binary, zeroes the raster line high bit and also turns off screen (so raster lines are full screen)
			sta $d011		//Using AND with this mask makes sure other bits in this memory location remain unchanged

			ldy #$00		//first rasterline for the color bar
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

next:		cpy #$33
			bne loop

			ldy #$08		//Patience is a virtue! Do nothing until the current line is complete and
wait:		dey				//it is safe to set the next color below. Without this pause, there will be jitter!
			bne wait

			ldy #$01		//write black to all other raster lines, to serve as the background
			sty $d020		
			sty $d021	
			ldy #$00		//reset to the first line		
						
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


			#import "includes/clear_screen.asm"
			#import "includes/write_text.asm"

line1:		.text "    doing fx in two thousand one six     "
line2:		.text "  mouthhole says aaaahhhhhhhhhhhhhhhhhhh "