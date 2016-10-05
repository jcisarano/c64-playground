//a counter for a loop that will start above 255 and go down to zero
//writes each number to the screen on its own line

//it is sort of cheaty, since it only works for the case I want: counting down from about 312 to 1
//By the way, 312 is the number of raster lines on a PAL screen

BasicUpstart2(main)

                * = $4000 "Main Program"
main:           lda #$01                //high byte         
                sta $00         
                ldx #$39                //low byte
                stx $96
                
loop:           dex                     //decrements the low byte
                stx $96
                cpx #$ff                //it may seem weird, but this checks for the rollover: 1,0,255...
                bne nocarry             //branch if there is no need to change the high byte
                lda #$00                //hard code it, as we know the starting point and desired endpoint
                sta $00
                
nocarry:        cmp #$00                //compare high bit/low bit against exit conditions
                bne nomatch
                cpx #$01
                beq end
                
nomatch:        lda $00                 //load to A and X
                ldx $96
                jsr $bdcd               //built-in routine writes contents of A and X as 16-bit decimal to current cursor location
                
                lda #$0d                //newline char
                jsr $ffd2               //built-in routine writes an ASCII character from accumulator to cursor location
                
                lda $00                 //the built-ins seem to jack up the registers, so load them again before the next loop
                ldx $96
                jmp loop              
                
end:            rts