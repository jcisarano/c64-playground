//simplest version of the fill routine
//it has a loop to count up to 255 to fill the screen with a color, then it resets and fills again

BasicUpstart2(main)

						* = $4000 "Main Program"	
main:					sei
						ldx #$000
						
						jsr init_scr
						jsr init_irq
						
						lda #<irq
						ldx #>irq
						sta $314
						stx $315
							
						cli
						jmp *
			
irq:					lda colormodeflag					//flag will decide which irq routine to use therefore which color to write
						beq colormode1
						jmp colormode2
			
colormode1:				lda #$01							//flip the flag to the other mode
						sta colormodeflag
						
						lda #$01							//the color that will seem to be overwritten
						sta $d020
						
						lda #$00							//line for the NEXT interrupt
						sta $d012
						
						lda $d019							//resets the interrupt flag
						sta $d019
						
						jmp $ea31
			
colormode2:				lda #$00							//flip the flag to the other mode
						sta colormodeflag
						
						lda #$08							//this is the fill color
						sta $d020
						
						ldx counter							//skip a few frames to slow down the fill
						inx
						stx counter
						cpx #$03							//how many frames to skip
						bne continue
						ldx #$00
						stx counter
						
						ldx rasterline						//simple counting routine, increase the raster line to break on
						inx
						stx rasterline

						cpx #$fe							//compare against last line
						bne continue		
						ldx #$05							//reset
						stx rasterline

continue:				ldx rasterline						//store the line for the NEXT interrupt
						stx $d012
						
						lda $d019
						sta $d019
			
						pla
						tay
						pla
						tax
						pla
rti

colormodeflag:			.byte 0
counter:				.byte 0
rasterline:				.byte 8

						#import "includes/clear_screen.asm"
						#import "includes/init_irq.asm"