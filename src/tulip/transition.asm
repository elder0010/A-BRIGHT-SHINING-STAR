
.const slogan_pos = screen+$28*12+10
.const screen_3_slogan_pos = slogan_pos-screen+tulip_screen3

write_slogan_1:
        ldx slogan_pt
        lda slogan_1,x
        sta slogan_pos,x

        inc slogan_pt 
        lda slogan_pt 
        cmp #20
        bne !+
        lda #0
        sta slogan_pt
        lda #<write_slogan_2
        sta tulip_func+1
        lda #>write_slogan_2
        sta tulip_func+2
!:  
        rts

write_slogan_2:

        ldx slogan_pt
        lda slogan_2,x
        sta slogan_pos+$28,x

        inc slogan_pt 
        lda slogan_pt 
        cmp #21
        bne !+
        dec slogan_pt
slogan_cp: 
        jsr clear_slogan

        inc slgdl+1
slgdl:
        lda #0 
wtdl:
        cmp #SLOGAN_WAIT_ON_SCREEN_TIME
        bne !+

callback_lo:
        lda #<write_slogan_1
        sta tulip_func+1
callback_hi:
        lda #>write_slogan_1
        sta tulip_func+2

        lda #<restore_uppercase
        sta callback_lo+1
        lda #>restore_uppercase
        sta callback_hi+1

        lda #0 
        sta slgdl+1
        lda #1 
        sta wtdl+1


        lda #0 
        sta slogan_pt
!:  
        rts


restore_uppercase:
        :set_uppercase()

        inc fxdl+1
fxdl:
        lda #0 
        cmp #SLOGAN_DELAY_AFTER_FADEOUT
        bne !+
        lda #<scroll_tulip 
        sta tulip_func+1

        lda #>scroll_tulip
        sta tulip_func+2
!:
        rts 

clear_slogan:
        //copy slogan to screen 3 buffer
        ldx #0 
        lda #$20 
lpslg:
        sta slogan_1,x 
        sta slogan_2,x 
        inx 
        cpx #20 
        bne lpslg 
        lda #$2c //bit 
        sta slogan_cp
        rts 



slogan_1:
.text "You don't need power"

slogan_2:
.text "when you have style. "