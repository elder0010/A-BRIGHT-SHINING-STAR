sinebars_transition:
 
framex:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

!:
        lda VIA_PORT_B
        and #$20 
        beq !-  

        jsr logo_appear 
jmp_t_adr:
        jmp framex 

quit_trans:
       
        rts

logo_appear:

drw_logot:
        lda #0 
        beq !+
        jmp logot_finished
!:

        ldx #$0
        ldy #$0
!:
logot_src:
        lda s_bg,x 
logot_dst:
        sta logo_pos,y

        iny
        inx
logot_end:        
        cpx #$28
        bne !-

        clc 
        lda logot_src +1 
        adc #$28
        sta logot_src+1
        bcc !+
        inc logot_src+2
!:
        clc 
        lda logot_dst +1 
        adc #$28
        sta logot_dst+1
        bcc !+
        inc logot_dst+2
!:

        inc logo_rw+1
logo_rw:
        lda #0 
        cmp #5
        bne !+
        inc drw_logot+1
        /*
        lda #<quit_trans 
        sta jmp_t_adr+1
        lda #>quit_trans 
        sta jmp_t_adr+2
        */
        
!:

logot_finished:

        lda #$e0 
        ldx #$27 
!: 
mscr:
        sta screen+$27 + [$28*23],x 
        dex 
        cpx #x_mrg+8
        bne !-

        sec 
        lda mscr+1
        sbc #$28 
        sta mscr+1
        bcs !+
        dec mscr+2
!:
        inc pad_fct+1
pad_fct:
        lda #0  
        cmp #24 
        bne !+
 
        lda #<quit_trans 
        sta jmp_t_adr+1
        lda #>quit_trans 
        sta jmp_t_adr+2
!:
        rts

wait_frames:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-  

!:
        lda VIA_PORT_B
        and #$20 
        bne !-

        inc fctx+1
fctx:
        lda #0 
delwt:
        cmp #$58
        bne wait_frames    
        rts