parallax_transition_main:

frame_trans:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
ptrans_fn:
        jsr draw_frame 
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
next_frame_jmp: 
        jmp frame_trans

.const offset_top = 12*$28
draw_frame:
        ldx #$27
!:
pixel_ch:
        lda #PIXEL_DITHER //horizontal line
scrln0:
        sta screen+offset_top,x
scrln1:
        sta $28+screen+offset_top,x
        dex 
        bpl !-

        lda scrln0+1
        sec 
        sbc #$28 
        sta scrln0+1
        bcs !+
        dec scrln0+2
!:

        lda scrln1+1
        clc 
        adc #$28 
        sta scrln1+1
        bcc !+
        inc scrln1+2
!:
        inc scrollct+1
scrollct:
        lda #0 
scrollamt:
        cmp #11
        bne !+
next_fn_lo:
        lda #<draw_borders 
        sta ptrans_fn+1
next_fn_hi:
        lda #>draw_borders
        sta ptrans_fn+2
!:
        rts

draw_borders: 
        ldx #$0
!:
        lda #PIXEL_WHITE //horizontal line
        sta screen+[parallax_margin_top*$28],x
        sta screen+[[parallax_height+parallax_margin_top]*$28],x
        dex 
        bpl !-

        inc draw_borders+1
        lda draw_borders+1
        cmp #$28
        bne !+
        dec draw_borders+1

        lda #PIXEL_BLACK
        sta pixel_ch+1

        lda #$9
        sta scrollamt+1

        lda #0 
        sta scrollct+1

        lda #<nothing 
        sta next_fn_lo+1
        lda #>nothing
        sta next_fn_hi+1

        lda #<draw_frame 
        sta ptrans_fn+1
        lda #>draw_frame
        sta ptrans_fn+2

        lda #<screen+offset_top
        sta scrln0+1

        lda #>screen+offset_top
        sta scrln0+2

        
        lda #<$28+screen+offset_top
        sta scrln1+1

        lda #>$28+screen+offset_top
        sta scrln1+2
!:
        rts 

nothing: 
        lda #<post_transition_p
        sta next_frame_jmp+1

        lda #>post_transition_p
        sta next_frame_jmp+2
        rts

fade_chessboard:
        ldx #$0
        lda #0 

!:  
        lda layer_0_lut_even_tmp,x 
        sta layer_0_lut_even,x 

        lda layer_0_lut_odd_tmp,x 
        sta layer_0_lut_odd,x
        inx
ch_size:
        cpx #$1
        bne !- 

        //inc ch_size+1
        clc
        lda ch_size+1
        adc #$3 
        sta ch_size+1
        cmp #$40
        bmi !+
        lda #<scroll_background
        sta bg_fn+1
        lda #>scroll_background
        sta bg_fn+2    
!:
        //lda fade_chessboard+1
        rts

fade_out_parallax:
//foreground
        clc 
        lda fg_lg_amt+1
        adc #1 
        sta fg_lg_amt+1
        cmp #14
        bne !+
        //halt the frame change + movement on the bg 
        lda #0 
        sta can_change_frame+1

        lda #<chess_fd
        sta fr_fn+1
        lda #>chess_fd
        sta fr_fn+2
!:
        rts

//chessboard 
chess_fd:
        lda #PIXEL_BLACK
ltad0:
        sta layer_0_lut_even+$80
ltad1:
        sta layer_0_lut_odd+$80

        sec 
        lda ltad0+1
        sbc #1 
        sta ltad0+1
        bcs !+
        dec ltad0+2
!:
        sec
        lda ltad1+1
        sbc #1 
        sta ltad1+1
        bcs !+
        dec ltad1+2
!:
        inc frametk+1
frametk:
        lda #$0
        cmp #$82
        bne !+
     
        lda #<clear_final_pr
        sta fr_fn+1
        lda #>clear_final_pr
        sta fr_fn+2
!:
        rts

clear_final_pr:
        ldy #$ff 
        dey
        bne *-1

        lda #PIXEL_BLACK 
fpt0:
        ldx #$0
!: 
        sta screen+[parallax_margin_top*$28],x
        sta screen+[[parallax_height+parallax_margin_top]*$28],x

        //lda #PIXEL_DITHER
        sta screen+[parallax_margin_top*$28]+$28,x
        sta screen+[[parallax_height+parallax_margin_top]*$28]-$28,x 
        dex
        bpl !-

        inc fpt0+1
        lda fpt0+1
        cmp #$28 
        bne !+
        lda #$2c //BIT
        sta fr_fn
        
        lda #$60 
        sta parallax_end_addr 
     
!:
        rts