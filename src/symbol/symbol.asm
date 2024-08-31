.import source ("../variables.asm")
.import source ("variables.asm")

.pc = $5000 "Symbol"
symbol:

        lda #0 
        sta frame_ticker
        sta flash_pt
        sta flash_delay
        sta flash_switcher

        ldx #0
        lda #BLANK_PIXEL
!:
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        dex 
        bne !-
frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

        jsr show_s
endstate:      
        nop 
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   

        jmp frame

show_s:
        ldx flash_pt 
        lda sintable,x 
        sta flash_delay

        inc frame_ticker
        lda frame_ticker
        cmp flash_delay
        beq !+
        rts 
!:
        lda #0 
        sta frame_ticker 
        inc flash_pt 

        lda flash_switcher
        eor #$ff 
        sta flash_switcher
        bne !+
        jsr draw_symbol
        jmp enddraw
!:
        jsr draw_blank
enddraw:
        rts

symbol_on:
.import source("data/symbol_gfx.asm")

.const pos = screen+$28*symbol_y_offs

.pc = *"draw routines"
draw_symbol:
        lda #<pos 
        sta gfx_dst 
        lda #>pos 
        sta gfx_dst+1

        lda #<symbol_on
        sta gfx_src
        lda #>symbol_on
        sta gfx_src+1
        
        ldx #0 
nextline:
        ldy #11
!:
        lda (gfx_src),y 
        sta (gfx_dst),y 
        iny 
        cpy #30
        bne !-

        clc 
        lda gfx_src
        adc #$28 
        sta gfx_src
        bcc !+
        inc gfx_src+1
    !:
        clc 
        lda gfx_dst
        adc #$28 
        sta gfx_dst
        bcc !+
        inc gfx_dst+1
    !:
        inx 
        cpx #15
        beq !+
        jmp nextline
!:
        rts

draw_blank:
        lda #<pos 
        sta gfx_dst 
        lda #>pos 
        sta gfx_dst+1

        lda flash_pt 
        and #$f
        cmp #$f
        bne !+
        inc times+1
times:
        lda #0 
        cmp #NUMBER_OF_LOOPS
        bne !+
        lda #$60 //rts 
        sta endstate
!:

        ldx #0 
       
nextline_c:
        ldy #11
        lda #BLANK_PIXEL
!:
        sta (gfx_dst),y 
        iny 
        cpy #30
        bne !-

        clc 
        lda gfx_dst
        adc #$28 
        sta gfx_dst
        bcc !+
        inc gfx_dst+1
    !:
        inx 
        cpx #15
        beq !+
        jmp nextline_c
!:
        rts

.pc = * "sintable"
.import source("data/flash_sintable.asm")

