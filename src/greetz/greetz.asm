.import source ("../variables.asm")
.import source ("variables.asm")
.import source ("data/greetz_list.asm")
.pc = $5000
greetz_rt:
        jsr clear_screen

        lda #$0 
        sta $e811
        sta $e821
        sta $e823
        sta $e84e

        lda #11
        sta frame_pt

        lda #<timer_irq 
        sta $90
        lda #>timer_irq 
        sta $91 
        
        :wait_frame()

        lda #%10111101
        sta $e813

        cli 

mainx:
        jmp mainx
        /*
frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

        inc frame_tick+1
frame_tick:
        lda #0 
        cmp #GREETZ_DELAY
        bne !+
greetz_fn:
        jsr write_credits
        lda #0 
        sta frame_tick+1
!:
endstate:      
        nop 
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
mainx:
        jmp frame
        */

//.import source("data/background.asm")
.import source("data/text.asm")
.import source("functions.asm")

.pc = * "interrupt"
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
        nop 
        bit $24 
        bit $24  
         
    }
}

.const NOP_N = 8
.align $100 
.import source("irq_f1.asm")

.pc = * "pixels"
//.import source("data/spinning/pixels.asm")
.import source("data/jumping/pixels.asm")

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
        lda star_addr_lo,x 
        sta slogan_addr

        lda star_addr_hi,x 
        sta slogan_addr+1
       
        ldy #0 
.for(var x=0;x<$100;x++){
        lda (slogan_addr),y 
        sta pixels,y
        iny
}
        inc slogan_addr+1

        ldy #$0 
  .for(var x=0;x<32;x++){
        lda (slogan_addr),y 
        sta pixels+$100,y
        iny
}      
        dec frame_pt 
        bne !+
        lda #11
        sta frame_pt
!:
        rts 

.align $100 
.const frame_size = 288 
pixels: 
.fill frame_size,$20 

.var frame_nr = 12 
.var frame_list = List()
.for(var x=0;x<4;x++){
    .eval frame_list.add(frame_0_1_2_3+[frame_size*x])
}
.for(var x=0;x<4;x++){
    .eval frame_list.add(frame_4_5_6_7+[frame_size*x])
}
.for(var x=0;x<4;x++){
    .eval frame_list.add(frame_8_9_10_11+[frame_size*x])
}

star_addr_lo:
.for(var x=0;x<frame_list.size();x++){
    .byte <frame_list.get(x)
}

star_addr_hi:
.for(var x=0;x<frame_list.size();x++){
    .byte >frame_list.get(x)
}

clear_screen:
        ldx #0 
        lda #PIXEL_BLACK
!:
        sta screen,x 
        sta screen+$100,x 
        sta screen+$200,x 
        sta screen+$300,x 
        dex 
        bne !-
        rts
