.import source ("../variables.asm")
.import source ("variables.asm")

.macro set_lowercase(){
        lda #$12
        sta $e84c 
}

.macro set_uppercase(){
        lda cia2_uppercase
        sta $e84c 
}

.pc = $5000 "disclaimer"
disclaimer:

        
        lda #0 
        sta frame_ticker
     
        jsr clear_screen

        lda $e84c 
        sta cia2_uppercase

        :set_lowercase()

/*
        ldx #0
!:
        lda page_0,x 
        sta screen,x 
        lda page_0+$100,x
        sta screen+$100,x

        lda page_0+$200,x
        sta screen+$200,x

        dex
        bne !-
        */
frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

text_fn:
        jsr show_t
        
        :poll_spacebar()
endstate:      
        nop 
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
        jmp frame


show_t:
        ldx #0 
src:
        lda page_0,x
        bne !+
        jmp finish_text
!:
dst:
        sta screen ,x

        inc show_t+1

        bne !+
        inc src+2
        inc dst+2
!:
        rts

finish_text:
        lda #<wait 
        sta text_fn+1

        lda #>wait 
        sta text_fn+2
        
        rts
wait:
        inc frame_ticker
        lda frame_ticker
        cmp #60
        bne !+

        lda #0 
        sta frame_ticker 

        ldx #0 
dltx:
        lda delay_text,x
        sta screen+$28*20+5,x
        inx 
        cpx #2 
        bne dltx 

        inc dltx+1
        inc dltx+1
        
        inc seconds+1
seconds:
        lda #0 
        cmp #10
        bne !+
        //inc screen
        jsr quit_scene
!:
        rts

quit_scene:
        jsr clear_screen
        :set_uppercase()
        lda #$60 //rts 
        sta endstate
        rts 

.align $100
page_0:
.import source("data/text.asm")

delay_text:
.text "09"
.text "08"
.text "07"
.text "06"
.text "05"
.text "04"
.text "03"
.text "02"
.text "01"
.text "00"

clear_screen:
        ldx #0
        lda #BLANK_PIXEL
!:
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        dex 
        bne !-
        rts

.macro poll_spacebar(){
        lda #9
        ldx #%00000100
        sta $e810
        txa 
        and $e812 
        clc 
        beq test_curs 
        sec 
test_curs:
        bcs !+
        jsr quit_scene
!:
}



