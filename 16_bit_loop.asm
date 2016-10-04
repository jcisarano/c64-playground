//write numbers to screen at current cursor location using built-in routine
//also, testing a counter for a loop that will go past 255

BasicUpstart2(main)

                * = $4000 "Main Program"
main:           lda #$00                //high byte         
                sta $00         
                ldx #$00                //low byte
                stx $96
                
loop:           inx                     //how about adding an 8-bit number to a 16-bit number
                stx $96
                cpx #$00
                bne nocarry
                lda #$01                //hard code it, as we know the desired endpoint
                sta $00
                
nocarry:        cmp #$01                //compare high bit/low bit against exit conditions
                bne nomatch
                cpx #$39
                beq end
                
nomatch:        lda $00                 //load to A and X
                ldx $96
                jsr $bdcd               //built-in routine writes contents of A and X as 16-bit decimal to current cursor location
                
                lda #$0d                //newline char
                jsr $ffd2               //built-in routine to write an ASCII character from accumulator to cursor location
                
                lda $00                 //that routine seems to jack up the registers, so load them again
                ldx $96
                jmp loop              
                
end:            rts