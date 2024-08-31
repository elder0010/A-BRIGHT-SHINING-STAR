write_greetz:
         inc frame_tick+1
frame_tick:
        lda #0
        cmp #GREETZ_DELAY
        bne !+
greetz_fn:
        lda #0 
        sta frame_tick+1
        jmp write
!:
        rts
write:
        jsr clear_text_area

//write credits
        ldx #0 
greetz_adr:        
        lda greetz,x 
        beq !+
        sta credits_line_1-3,x 
        inx 
        jmp greetz_adr
!:
//offset credits read
        inx 
        clc 
        txa
        adc greetz_adr+1 
        sta greetz_adr+1
        bcc !+
        inc greetz_adr+2
!:

//check for end list
        inc greetz_ct+1
greetz_ct:
        lda #0 
        cmp #greetz_list.size()
        bne !+
        lda #<final_wait 
        sta text_fn+1
        lda #>final_wait 
        sta text_fn+2
      //  jsr clear_text_area         
!:
        rts

clear_text_area:
        //clear credits line
        ldx #20
        lda #PIXEL_BLACK
!:
        sta credits_line_1-3,x
        dex 
        bpl !-
        rts

post_greetz:
        rts

.const blank_up = "                  "
.const blank_down = "                     "
.var credits_line1_data = List().add("elder0010","elder0010",blank_up,"lrnz","lrnz",blank_up)
//.var credits_line2_data = List().add(blank_down,"      code, graphics",blank_down,blank_down,"      pecbm graphics",blank_down)

.var credits_line2_data = List().add(blank_down,"   code, graphics    ",blank_down,blank_down,"   pecbm graphics",blank_down)


write_credits:
         inc frame_tick0+1
frame_tick0:
        lda #0
        cmp #CREDITS_DELAY
        bne !+
        lda #0 
        sta frame_tick0+1
        jmp write0
!:
        rts
write0:
//write credits line1
        ldx #0 
credits_adr:        
        lda credits_l1_text,x 
        beq !+
        sta credits_line_1,x 
        inx 
        jmp credits_adr
!:
//offset credits read
        inx 
        clc 
        txa
        adc credits_adr+1 
        sta credits_adr+1
        bcc !+
        inc credits_adr+2
!:
//------------------------------
//write credits line 2
        ldx #0 
credits_adr2:        
        lda credits_l2_text,x 
        beq !+
        sta credits_line_2,x 
        inx 
        jmp credits_adr2
!:
//offset credits read
        inx 
        clc 
        txa
        adc credits_adr2+1 
        sta credits_adr2+1
        bcc !+
        inc credits_adr2+2
!:

//check for end list
        inc greetz_ct0+1
greetz_ct0:
        lda #0 
        cmp #credits_line1_data.size()+1
        bne !+
      
        lda #<write_title 
        sta text_fn+1
        lda #>write_title 
        sta text_fn+2    
!:
        rts

credits_l1_text:
.for(var x=0;x<credits_line1_data.size();x++){
    .var name = credits_line1_data.get(x)
    .text name
    .byte 0
}

credits_l2_text:
.for(var x=0;x<credits_line2_data.size();x++){
    .var s = credits_line2_data.get(x)
    .text s
    .byte 0
}

write_title:   
        ldx #0 
        lda title,x
        bne !+
        lda #<write_greetz 
        sta text_fn+1
        lda #>write_greetz 
        sta text_fn+2
        rts
!:
         
        sta credits_line_2,x 
        inc write_title+1
        rts

title:
.text "a bright shining star"
.byte 0 

final_wait:
        lda #0 
        inc final_wait+1
        lda final_wait+1
        cmp #FINAL_DELAY
        bne !+
       
        lda #<clear_slogan 
        sta text_fn+1
        lda #>clear_slogan 
        sta text_fn+2
!:
        rts 

clear_slogan:
        ldx #0
        lda #PIXEL_BLACK
        sta credits_line_1-3,x
        sta credits_line_2,x
    
        inc clear_slogan+1
        lda clear_slogan+1
        cmp #21 
        bne !+
        sei 
        lda #$0 
        sta $e813

        lda #PIXEL_BLACK
        ldx #0
clrlp:  
        sta star_base,x 
        sta star_base+$28,x
        sta star_base+$28*2,x
        sta star_base+$28*3,x
        sta star_base+$28*4,x
        sta star_base+$28*5,x
        inx 
        cpx #7 
        bne clrlp
!:
        rts 
