.align $100
.macro wait_512(){
       //delay aggiuntivo
        ldy #101    //2
        dey         //2 
        bne *-1     //3 
                    //+1
        
        bit $24
        bit $24 
}
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

        //here is needed
        :raster_delay(true)

        //per andare giu di 8 linee sono 512 cicli
        .for(var x=0;x<letter_margin_top;x++){
            :wait_512()
        }

.macro write_line(tab_index,screen_index){
        lda tab_index+pixels  //4
        sta screen_index //4

        lda tab_index+pixels+1  //4
        sta screen_index+1 //4
        
        lda tab_index+pixels+2  //4
        sta screen_index+2 //4

        lda tab_index+pixels+3  //4
        sta screen_index+3 //4

        lda tab_index+pixels+4  //4
        sta screen_index+4 //4

        lda tab_index+pixels+5  //4
        sta screen_index+5 //4
}

.macro nop_delay(){
        .for (var x=0;x<NOP_N;x++){
            nop
        }
}

unroll:
.for(var x=0;x<6;x++){
        .var s_screen = star_base+$28*x
        
        .var px_mrg = x*48
//--------------------------------------------------
        :write_line(0+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(6+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(12+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(18+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(24+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(30+px_mrg, s_screen)
        :nop_delay()
 //--------------------------------------------------
        :write_line(36+px_mrg, s_screen)
        :nop_delay()
//--------------------------------------------------
        :write_line(42+px_mrg, s_screen)

        .if(x!=6){
            :nop_delay()
        }   
}
        .var s_screen = screen+$28
        lda $e812   
copy_rt:
        jsr copy_frame     //will become copy_frame
text_fn:
        jsr write_credits

        pla 
        tay 
        pla 
        tax 
        pla
        rti 
