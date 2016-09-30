				lda colormodeflag
				beq colormode1
				jmp colormode2
			
				//colormode1 sets the static background color
				//that seems to get "filled" by the other color
colormode1:		lda #$01
				sta colormodeflag
			
				lda #$01
				sta $d020
			
				lda #$00
				sta $d012
			
				lda $d019
				sta $d019
			
				jmp $ea31			//first irq, jump back to the system
			
				//colormode2 is the one that fills the screen
colormode2:		lda #$00
				sta colormodeflag
			
				lda startline
				sta $d020
			
				//skip a few frames to slow down the fill rate
				ldx counter	
				inx
				stx counter
				cpx #$03		//tweak this number to increase/decrease the fill rate
				bne continue
				ldx #$00
				stx counter
				
				//get the current interrupt line, decide whether we need to count up or down
				ldx rasterline
				lda fillmodeflag
				bne drain_scr
				
fill_scr:		inx						//fill screen counts up
				stx rasterline
				cpx #$fe
				bne continue
				lda #$01
				sta fillmodeflag
				jmp continue
				
drain_scr:		dex						//drain screen counts down
				stx rasterline
				cpx startline
				bne continue
				lda #$00
				sta fillmodeflag				

continue:		ldx rasterline			//store the next interrupt line and move on
				stx $d012
			
		 		lda $d019				//can't this be done with just dec?
				sta $d019
			
				pla						//restore the stack to the registers after the second irq
				tay
				pla
				tax
				pla
				rti						//no need to go back to the system this time, just return

//set up flags and counters
fillmodeflag:	.byte 0
colormodeflag:	.byte 0
counter:		.byte 0
rasterline:		.byte 8
startline:		.byte 5
maxline:		.byte 254