.const squares_double_width = layer_0_square_size*2
draw_square_definition: 

//generate the LUT
        ldx #squares_double_width
!:      
        lda #PIXEL_BLACK
        sta layer_0_lut_even,x 
        sta layer_0_lut_even+squares_double_width,x 
        sta layer_0_lut_even+squares_double_width*2,x 
        sta layer_0_lut_even+squares_double_width*3,x 
        sta layer_0_lut_even+squares_double_width*4,x 
        sta layer_0_lut_even+squares_double_width*5,x 
        sta layer_0_lut_even+squares_double_width*6,x 

        lda square_line_even,x 
        sta layer_0_lut_even_tmp,x 
        sta layer_0_lut_even_tmp+squares_double_width,x 
        sta layer_0_lut_even_tmp+squares_double_width*2,x 
        sta layer_0_lut_even_tmp+squares_double_width*3,x 
        sta layer_0_lut_even_tmp+squares_double_width*4,x 
        sta layer_0_lut_even_tmp+squares_double_width*5,x 
        sta layer_0_lut_even_tmp+squares_double_width*6,x 

        lda #PIXEL_BLACK
        sta layer_0_lut_odd,x 
        sta layer_0_lut_odd+squares_double_width,x 
        sta layer_0_lut_odd+squares_double_width*2,x 
        sta layer_0_lut_odd+squares_double_width*3,x 
        sta layer_0_lut_odd+squares_double_width*4,x 
        sta layer_0_lut_odd+squares_double_width*5,x 
        sta layer_0_lut_odd+squares_double_width*6,x 

        lda square_line_odd,x 
        sta layer_0_lut_odd_tmp,x 
        sta layer_0_lut_odd_tmp+squares_double_width,x 
        sta layer_0_lut_odd_tmp+squares_double_width*2,x 
        sta layer_0_lut_odd_tmp+squares_double_width*3,x 
        sta layer_0_lut_odd_tmp+squares_double_width*4,x 
        sta layer_0_lut_odd_tmp+squares_double_width*5,x 
        sta layer_0_lut_odd_tmp+squares_double_width*6,x 
        dex 
        bpl !-
        rts

//----------------------------------------------------------------
.const l0_row0 = screen+[$28*parallax_margin_top]+[$28*2]
scroll_l0:
        ldx #$38
        ldy #0
        lda l0_frame_sel
        bne oddframe
evenframe:
        lda layer_0_lut_even,y 
        sta screen_buf_up,x 
        iny 
        dex
        bpl evenframe
        jmp drawframe
oddframe:
        lda layer_0_lut_odd,x 
        sta screen_buf_up,y 

        lda #1 
        sta must_scroll+1
        iny 
        dex
        bpl oddframe
drawframe:
        ldx #$27
!:
buf_up_addr:
        lda screen_buf_up,x 
        sta l0_row0,x
        sta l0_row0+$28,x

        sta l0_row0+$28*2,x
        sta l0_row0+$28*3,x
        sta l0_row0+$28*4,x
        sta l0_row0+$28*5,x

        sta l0_row0+$28*12,x
        sta l0_row0+$28*13,x
        sta l0_row0+$28*14,x
        sta l0_row0+$28*15,x
        sta l0_row0+$28*16,x
        sta l0_row0+$28*17,x
           
buf_lo_addr:
        lda screen_buf_up+layer_0_square_size,x 
        sta l0_row0+$28*6,x
        sta l0_row0+$28*7,x
        sta l0_row0+$28*8,x
        sta l0_row0+$28*9,x
        sta l0_row0+$28*10,x
        sta l0_row0+$28*11,x
        
        dex 
        bpl !-

        lda l0_frame_sel
        eor #$ff 
        sta l0_frame_sel

must_scroll:
        lda #0 
        beq noscroll

        lda #0 
        sta must_scroll+1

        clc 
        lda buf_up_addr+1
        adc #1 
        sta buf_up_addr+1
        bcc noincbuf 
        inc buf_up_addr+2    
noincbuf:

        clc
        lda buf_lo_addr+1 
        adc #1 
        sta buf_lo_addr+1
        bcc noincbuf1
        inc buf_lo_addr+2
noincbuf1:
        inc l0_scroll_pt
        lda l0_scroll_pt 
        cmp #12
        bne noscroll 
        lda #0 
        sta l0_scroll_pt 

        lda #<screen_buf_up 
        sta buf_up_addr+1
        lda #>screen_buf_up 
        sta buf_up_addr+2

        lda #<screen_buf_up+layer_0_square_size
        sta buf_lo_addr+1
        lda #>screen_buf_up+layer_0_square_size 
        sta buf_lo_addr+2

noscroll:
        rts
//----------------------------------------------------------------

//----------------------------------------------------------------

scroll_background:
        sec 
        lda sprite_movement_pt 
        sec
        sbc #1
        bpl !+
xpt:
        ldx background_y_pt
        lda bg_sprite_sintable,x 
        sta background_y 

        // change Y movement
        clc 
        lda background_y_pt 
        adc #1 
        and #$1f
        sta background_y_pt
        
        //change frame
        clc 
        lda background_frame_pt
        adc #1 
        and #$f 
        sta background_frame_pt

        
can_change_frame: //will stop the movement in the final transition
        lda #1
        bne norts
        lda #$60 //rts 
        sta forced_rts        
norts:

forced_rts:
        nop //will become rts 
        
        lda #$31
!: 
        sta sprite_movement_pt  
!:        
nomove:
        ldx sprite_movement_pt 
        bne !+
        rts
