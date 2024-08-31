glitch_img:
        lda #0 
        sta line_pt

        lda #<background_img
        sta src_bt+1

        lda #>background_img
        sta src_bt+2

        lda #<screen
        sta dst_bt+1

        lda #>screen
        sta dst_bt+2
         
nxt_line:
        ldx sin_pt 
        lda $4a00,x 
        tax 

        clc 
        adc #40 
        sta ofsmrg+1
        ldy #0
rowcp:
src_bt:
        lda background_img,x 
dst_bt:
        sta screen,y 
        inx 
        iny 
ofsmrg:
        cpx #80
        bne rowcp

        clc 
        lda src_bt+1
        adc #[80+$28]
        sta src_bt+1
        bcc !+
        inc src_bt+2
!:
        clc 
        lda dst_bt+1
        adc #$28
        sta dst_bt+1
        bcc !+
        inc dst_bt+2
!:
        inc line_pt
        lda line_pt
        tax
        and #$7
        bne !+
        inc sin_pt
!:  
        txa
        cmp #25
        beq !+
        jmp nxt_line
!:
        rts 

.var screen_lines = List()
.for(var x=0;x<25;x++){
    .eval screen_lines.add(screen+[x*$28])
}

screen_addr_lo:
.for(var x=0;x<screen_lines.size();x++){
    .byte <screen_lines.get(x)
}

screen_addr_hi:
.for(var x=0;x>screen_lines.size();x++){
    .byte >screen_lines.get(x)
}

glitch_frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

        inc glitchtk+1
glitchtk:
        lda #0
        cmp #GLITCH_DURATION
        bne !+
        lda #<wait_before_quit
        sta glitch_fn+1
        lda #>wait_before_quit
        sta glitch_fn+2     
!:

low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
glitch_fn:
        jsr glitch_img

endstate:      
        nop 
        jmp glitch_frame

wait_before_quit:
        lda #0 
        cmp #STILL_TIME
        bne !+

        lda #$60
        sta endstate

        sei      
!:
        inc wait_before_quit+1
        rts 