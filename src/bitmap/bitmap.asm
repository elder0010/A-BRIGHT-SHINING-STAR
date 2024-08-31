.import source("../variables.asm")
.import source ("variables.asm")
.import source("data/pixels.asm")
.import source("data/shift_table.asm")
.import source("data/fake_columns.asm")

.pc = $4a00
bitmap_rt:
      //  jsr clear_screen
        sei 
        jsr transition
        jsr door_movement
        lda #$0 
        sta $e811
        sta $e821
        sta $e823
        sta $e84e

        lda #%10111101
        sta $e813

        lda #<timer_irq 
        sta $90
        lda #>timer_irq 
        sta $91 

        cli 

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
        ldy #$eb //must be $ff
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

.macro write_line(offs, screen_index, fake_left, fake_right, fake_last){
        nop 
        nop 

        lda #[pixels.get(offs)]
        .if(fake_left==1){
            and screen_index
        }else{
            sta screen_index
        }
        
        lda #[pixels.get(offs+1)]
        sta screen_index+1

        lda #[pixels.get(offs+2)]
        sta screen_index+2

        lda #[pixels.get(offs+3)]
        sta screen_index+3

        lda #[pixels.get(offs+4)]
        sta screen_index+4

        lda #[pixels.get(offs+5)]
        sta screen_index+5

        lda #[pixels.get(offs+6)]
        sta screen_index+6

        lda #[pixels.get(offs+7)]
        sta screen_index+7

        lda #[pixels.get(offs+8)]
        .if(fake_right==1){
            and screen_index+8
        }else{
            sta screen_index+8
        }

        lda #[pixels.get(offs+9)]
        .if(fake_last==1){
            and screen_index+9
        }else{
            sta screen_index+9
        }
        
}

.var line_ct = 0
//start_line:
.for(var x=0;x<24;x++)
{       
        .eval x_stripe_margin = shift_table.get(x)
        //.eval x_stripe_margin = 0
        .var s_screen = screen+$28*x+x_stripe_margin
        .var fake_left = fake_columns.get(x*3)
        .var fake_right = fake_columns.get([x*3]+1)
        .var fake_last = fake_columns.get([x*3]+1)
        
        .eval line_offset = x * bytes_per_line*8      
        :write_line(line_offset+bytes_per_line*0,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*1,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*2,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*3,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*4,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*5,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*6,s_screen,fake_left,fake_right,fake_last)
        :write_line(line_offset+bytes_per_line*7,s_screen,fake_left,fake_right,fake_last)
}
//end_line:
//.print ("Line size "+toHexString(end_line-start_line))
        lda $e812   

irq_fn:     
        jsr fade_in_bmp 

        pla 
        tay 
        pla 
        tax 
        pla
        rti 


.import source("data/background.asm")
//.import source("data/charset_parser.asm")

fade_in_bmp:
        inc fade_v+1
        inc fade_v+1
        
        lda fade_v+1
        cmp #$ff 
        bne !+
        lda #<final_fx_wait
        sta irq_fn+1
        lda #>final_fx_wait
        sta irq_fn+2
        
        lda #FLOOR_PIXEL
        sta screen+$28*24+27
        sta screen+$28*24+28
        sta screen+$28*24+34
        sta screen+$28*24+35
!:
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
        cmp #BMP_ON_SCREEN_TIME 
        bne !+
        sei 
        lda #$0 
        sta $e813

        lda #$20
        ldx #$40
clsclp:
        sta screen,x
        sta screen+$40,x
        sta screen+$80,x
        sta screen+$c0,x
        sta screen+$100,x
        sta screen+$140,x
        sta screen+$180,x
        sta screen+$1c0,x
        sta screen+$200,x
        sta screen+$240,x
        sta screen+$280,x
        sta screen+$2c0,x 
        sta screen+$300,x
        sta screen+$340,x
        sta screen+$380,x
        sta screen+$3c0,x
        dex
        bpl clsclp
       
        lda #$60 //rts - end fx
        sta mainx
!:
        rts 


.pc = * "door movement"
.import source("door_movement.asm")

.pc = * "transition"
.import source("transition.asm")

.import source("data/door_frames.asm")