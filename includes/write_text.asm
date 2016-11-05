//writes two lines of text to the center of the screen
//assumes lines to be $3f (40) characters long
//text lines have var names line1 and line2

//TODO: generic solution that allows caller to set location and also prints an arbitrary number of lines


write_text:		ldx #$0
loop_text:		lda line1,x
				and #$3f		//only needed if the text has caps, without this they are printed as garbage
				sta $0590,x
				lda line2,x
				and #$3f
				sta $05e0,x

				inx
				cpx #$28
				bne loop_text

				rts

