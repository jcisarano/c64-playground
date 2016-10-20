//Another version of the 16-bit count/loop, this time using adc & sec
//This shows the basics of how the carry flag is used in addition/subtraction here.

//For addition, the carry flag will be set when your operation rolls over, that is, when the sum of your numbers is greater than 255
//Here, I'm using bcc to detect that and decide when to increase a high byte, allowing me to have a 16-bit result

//For subtraction, the carry flag must be set before the operation using sec. It is used for borrowing--
//if it is unset after your subtraction, it is time to decrement your high byte, as in the "countdown" section below

BasicUpstart2(main)

                * = $4000 "Main Program"
main:           lda #$00         
                sta $00         		//high byte
                sta $96                 //low byte
                
countup:        clc
                adc #$01                //increment, then save
                sta $96
                bcc nocarry				//carry flag will be set when we roll over from 255 to 256
                inc $00					//this increments the value stored in that memory location
                
                						//compare high bit AND low bit against exit conditions separately
nocarry:		cmp #$39				//I'm doing this one first because it will only match twice, meaning the next couple of lines will be hit less frequently than if I checked the high byte first
				bne	write				//no match, so write the current value to the screen
				cpx #$01
				beq write1				//all conditions match, so go to the other loop to start counting down
                
write:	        lda $00                 //load to A and X
                ldx $96
                jsr $bdcd               //built-in routine writes contents of A and X as 16-bit decimal to current cursor location
                
                lda #$0d                //newline char
                jsr $ffd2               //built-in routine to write an ASCII character from accumulator to cursor location
                
                lda $96                 //that routine seems to jack up the registers, so load them again
                ldx $00
                
                jmp countup           	//loop back and do it all again
                
countdown:      sec						//Important! Set the carry flag before subtracting
                sbc #$01				//decrement then save
                sta $96
				bcs noborrow			//carry flag gets UNSET when we roll down from 256 to 255 -- it is used as a borrow!
				sec						//Important! set the carry for the next subtract
                lda $00					
                sbc #$01				//decrease the high byte and then save it
                sta $00
                
noborrow:       ldx $00					//comparing against exit conditions again
				cpx #$00
                bne write1				//no match, so stay in this loop
                lda $96
                cmp #$00
                beq write				//all conditions met, so jump to the "count up" loop
                
write1:		    lda $00					//same write routine as count up, only with a different exit
                ldx $96
                jsr $bdcd
                
                lda #$0d
                jsr $ffd2
                
                lda $96
                ldx $00
                
                jmp countdown

