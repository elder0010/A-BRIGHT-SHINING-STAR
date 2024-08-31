transition:
        lda $e84c 
        sta cia2_uppercase
        :set_lowercase()
        lda #0 
        sta slogan_pt
        sta slogan_line_pt
        sta faded_letters

transition_frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
endfx_trigger:
        nop 
slogan_fn:
        jsr write_slogan
!:
        lda VIA_PORT_B
        and #$20 
        beq !-

        jmp transition_frame

.const slogan_pos = screen+$28*10+3

write_slogan:
        ldx slogan_pt
slogan_src:
        lda slogan_1,x
slogan_dst:
        sta slogan_pos,x

        inc slogan_pt 
        lda slogan_pt 
        cmp #30
        bne !+

        lda #<wait_new_line
        sta slogan_fn+1
        lda #>wait_new_line
        sta slogan_fn+2      
!:
        rts

wait_new_line:
        inc slgdl0+1
slgdl0:
        lda #0 
        cmp #SLOGAN_WAIT_ON_SCREEN_TIME
        bne endwat
        lda #0
        sta slgdl0+1

        inc slogan_line_pt 
        ldx slogan_line_pt 
        cpx #3
        bne nextslg
        
        lda #<fade_out_slogan
        sta slogan_fn+1
        lda #>fade_out_slogan
        sta slogan_fn+2   
        rts 
    
nextslg:
        lda #0 
        sta slogan_pt
        lda slogan_addr_lo,x 
        sta slogan_src+1
        lda slogan_addr_hi,x 
        sta slogan_src+2
        
        clc 
        lda slogan_dst+1
        adc #[$28*2]
        sta slogan_dst+1
        bcc !+
        inc slogan_dst+2
!:      
        lda #<write_slogan
        sta slogan_fn+1
        lda #>write_slogan
        sta slogan_fn+2          
endwat:
        rts 

fade_out_slogan:
        ldx #0 
next_x:
        lda slogan_fade_status,x 
        beq !+
        jmp noinc
!:
        lda slogan_pos,x
        cmp #$20 
        beq fadex
        cmp #$60 
        bne !+
fadex:
        inc slogan_fade_status,x
        inc faded_letters
        lda faded_letters
        cmp #$78
        bne noinc
        
        lda #$20
        ldx #30
noxclear:
        sta slogan_pos+$28*6,x 
        sta slogan_pos+$28*2,x 
        sta slogan_pos,x 
        dex 
        bpl noxclear

        lda #<restore_uppercase
        sta slogan_fn+1
        lda #>restore_uppercase
        sta slogan_fn+2     

        rts  
!:
        inc slogan_pos,x 
noinc:
        dex 
        bne next_x
        rts 

restore_uppercase:
        inc fxdl+1
fxdl:
        lda #0 
        cmp #SLOGAN_WAIT_ON_SCREEN_TIME
        bne !+

        //clear slogan
        ldx #0 
        lda #$20
clrp: 
        sta slogan_pos+[$28*4],x 
        inx 
        cpx #30
        bne clrp 

        lda #<wait_for_bmp
        sta slogan_fn+1
        lda #>wait_for_bmp
        sta slogan_fn+2     
!:
        rts 

wait_for_bmp:

        inc final_delay+1
final_delay:
        lda #0 
        cmp #SLOGAN_DELAY_AFTER_FADEOUT
        bne !+
        lda #$60            //rts 
        sta endfx_trigger
        :set_uppercase()
!:        
        rts 


slogan_fade_status:
.fill $80,0

slogan_1:
.text "    A totally new video mode.    "
slogan_2:
.text "        Introducing PECBM        "
slogan_3:  
.text "    PET Extended Char Bitmap.    "

.var slogan_addr = List().add(slogan_1,slogan_2,slogan_3)

slogan_addr_lo:
.for (var x=0;x<3;x++){
    .byte <slogan_addr.get(x)
}

slogan_addr_hi:
.for (var x=0;x<3;x++){
    .byte >slogan_addr.get(x)
}

.macro set_lowercase(){
        lda #$12
        sta $e84c 
}

.macro set_uppercase(){
        lda cia2_uppercase
        sta $e84c 
}

