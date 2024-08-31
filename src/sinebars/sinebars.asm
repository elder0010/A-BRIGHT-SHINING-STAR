.import source("../variables.asm")
.import source("variables.asm") 
.pc = $5000 

sinebars:
       // jsr clear_screen
       // jsr wait_frames
        
        ldy #0 
        sty pointer_tb_ptr
        
        /*
fillsc:
        ldx #$27
        lda #$e0 
!: 
mscr:
        sta screen+$28,x 
        dex 
        cpx #x_mrg
        bne !-
        

        clc 
        lda mscr+1
        adc #$28
        sta mscr+1
        bcc !+
        inc mscr+2
!:
        iny 
        cpy #24
        bne fillsc 

    */

        lda #$0 
        sta $e811
        sta $e821
        sta $e823
        sta $e84e

        lda #%10111101
        sta $e813

        lda #<sizes_tab
        sta bars_gfx_addr

        lda #>sizes_tab
        sta bars_gfx_addr+1

        lda #<timer_irq 
        sta $90
        lda #>timer_irq 
        sta $91 

        jsr sinebars_transition 

        ldx #$0 
!:          
        lda pointer_tb,x 
        sta sintables_tmp_data,x

        lda #$4
        sta pointer_tb,x 

        dex 
        bne !-

!:
        lda VIA_PORT_B
        and #$20 
        bne !-

        cli 
mainx:
        jmp mainx

.macro raster_delay(real_hw){
    .if(real_hw){
        dex 
        bne *-1

        bit $24         
    }else{
        ldx #$eb
        dex 
        bne *-1

        bit $24
        nop
       
        nop
        nop
        nop
    }
}

.const NOP_N = 19

.macro raster_wait(last,offset){
     

    
   // inx                 //2
    ldy sine_tab,x      //4
    lda size_addr_lo,y  //4
    sta bars_gfx_addr   //3
    lda size_addr_hi,y  //4
    sta bars_gfx_addr+1 //3
    
    .if(!last){
        ldx #offset
        inc pointer_tb,x   //7  
        ldy pointer_tb,x   //4
        ldx sine_tab,y     //2
        bit $24
        nop
       
        
goy:
        ldy #0              //2
    }
}
.align $100
.pc = * "timer irq"
timer_irq:
ct:
        lda #0 
        ldy #$ff 
        dey 
        bne *-1
        inc ct+1
        lda ct+1
        cmp #$2
        bne ct

        lda #0
        sta ct+1

res_delayer:
        ldx #$80       //$e7
        :raster_delay(true)

rasx:
        ldx #0 
      //  ldy #0 
//88 cicly           
.macro write_double_line(row_offs){
        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen //4
        iny //2

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+1 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+2 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+3 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+4 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+5 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+6 //4
        iny 

        lda (bars_gfx_addr),y  //5
        sta x_mrg+[$28*row_offs]+screen+7 //4
         
}

.macro fake_double_line(row_offs){
        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen //4
        iny //2

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+1 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+2 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+3 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+4 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+5 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+6 //4
        iny 

        lda (bars_gfx_addr),y  //5
        and x_mrg+[$28*row_offs]+screen+7 //4
         
}
.var line_ct = 0
.for(var x=0;x<25;x++){
//--------------------------------------------------
.if(x!=0){
        :write_double_line(x)
}else{
        :fake_double_line(x)
}
        :raster_wait(false,line_ct)
        .eval line_ct = line_ct+1
//--------------------------------------------------
.if(x!=0){
        :write_double_line(x)
}else{
        :fake_double_line(x)
}
        :raster_wait(false,line_ct)
        .eval line_ct = line_ct+1
//--------------------------------------------------
.if(x!=0){
        :write_double_line(x)
}else{
        :fake_double_line(x)
}
        :raster_wait(false,line_ct)
        .eval line_ct = line_ct+1
//--------------------------------------------------
.if(x!=0){
        :write_double_line(x)
}else{
        :fake_double_line(x)
}
        .if(x!=24){
            :raster_wait(false,line_ct)
            .eval line_ct = line_ct+1
        }
}

        ldy sine_tab,x      //4
        lda size_addr_lo,y  //4
        sta bars_gfx_addr   //3
        lda size_addr_hi,y  //4
        sta bars_gfx_addr+1 //3

    //    inc rasx+1
        lda #0 
        sta pointer_tb_ptr
    
trans_fx:
        jsr fx_fade_tr

        lda $e812

        pla 
        tay 
        pla 
        tax 
        pla
        rti 

fx_fade_tr:
fade_fx_mrg:
        ldx #$0 
        lda sintables_tmp_data,x 
        sta pointer_tb,x 
        inc fade_fx_mrg +1
        bne !+

        lda #<res_trans
        sta trans_fx+1
        lda #>res_trans
        sta trans_fx+2      
!:
        rts 

.const logo_src =  s_bg+$28*6
res_trans:
        lda #0 
        inc res_trans+1
        cmp #$ff
        bne endtrn

        dec res_trans+1

        lda #<logo_cp 
        sta trans_fx +1
        lda #>logo_cp
        sta trans_fx+2
endtrn:

        rts

logo_cp:
     
        ldy #$0
!:
sr0:
        lda logo_src,y 
dst0:    
        sta logo_pos,y 
        iny 
mrgy:
        cpy #$1 
        bne !-

        inc mrgy+1
        lda mrgy+1
        cmp #$8
        bne skpall

        lda #1 
        sta mrgy+1

        lda sr0+1
        clc 
        adc #$28 
        sta sr0 +1
        bcc !+
        inc sr0+2
!:

        lda dst0+1
        clc 
        adc #$28 
        sta dst0 +1
        bcc !+
        inc dst0+2
!:

        inc rowctx+1
rowctx:
        lda #0
        cmp #4 
        bne !+
        lda #<boost_res 
        sta trans_fx +1
        lda #>boost_res
        sta trans_fx+2
!:
skpall:
        rts

boost_res:
        inc res_delayer+1
        lda res_delayer+1
nolgcp:
        lda res_delayer+1
        cmp #$e7
        bne endtrn
        lda #<final_fx_wait 
        sta trans_fx +1
        lda #>final_fx_wait
        sta trans_fx+2

       // lda #$2c //BIT 
        //sta trans_fx
        rts

final_fx_wait:
        inc halv+1
halv:
        lda #$0 
        cmp #$3 
        bne !+
        inc fx_tick+1
        lda #0 
        sta halv+1
!:
fx_tick:
        lda #0 
        cmp #HI_RES_FX_TIME 
        bne !+
        lda #$0 
        sta $e813
        sei 
        jsr clear_screen 

        lda #$60 //rts - end fx
        sta mainx

        /*
        lda #<post_sinebars
        sta mainx+1
        lda #>post_sinebars
        sta mainx+2
        */

!:
        rts 

.import source "data/bars.asm"

.align $100
.pc = * "sinetab"
sine_tab:
.import source("data/sintable.asm")

s_bg:
.import source ("data/background.asm")

clear_screen:
        lda #$60
        ldx #$0
!:
        sta screen,x
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        dex
        bne !-
        rts

.pc = * "transition"
.import source("transition.asm")
