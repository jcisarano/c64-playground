//Super simple raster bar that fills the screen from top to bottom then empties it from bottom to top.

//TODO: Fix the jitter! Fill the whole screen!

//entry point, sets up the screen & interrupt and drops the "fill and drain" function into the irq

BasicUpstart2(main)

			* = $4000 "Main Program"	
main:		sei
			ldx #$000

			jsr init_scr
			jsr init_irq
			
			lda #<irq
			ldx #>irq
			sta $314
			stx $315
			
			lda #$05
			sta $d012
					
			cli
			jmp *
			
irq:			
			#import "includes/fill_and_drain.asm"
			rti


			#import "includes/clear_screen.asm"
			#import "includes/init_irq.asm"