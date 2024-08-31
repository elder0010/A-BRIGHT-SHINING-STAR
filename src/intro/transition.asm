clear_screen:
        lda #$60
        ldx #$0
!:
        sta screen,x
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        dex
        bne !-
        rts

.macro scroll_left_right(start, lines, amount){
        ldx #amount
!:
    .for(var y=0;y<lines;y++){
        lda [$28*y]+start-1,x
        sta [$28*y]+start,x
    }
        dex
        bne !-
}

.macro scroll_right_left(start, lines, amount){
        ldx #amount
!:
    .for(var y=0;y<lines;y++){
        lda [$28*y]+start+1,x
        sta [$28*y]+start,x
    }
        inx
        cpx #$28
        bne !-
}

.macro fetch_line_and_increment(source, dest){
r0: 
        lda source
        sta dest 
        clc 
        lda r0+1
        adc #1 
        sta r0+1
        bcc !+
        inc r0+2
!:
}

.macro fetch_line_and_decrement(source, dest){
r0: 
        lda source
        sta dest 
        sec 
        lda r0+1
        sbc #1 
        sta r0+1
        bcs !+
        dec r0+2
!:
}

intro_transition:
        lda #0 
        inc intro_transition+1
        cmp #INTRO_SCROLL_DELAY 
        beq !+
        rts
!:
        lda #0 
        sta intro_transition+1
//--------------------------------------------------------------------------------   
can_scroll_p0:
        lda #1 
        bne !+
        jmp skip_p0
!:
        :scroll_left_right(screen,4,$27)
        :scroll_left_right(screen+[4*$28],6,7)
        

        .for(var y=0;y<11;y++){
            :fetch_line_and_decrement(borders_data+$27+[y*$28], screen+[y*$28])
        }

        inc intro_1_ct+1
intro_1_ct:
        lda #0
      //  cmp #$20
        //bne !+
       // inc can_scroll_p1+1
//!:
        cmp #$28
        bne !+
        inc can_scroll_p1+1
        dec can_scroll_p0+1     
!:
skip_p0:
//--------------------------------------------------------------------------------   
can_scroll_p1:
        lda #0
        bne !+
        jmp skip_p1
!:
        //disabled to avoid glitches - needs rework
      //  :scroll_right_left(screen+$28*12,9,4)

        :scroll_right_left(screen+$28*12,9,$21)

        .for(var y=11;y<20;y++){
           :fetch_line_and_increment($20+borders_data+[y*$28], $27+screen+[y*$28])
        }

        inc intro_2_ct+1
intro_2_ct:
        lda #0
        cmp #$8
        bne !+
        dec can_scroll_p1+1
        inc can_scroll_p2+1
        //inc can_fade_in+1
!:

skip_p1:
//--------------------------------------------------------------------------------  
can_scroll_p2:
        lda #0
        bne !+
        jmp skip_p2
!:
        :scroll_left_right(screen+[20*$28],5,$27)
        
        .for(var y=20;y<25;y++){
            :fetch_line_and_decrement(borders_data+$27+[y*$28], screen+[y*$28])
        }

        inc intro_3_ct+1
intro_3_ct:
        lda #0
        cmp #$18
        bne !+
        inc can_fade_in+1
!:
        cmp #$28
        bne !+
        dec can_scroll_p2+1
        //Transition end!!
        lda #<state_main
        sta state_transition+1
        lda #>state_main
        sta state_transition+2
!:

skip_p2:
//--------------------------------------------------------------------------------  
//logo fade in
can_fade_in:
        lda #0
        bne !+
        jmp end_transition
!:
        ldy #0
!:
src_add:
        lda logo,y 
dst_add:
        sta screen+$4*$28,y 
        iny 
        cpy #$28
        bne !-
        clc
        lda src_add+1
        adc #$28
        sta src_add+1
        bcc !+
        inc src_add+2
!:
        clc
        lda dst_add+1
        adc #$28
        sta dst_add+1
        bcc !+
        inc dst_add+2
!:
        inc logo_ct+1
logo_ct:
        lda #0
logo_amt:
        cmp #15 
        bne !+
        dec can_fade_in+1
        inc can_move_rasters+1     
!:
end_transition:
can_move_rasters:
        lda #0 
        beq !+
        jsr move_rasterbars
!:
        rts

