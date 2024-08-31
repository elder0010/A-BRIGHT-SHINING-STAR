.import source("../variables.asm")
.import source("variables.asm") 
.pc = $5000 

.macro set_lowercase(){
        lda #$12
        sta $e84c 
}

.macro set_uppercase(){
        lda cia2_uppercase
        sta $e84c 
}

tulip:
        //jsr clear_screen 
        lda #0 
        sta slogan_pt

        lda $e84c 
        sta cia2_uppercase

        :set_lowercase()

        lda #0
        sta gfx_pt

        lda #50
        sta t_sin_pt
tulip_frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
endfx_trigger:
        nop 

tulip_func:
        jsr write_slogan_1
        //jsr scroll_tulip 
tulip_low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-
        jmp tulip_frame

upscroll_tulip: 
        lda t_sin_pt 
        sta gfx_pt 
        dec t_sin_pt
        bne !+
        lda #<sine_scroll_tulip
        sta scroll_tulip+1
        lda #>sine_scroll_tulip
        sta scroll_tulip+2 
!:
        rts 

sine_scroll_tulip: 
        ldx t_sin_pt
        bne !+

        inc scroll_rnds +1
scroll_rnds:
        lda #0 
        cmp #SCROLL_LOOPS
        bne !+
        lda #<downscroll_tulip
        sta scroll_tulip+1
        lda #>downscroll_tulip
        sta scroll_tulip+2
!:
        lda tulip_sin,x 
        sta gfx_pt 
        inc t_sin_pt
        rts 

downscroll_tulip:
        lda t_sin_pt 
        sta gfx_pt 
        inc t_sin_pt
        lda t_sin_pt 
        cmp #51
        bne !+
        lda #$60 //rts 
        sta endfx_trigger
!:
        rts



scroll_tulip:
        jsr upscroll_tulip
    
        lda #0 
        sta screen_pt 

copy_t_line:
        ldx gfx_pt
        lda tulip_addr_lo,x 
        sta gfx_src

        lda tulip_addr_hi,x 
        sta gfx_src+1

        ldx screen_pt
        lda screen_r_addr_lo,x 
        sta gfx_dst 

        lda screen_r_addr_hi,x 
        sta gfx_dst+1

        //copy line
        ldy #8
.for(var x=0;x<23;x++){
        lda (gfx_src),y 
        sta (gfx_dst),y 
        .if(x!=23){
            iny 
        }
}       
        inc gfx_pt
        inc screen_pt
        lda screen_pt
lo_bnd:
        cmp #25
        beq !+
        jmp copy_t_line
!:
        rts

.pc = * "  tulip gfx"
.import source("data/tulip_gfx.asm")

.pc = * "  screen and gfx address tables"
.import source("data/screen_gfx_addr.asm")

.import source("data/sintable.asm")

.import source("transition.asm")