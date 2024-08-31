.import source("../variables.asm")
.import source ("variables.asm")
.import source("data/pixels.asm")
.import source("data/shift_table.asm")

.pc = $4600
bitmap_rt:
      //  jsr clear_screen
        sei 

        lda #$0 
        sta $e811
        sta $e821
        sta $e823
        sta $e84e
        sta sin_pt
        sta arrow_pointer
        
        lda #%10111101
        sta $e813

        lda #<background_img+40 
        sta src_adr

        lda #>background_img+40 
        sta src_adr+1

        lda #<screen 
        sta dst_addr

        lda #>screen 
        sta dst_addr+1

        //jmp glitch_frame

        :wait_frame()
        lda #<timer_irq 
        sta $90
        lda #>timer_irq 
        sta $91 

        cli 

        ldx #0
nextln:  
        ldy #0 
    
        .for(var x=0;x<40;x++){
            lda (src_adr),y
            sta (dst_addr),y
            .if(x!=40){
                iny 
            }
        }

        inx 
        cpx #24
        beq enddraw

        clc
        lda src_adr
        adc #[80+$28]
        sta src_adr
        bcc !+
        inc src_adr+1
!:

        clc
        lda dst_addr
        adc #[$28]
        sta dst_addr
        bcc !+
        inc dst_addr+1
!:
        jmp nextln

        
enddraw:     
  
  /*
        ldx #0
!:
        lda background_img,x 
        sta screen,x
        lda background_img+$100,x 
        sta screen+$100,x 
        lda background_img+$200,x 
        sta screen+$200,x 
        lda background_img+$300,x 
        sta screen+$300,x 
        dex 
        bne !-
     */
        
mainx:
        jmp mainx

.macro raster_delay(real_hw){
    .if(real_hw){
        //4ba (1210) cicli - devo toglierne 512 
        ldx #$ed
        dex 
        bne *-1
        nop 
        nop 
        nop
        //$3fb cicli
        //su real hw devi fare le cose 191 cicli prima
    }else{

        //4ba (1210) cicli - devo toglierne 512 
        ldx #$ef
        dex 
        bne *-1
        nop 
        nop
        bit $24
        bit $24
        nop 
        bit $24   
    }
}

.const NOP_N = 0
.align $100
.pc = * "timer irq"
timer_irq:
ct:
        lda #0 
fade_v:
        ldy #$ff //must be $ff
        dey 
        bne *-1
        inc ct+1
        lda ct+1
        cmp #$2
        bne ct

        lda #0
        sta ct+1

        :raster_delay(true)

.const bytes_per_line = 10
//.const line_numbers = pixels.size()/bytes_per_line

.const line_numbers = 100 

//.const line_numbers = 192
.var line_offset = 0
//.var screen_index = screen+$28+x_stripe_margin

.print("line numbers" + toHexString(line_numbers))

.macro write_line(offs, screen_index, positions){
        nop 
        nop 
        .for(var c=0;c<10;c++){
            lda #[pixels.get(offs+c)]
            .if(positions.get(c)!=$ff){
                sta screen_index+positions.get(c)
            }else{
                nop 
                nop 
            }
        }        
}

.var line_ct = 0
//start_line:
.for(var x=0;x<23;x++)
{       
        //.eval x_stripe_margin = 0
        .var s_screen = screen+$28*x
        
        .var shift_base = x*10

        .eval line_offset = x * bytes_per_line*8     

        .var positions = List()
        .for(var c=0;c<10;c++){
            .eval positions.add(shift_table.get(shift_base+c))
        }

        :write_line(line_offset+bytes_per_line*0,s_screen,positions)
        :write_line(line_offset+bytes_per_line*1,s_screen,positions)
        :write_line(line_offset+bytes_per_line*2,s_screen,positions)
        :write_line(line_offset+bytes_per_line*3,s_screen,positions)
        :write_line(line_offset+bytes_per_line*4,s_screen,positions)
        :write_line(line_offset+bytes_per_line*5,s_screen,positions)
        :write_line(line_offset+bytes_per_line*6,s_screen,positions)
        :write_line(line_offset+bytes_per_line*7,s_screen,positions)
}
//end_line:
//.print ("Line size "+toHexString(end_line-start_line))
        lda $e812   

        //cli
irq_fn:         
        jsr final_fx_wait 
flash_fn:
        jsr wait_flash

        pla 
        tay 
        pla 
        tax 
        pla
        rti 


.pc = * "background"
.import source("data/background.asm")


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
        cmp #BMP_ON_SCREEN_TIME 
        bne !+
        
        sei 
        lda #$0 
        sta $e813

        lda #<glitch_frame
        sta mainx+1

        lda #>glitch_frame
        sta mainx+2
        

      //  jsr clear_screen
        //lda #$60 //rts - end fx
        //sta mainx
!:
        rts 

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

.import source("transition.asm")
.pc = * "functions"
.import source("functions.asm")
