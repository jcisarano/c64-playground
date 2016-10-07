

BasicUpstart2(main)

                * = $4000 "Main Program"
main:           lda #$00                //high byte         
                sta $00         
                sta $96                 //low byte
                
countup:        clc
                adc #$01                //increment
                sta $96
                bcc nocarry
                ldx $00
                inx                
                stx $00
                
nocarry:        cpx #$01                //compare high bit/low bit against exit conditions
                bne nomatch
                cmp #$39
                beq end
                
nomatch:        lda $00                 //load to A and X
                ldx $96
                jsr $bdcd               //built-in routine writes contents of A and X as 16-bit decimal to current cursor location
                
                lda #$0d                //newline char
                jsr $ffd2               //built-in routine to write an ASCII character from accumulator to cursor location
                
                lda $96                 //that routine seems to jack up the registers, so load them again
                ldx $00
                
                jmp countup           
                
countdown:      sec
                sbc #$01
                sta $96
                lda $00
                sbc #$00
                sta $00
                jmp nocarry
                
                       
                
end:            rts