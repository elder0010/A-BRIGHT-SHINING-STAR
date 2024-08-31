
.pc = *" move starfield"
move_starfield_bg:

        inc delayer_half+1
delayer_half:
        lda #0 
        cmp #2
        beq !+
        rts
!:
        lda #0 
        sta delayer_half+1

        ldx #2 
next_star_bg:
        lda #1
        sta can_clear_bg+1

        lda star_enabler_bg,x 
        bne !+
        jmp endmove_bg
!:

        lda starfield_col_status_bg,x 
        bne not_moving_bg
moving_bg:
        inc starfield_positions_bg,x 
        lda starfield_positions_bg,x 
        cmp #25
        bne !+
reached_bottom_bg:
        lda #BLANK_PIXEL
        sta screen+$28*24,x

enable_fadeout_bg:
        lda #0
        beq can_repos_bg 
        dec star_enabler_bg,x 
        inc final_star_counter
        lda final_star_counter
        cmp #$21
        bne can_repos_bg

        //scene quit
        lda #$60 //rts 
        sta endstate
       
can_repos_bg:
        lda #$ff 
        sta starfield_positions_bg,x 
        lda #1
        sta starfield_col_status_bg,x 
        jmp endmove_bg
!:
        tay 
        lda screen_stars_addr_lo,y 
        sta starpos_bg+1
        sta blank_check_bg+1

        lda screen_stars_addr_hi,y 
        sta starpos_bg+2
        sta blank_check_bg+2

        lda #BLANK_PIXEL
        sta clearval_bg+1
blank_check_bg:
        lda $ffff,x
        cmp #BLANK_PIXEL
        bne storestar_bg 
special_clear_bg:
        sta clearval+1
storestar_bg:
        lda #DOT
starpos_bg:
        sta $ffff,x 
nostore_bg:

//--------------------clear
        lda starfield_positions_bg,x 
        beq endmove_bg
can_clear_bg:
        lda #1
        beq endmove_bg  
        lda starpos_bg+1 
        sec
        sbc #$28 
        sta clearpos_bg+1

        lda starpos_bg+2
        sta clearpos_bg+2
        bcs nodec_bg
        dec clearpos_bg+2
nodec_bg:

clearval_bg:
        lda #BLANK_PIXEL
clearpos_bg:
        sta $ffff,x 
        jmp endmove_bg
not_moving_bg:
        inc starfield_delay_bg,x 
        bne endmove_bg
        dec starfield_col_status_bg,x 

        lda starfield_delay_ori_bg,x 
        adc rand_jitter_bg,x
        sta starfield_delay_bg,x 
endmove_bg:
        inx 
        cpx #$26
        beq !+
        jmp next_star_bg
!:
        rts

starfield_positions_bg:
.fill $28,$ff       

starfield_delay_ori_bg:
.var starfield_delay_list_bg = List().add($8d,
$1d,$7b,$2d,$cd,$77,$17,$0d,$83,$07,$51,$61,$b7,$45,$35,$93,$c5,
$2b,$85,$3b,$7f,$a5,$79,$bb,$9f,$0b,$7f,$a1,$43,$9b,$15,$bf,$35,$99,$63,$47,$23,$af,$29,$ad)
.for (var x=0;x<starfield_delay_list_bg.size();x++){
    .byte starfield_delay_list_bg.get(x)
}

.pc = * "starfield delay"
starfield_delay_bg:
.for (var x=0;x<starfield_delay_list_bg.size();x++){
    .byte starfield_delay_list_bg.get(x)
}

starfield_col_status_bg:
.for(var x=0;x<$29;x++){
    .byte 1
}

.pc = * "random jitter"
.var jitter_list_bg = List().add( 5,24,33, 1,21,17,27,20,10,19,32,40,14,36,37, 4,35,38, 2,25,11,15, 8,31,22, 7,12,28,29,23,39,13,30,18,26,34, 6,16, 3, 9
)
rand_jitter_bg:
.for (var x=0;x<jitter_list.size();x++){
    .byte jitter_list.get(x)
}

star_enabler_bg:
.for(var x=0;x<$28;x++){
    .byte 1
}