!:
        lda screen_start_tb,x 
        sta screen_start+1

        lda sprite_start_tb,x 
        sta sprite_start+1

        lda sprite_end_tb,x 
        sta sprite_end+1

        //set background frame
        ldx background_frame_pt
        lda bg_sprite_sequence,x 
        tax 
        lda bg_sprites_tbl_address_lo_lo,x 
        sta background_frame_addr_zp
        
        lda bg_sprites_tbl_address_lo_hi,x 
        sta background_frame_addr_zp+1
        
        ldy #0 
        lda (background_frame_addr_zp),y 
        sta src0+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src1+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src2+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src3+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src4+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src5+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src6+1
        iny 
        lda (background_frame_addr_zp),y 
        sta src7+1
        
        lda bg_sprites_tbl_address_hi_lo,x 
        sta background_frame_addr_zp
        
        lda bg_sprites_tbl_address_hi_hi,x 
        sta background_frame_addr_zp+1
        
        ldy #0 
        lda (background_frame_addr_zp),y 
        sta src0+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src1+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src2+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src3+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src4+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src5+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src6+2
        iny 
        lda (background_frame_addr_zp),y 
        sta src7+2


        //set background y-pos
        ldx background_y
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg0+1 
        sta chk0+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg0+2
        sta chk0+2
        inx 
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg1+1 
        sta chk1+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg1+2
        sta chk1+2
        inx 
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg2+1
        sta chk2+1 
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg2+2
        sta chk2+2
        inx 
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg3+1
        sta chk3+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg3+2
        sta chk3+2
        inx
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg4+1 
        sta chk4+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg4+2
        sta chk4+2
        inx
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg5+1
        sta chk5+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg5+2
        sta chk5+2
        inx 
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg6+1
        sta chk6+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg6+2
        sta chk6+2
        inx 
        lda bg_sprite_y_srcaddr_lo,x 
        sta bg7+1 
        sta chk7+1
        lda bg_sprite_y_srcaddr_hi,x 
        sta bg7+2
        sta chk7+2
         
screen_start:
        ldy #$0
sprite_start:
        ldx #$0 
rowst:
//--------------------------------------
chk0:
        lda l0_row0+$28,y
        cmp #PIXEL_BLACK 
        bne !+
src0:        
        lda bg_sprite0,x 
bg0:
        sta l0_row0+$28,y 
 !:
//--------------------------------------
chk1:
        lda l0_row0+$28*2,y
        cmp #PIXEL_BLACK 
        bne !+
src1:
        lda bg_sprite0+10,x 
bg1:
        sta l0_row0+$28*2,y 
!:
//-------------------------------------
chk2:
        lda l0_row0+$28*3,y
        cmp #PIXEL_BLACK 
        bne !+
src2:
        lda bg_sprite0+20,x 
bg2:
        sta l0_row0+$28*3,y 
!:
//-------------------------------------
chk3:
        lda l0_row0+$28*4,y
        cmp #PIXEL_BLACK 
        bne !+
src3:
        lda bg_sprite0+30,x 
bg3:
        sta l0_row0+$28*4,y 
!:
//-------------------------------------
chk4:
        lda l0_row0+$28*5,y
        cmp #PIXEL_BLACK 
        bne !+
src4:
        lda bg_sprite0+40,x 
bg4:
        sta l0_row0+$28*5,y 
!:
//-------------------------------------
chk5:
        lda l0_row0+$28*6,y 
        cmp #PIXEL_BLACK 
        bne !+
src5:
        lda bg_sprite0+50,x 
bg5:
        sta l0_row0+$28*6,y 
!:
//-------------------------------------
chk6:
        lda l0_row0+$28*7,y 
        cmp #PIXEL_BLACK 
        bne !+
src6:
        lda bg_sprite0+60,x 
bg6:
        sta l0_row0+$28*7,y 
!:
//-------------------------------------
chk7:
        lda l0_row0+$28*8,y 
        cmp #PIXEL_BLACK 
        bne !+
src7:
        lda bg_sprite0+70,x 
bg7:
        sta l0_row0+$28*8,y    
!:
        iny
        inx 
sprite_end:
        cpx #9
        bne rowst
        
        rts

screen_start_tb:
.byte 00,00,00,00,00,00,00,00,00,00,00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,39,39,39

sprite_start_tb:
.byte 00,09,08,07,06,05,04,03,02,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

sprite_end_tb:
.byte 00,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,09,08,07,06,05,04,03,02,01,10,10,10


bg_sprite_y_srcaddr_lo:
.for(var x=1;x<20;x++){
    .byte <l0_row0+$28*x
}

bg_sprite_y_srcaddr_hi:
.for(var x=1;x<20;x++){
    .byte >l0_row0+$28*x
}

.const foreground_start = l0_row0+$28
 
scroll_foreground:
        ldx #0 
        lda fore_sin,x 
        tax 
        inc scroll_foreground+1
fg_lg_amt:
        ldy #$0
!:
        lda fg_sprite,y 
        sta l0_row0+$28*5,x 

        lda fg_sprite+14,y 
        sta l0_row0+$28*6,x 

        lda fg_sprite+14*2,y 
        sta l0_row0+$28*7,x

        lda fg_sprite+14*3,y 
        sta l0_row0+$28*8,x 

        lda fg_sprite+14*4,y 
        sta l0_row0+$28*9,x 

        lda fg_sprite+14*5,y 
        sta l0_row0+$28*10,x 

        lda fg_sprite+14*6,y 
        sta l0_row0+$28*11,x 

        lda fg_sprite+14*7,y 
        sta l0_row0+$28*12,x 

        lda fg_sprite+14*8,y 
        sta l0_row0+$28*13,x 

        inx 
        iny 
        cpy #14
        bne !-
        rts 
       