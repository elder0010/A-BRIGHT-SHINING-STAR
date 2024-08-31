.import source ("../variables.asm")
.import source ("variables.asm")

.import source("data/letter_a.asm")
.import source("data/letter_c.asm")
.import source("data/letter_e.asm")
.import source("data/letter_i.asm")
.import source("data/letter_l.asm")
.import source("data/letter_m.asm")
.import source("data/letter_n.asm")
.import source("data/letter_o.asm")
.import source("data/letter_p.asm")
.import source("data/letter_s.asm")
.import source("data/letter_space.asm")
.import source("data/letter_t.asm")

.pc = $5000 "slogan"
slogan_rt:
      //  jsr clear_screen
      
        lda #$0 
        sta $e811
        sta $e821
        sta $e823
        sta $e84e


        sta frame_pt
        sta upper_nibbler_pos 
        lda #$27 
        sta lower_nibbler_pos

      //  jsr fill_fr

        lda #<timer_irq 
        sta $90
        lda #>timer_irq 
        sta $91 
        
        lda #%10111101
        sta $e813

        :wait_frame()
        :wait_frame()
        :wait_frame()
        
        cli 

mainx:
        jmp mainx


.const L_SIZE = 8*64

l_a:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_a.get(x)
}
l_c:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_c.get(x)
}

l_e:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_e.get(x)
}

l_i:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_i.get(x)
}

l_l:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_l.get(x)
}

l_m:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_m.get(x)
}

l_n:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_n.get(x)
}

l_o:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_o.get(x)
}

l_p:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_p.get(x)
}

l_s:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_s.get(x)
}

l_space:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_space.get(x)
}

l_t:
.for (var x=0;x<L_SIZE;x++){
    .byte letter_t.get(x)
}

.macro raster_delay(real_hw){
    .if(real_hw){
     //4ba (1210) cicli - devo toglierne 512 
        ldx #$ed
        dex 
        bne *-1
        nop 
        nop 
        nop 
        nop 
        nop
        nop 
        nop 
        //$3fb cicli
        //su real hw devi fare le cose 191 cicli prima
    }else{

        //4ba (1210) cicli - devo toglierne 512 
           ldx #$ed
        dex 
        bne *-1
        nop 
        nop 
        nop 
        nop 
        nop
        nop 
        bit $24 
        bit $24 
        bit $24  
         
    }
}

.const NOP_N = 8
.align $100 
.import source("irq_f1.asm")

//accept no limits
.const slogan_list = List().add(
    l_a,l_a,l_space,l_c,l_c,l_space,l_c,l_c,l_space,l_e,l_e,l_space,l_p,l_p,l_space,l_t,l_t,
    l_space,l_space,l_space,l_space,
    l_n,l_n,l_space,l_o,l_o,
    l_space,l_space,l_space,l_space,
    l_l,l_l,l_space,l_i,l_i,l_space,l_m,l_m,l_space,l_i,l_i,l_space,l_t,l_t,l_space,l_s,l_s,l_space,l_space,l_space,l_space,l_space)

copy_frame:
        inc fct+1
fct:        
        lda #FRAME_SPEED-1 
        cmp #FRAME_SPEED
        beq !+
        rts  
!:
        lda #0 
        sta fct+1
fill_fr:
        ldx frame_pt 
        lda slogan_addr_lo,x 
        sta slogan_addr

        lda slogan_addr_hi,x 
        sta slogan_addr+1
       
        ldy #0 
.for(var x=0;x<200;x++){
        lda (slogan_addr),y 
        sta pixels,y
        iny
}
        inc frame_pt 
        lda frame_pt 
        cmp #slogan_list.size()
        bne !+
        dec frame_pt

         sei 
        lda #$0 
        sta $e813

        //clear screen area
        lda #PIXEL_BLACK
        ldx #$8
fcl:
        sta [screen+x_stripe_margin]+$28*letter_margin_top,x 
        sta $28+[screen+x_stripe_margin]+$28*letter_margin_top,x 
        sta $28*2+[screen+x_stripe_margin]+$28*letter_margin_top,x 
        sta $28*3+[screen+x_stripe_margin]+$28*letter_margin_top,x 
        sta $28*4+[screen+x_stripe_margin]+$28*letter_margin_top,x 
        sta $28*5+[screen+x_stripe_margin]+$28*letter_margin_top,x 
        dex
        bpl fcl

        lda #$60 //rts - end fx
        sta mainx

!:
        rts 
        

.align $100 
pixels: 
.fill $140,$20 

slogan_addr_lo:
.for(var x=0;x<slogan_list.size();x++){
    .byte <slogan_list.get(x)
}

slogan_addr_hi:
.for(var x=0;x<slogan_list.size();x++){
    .byte >slogan_list.get(x)
}
