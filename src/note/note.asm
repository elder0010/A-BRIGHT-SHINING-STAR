/**
A bright shining star

2022 G*P
Code: Elder0010
*/
.import source "variables.asm"

*= basic_upstart "[basic upstart]"
.byte $0e,$04,$0a,$00,$9e,$20,$28,$31,$30,$34,$30,$29,$00,$00,$00
start:
        jmp main_code


.pc = * "[main routine]"
 main_code:
        sei
        lda #0 
        sta page_pt

        //lowercase
        lda #$12
        sta $e84c 

        jsr clear_screen
        jsr point_page
        jsr draw_interface
  

frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-


screen_fn:
        jsr write_page

!:
        lda VIA_PORT_B
        and #$20 
        beq !-   

        jmp frame
       
clear_screen:
        lda #$20
        ldx #$0 
!: 
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x 
        sta screen+$300,x 
        dex 
        bne !-
        rts


point_page:
        ldx page_pt
        lda page_addr_lo,x 
        sta page_src+1

        lda page_addr_hi,x 
        sta page_src+2

        lda #<screen 
        sta screen_dst+1

        lda #>screen 
        sta screen_dst+2

        ldx page_pt 
        lda page_nr,x 
        sta screen+$28*24+37  

        inc page_pt 
        lda page_pt
        cmp #7
        bne !+
        lda #0
        sta page_pt
!:
        rts

point_page_prev:
        dec page_pt
        cmp #$ff 
        bne !+
        lda #1 
        sta page_pt
!:

        jmp point_page


page_nr:
.text "1234567"

write_page:
        ldx #$28 
!:
page_src:
        lda $ffff,x
        bne noendp
        jmp ended_pg 
noendp:
screen_dst:
        sta screen,x 

        dex 
        bpl !-

        clc
        lda page_src+1
        adc #$28 
        sta page_src+1
        bcc !+
        inc page_src+2
!:
        clc
        lda screen_dst+1
        adc #$28 
        sta screen_dst+1
        bcc !+
        inc screen_dst+2
!:
        rts

ended_pg:
        lda #<wait_for_spacebar
        sta screen_fn+1
        lda #>wait_for_spacebar
        sta screen_fn+2
        
        rts 
    


wait_for_spacebar:
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
        jsr point_page
        jsr clear_page
        lda #<write_page
        sta screen_fn+1
        lda #>write_page
        sta screen_fn+2
      
!:
        rts 


clear_page:
        lda #$20 
        ldx #$0
clrlp:
        sta screen,x 
        sta screen+$100,x 
        sta screen+$200,x 
        sta screen+$300-[$35*2],x 
        dex 
        bne clrlp

        rts

.import source("data/text.asm")


draw_interface:
     
        ldx #$27
!:
        lda #$e2
        sta screen+$28*23,x 
        lda interface_menu,x 
        sta screen+$28*24,x 
        dex 
        bpl !-
        rts 
interface_menu:
.text "SPACE:next "

.text "                     PAGE 1/7"      