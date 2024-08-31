.import source("../variables.asm")
.import source("variables.asm") 

.pc = $5000 
go_intro:
        //jsr test_real_hw
        pla 
        sta stack_adrr_lo
        pla 
        sta stack_adrr_hi

        tsx 
        stx stack_pt_bk

        jsr clear_screen
        //jsr draw_screen

        lda #0 
        sta scroll_tick
        sta char_pos
        sta bar0_pt

        lda #12
        sta bar1_pt

        lda #18
        sta bar2_pt

        lda #21
        sta bar3_pt

        lda #5
        sta bar4_pt

        lda #10
        sta bar5_pt

        lda #15
        sta bar6_pt

frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
state:
        jmp state_transition
endstate:      
        nop 
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   

        jmp frame
state_transition:
        jsr intro_transition
        
        jmp endstate 

state_main:
        jsr move_rasterbars
main_fn:   
        jsr intro
        jmp endstate


.import source("data/bars_wob.asm")
.pc = * "  chars size"
.import source("data/chars_size.asm")

.pc = * " logo gfx"
logo:
.import source "data/logo.asm"

charset:
.import source "data/charset.asm"

.pc = * "  text"
.import source("data/text.asm")

.pc = * "  borders gfx"
.import source("data/borders.asm")

.pc = * "  transition"
.import source("transition.asm")

.pc = * "  message"
.import source("data/message.asm")

.pc = * "  bar movements"
.import source "bar_movements.asm"

.pc = * "  functions"
.import source "functions.asm"