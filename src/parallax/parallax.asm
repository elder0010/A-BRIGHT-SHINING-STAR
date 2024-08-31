.import source("../variables.asm")
.import source("variables.asm") 

.pc = $5000 "parallax start"
parallax:
        jsr draw_frame
        jmp parallax_transition_main
post_transition_p:
        jsr draw_square_definition

        lda #0 
        sta scroll_tick
        lda #0
        sta l0_frame_sel
        sta l0_scroll_pt
        
        sta background_y_pt
        sta background_frame_pt
        lda #1
        sta background_y

        lda #$7 
        sta l0_parallax_pt

        lda #$31
        sta sprite_movement_pt
framep:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

p_state:
        jsr scroll_l0

bg_fn:
        jsr fade_chessboard //wil become scroll_background
      //  bit scroll_background
fr_fn:
        jsr scroll_foreground 

fad_out_fn:
        bit fade_out_parallax

        //handle effect timing
        inc tim_lo+1
tim_lo:
        lda #0 
        bne !+ 
        inc tim_hi+1
tim_hi:
        lda #0 
        cmp #PARALLAX_FX_LEN 
        bne !+
        lda #$20
        sta fad_out_fn
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
.pc = * "break qui"
parallax_end_addr: 
        jmp framep

.import source "data/foreground_sin.asm"
.import source "data/foreground_sprite.asm"
.import source "data/background_y_sin.asm"
.import source "data/background_sprite.asm"
.import source "data/square_lines.asm"
.import source "transition.asm"
.import source("functions.asm")

.pc = layer_0_lut_even "Lut tmp space"
.fill $150,0