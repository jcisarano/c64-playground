//this is the same loop as 16_bit_loop, but I have used tokens in place of memory addresses to store the counter

//write numbers to screen at current cursor location using built-in routine
//also, testing a counter for a loop that will go past 255

BasicUpstart2(main)

                * = $4000 "Main Program"
main:           lda #$00                //high byte         
                sta counter_low         
                ldx #$00                //low byte
                stx counter_high
                
loop:           inx                     //how about adding an 8-bit number to a 16-bit number
                stx counter_high
                cpx #$00
                bne nocarry
                lda #$01                //hard code it, as we know the desired endpoint
                sta counter_low
                
nocarry:        cmp #$01                //compare high bit/low bit against exit conditions
                bne nomatch
                cpx #$39
                beq end
                
nomatch:        lda counter_low                 //load to A and X
                ldx counter_high
                jsr $bdcd               //built-in routine writes contents of A and X as 16-bit decimal to current cursor location
                
                lda #$0d                //newline char
                jsr $ffd2               //built-in routine to write an ASCII character from accumulator to cursor location
                
                lda counter_low                 //that routine seems to jack up the registers, so load them again
                ldx counter_high
                jmp loop              
                
end:            rts

counter_low:	.byte 0
counter_high:	.byte 0