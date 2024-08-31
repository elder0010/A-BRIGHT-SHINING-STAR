
.pc = *" move starfield"
move_starfield:
        ldx #0 
next_star:
        lda #1
        sta can_clear+1

        lda star_enabler,x 
        bne !+
        jmp endmove
!:

        lda starfield_col_status,x 
        bne not_moving
moving:
        inc starfield_positions,x 
        lda starfield_positions,x 
        cmp #25
        bne !+
reached_bottom:
        lda #BLANK_PIXEL
        sta screen+$28*24,x

enable_fadeout:
        lda #0
        beq can_repos 
        dec star_enabler,x 
can_repos:
        lda #$ff 
        sta starfield_positions,x 
        lda #1
        sta starfield_col_status,x 
        jmp endmove
!:
        tay 
        lda screen_stars_addr_lo,y 
        sta starpos+1
        sta blank_check+1

        lda screen_stars_addr_hi,y 
        sta starpos+2
        sta blank_check+2

        lda #BLANK_PIXEL
        sta clearval+1
blank_check:
        lda $ffff,x
        cmp #BLANK_PIXEL
        bne storestar 
special_clear:
        sta clearval+1
storestar:
        lda #STAR
starpos:
        sta $ffff,x 
nostore:

//--------------------clear
        lda starfield_positions,x 
        beq endmove
can_clear:
        lda #1
        beq endmove  
        lda starpos+1 
        sec
        sbc #$28 
        sta clearpos+1

        lda starpos+2
        sta clearpos+2
        bcs nodec
        dec clearpos+2
nodec:

clearval:
        lda #BLANK_PIXEL
clearpos:
        sta $ffff,x 
        jmp endmove
not_moving:
        inc starfield_delay,x 
        bne endmove
        dec starfield_col_status,x 

        lda starfield_delay_ori,x 
        adc rand_jitter,x
        sta starfield_delay,x 
endmove:
        inx 
        cpx #$28
        beq !+
        jmp next_star
!:
        rts

starfield_positions:
.fill $28,$ff       

starfield_delay_ori:
.var starfield_delay_list = List().add($0b,$7f,$a1,$43,$9b,$15,$bf,$35,$99,$63,$47,$23,$af,$29,$ad,$8d,
$1d,$7b,$2d,$cd,$77,$17,$0d,$83,$07,$51,$61,$b7,$45,$35,$93,$c5,
$2b,$85,$3b,$7f,$a5,$79,$bb,$9f)
.for (var x=0;x<starfield_delay_list.size();x++){
    .byte starfield_delay_list.get(x)
}

.pc = * "starfield delay"
starfield_delay:
.for (var x=0;x<starfield_delay_list.size();x++){
    .byte starfield_delay_list.get(x)
}

starfield_col_status:
.for(var x=0;x<$29;x++){
    .byte 1
}

.pc = * "random jitter"
.var jitter_list = List().add( 5,24,33, 1,21,17,27,20,10,19,32,40,14,35,38, 2,25,11,15, 8,31,22, 7,12,28,29,36,37, 4,23,39,13,30,18,26,34, 6,16, 3, 9
)
rand_jitter:
.for (var x=0;x<jitter_list.size();x++){
    .byte jitter_list.get(x)
}

star_enabler:
.for(var x=0;x<$28;x++){
    .byte 1
}

