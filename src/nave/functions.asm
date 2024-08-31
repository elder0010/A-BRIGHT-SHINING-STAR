.macro target_screen(){
        ldx screen_pt
        lda screen_r_addr_lo,x 
        sta gfx_dst 
        lda screen_r_addr_hi,x 
        sta gfx_dst+1
        inc screen_pt
}

.macro target_spaceship(){
        ldy gfx_pt
        lda spaceship_addr_lo,y
        sta gfx_src
        lda spaceship_addr_hi,y
        sta gfx_src+1
        inc gfx_pt
}

.macro check_for_end(){      
        lda gfx_pt
        cmp lines_amt 
        bne !+
        rts 
!:
}

.pc = * "move spaceship"
move_spaceship:
   //     lda #0
     //   sta line_ct 

        ldx spaceship_y
        cpx #$ff
        bne !+
        rts 
!:
        lda start_screen,x
        sta screen_pt 

        lda lines_to_copy,x 
        sta lines_amt

gfx_str:
        lda #0
        sta gfx_pt 
//---------------------------------------------
cpl0:
        lda #1
        beq !+
        jsr copy_line0
        :check_for_end()
!:
cpl1:
        lda #1
        beq !+
        jsr copy_line1
        :check_for_end()
!:
cpl2:
        lda #1
        beq !+
        jsr copy_line2
        :check_for_end()
!:
cpl3:
        lda #1
        beq !+        
        jsr copy_line3
        :check_for_end()
!:
cpl4:
        lda #1
        beq !+        
        jsr copy_line4
        :check_for_end()
!:
cpl5:
        lda #1
        beq !+
        jsr copy_line5
        :check_for_end()
!:
cpl6:
        lda #1
        beq !+
        jsr copy_line6
        :check_for_end()
!:

cpl7:
        lda #1
        beq !+
        jsr copy_line7
        :check_for_end()
!:

cpl8:
        lda #1
        beq !+
        jsr copy_line8
        :check_for_end()
!:

cpl9:
        lda #1
        beq !+
        jsr copy_line9 
        :check_for_end()
!:

cpl10:
        lda #1
        beq !+
        jsr copy_line10 
        :check_for_end()
!:

cpl11:
        lda #1
        beq !+
        jsr copy_line11 
        :check_for_end()
!:

cpl12:
        lda #1
        beq !+
        jsr copy_line12 
        :check_for_end()
!:

cpl13:
        lda #1
        beq !+
        jsr copy_line13 
        :check_for_end()
!:

cpl14:
        lda #1
        beq !+
        jsr copy_line14 
        :check_for_end()
!:

cpl15:
        lda #1
        beq !+
        jsr copy_line15
        :check_for_end()
!:

cpl16:
        lda #1
        beq !+
        jsr copy_line16
        :check_for_end()
!:

cpl17:
        lda #1
        beq !+
        jsr copy_line17
        :check_for_end()
!:

cpl18:
        lda #1
        beq !+
        jsr copy_line18
        :check_for_end()
!:
cpl19:
        lda #1
        beq !+
        jsr copy_line19
!:
must_clear_spaceship:
        lda #0 
        beq !+
        jsr clear_line_bottom
!:

     
        rts

.macro clean_for_stars(s_start,s_end){
    ldy #s_start
    .for(var x=s_start;x<s_end;x++){
            lda (gfx_dst),y 
            cmp #STAR 
            beq !+
            cmp #DOT 
            beq !+
            lda (gfx_src),y 
            sta (gfx_dst),y 
    !:
.if(x!=s_end){
        iny 
        }
    }
}

.macro copy_ship(s_start,s_end){
    ldy #s_start
    .for(var x=s_start;x<s_end;x++){
        lda (gfx_src),y 
        sta (gfx_dst),y 
        .if(x!=s_end){
            iny 
        }

    }
}

copy_line0:
        :target_screen()
        :target_spaceship()
        
        ldy #11 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        ldy #17
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 
        rts


copy_line1:
        :target_screen()
        :target_spaceship()
        
        ldy #11 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        ldy #17
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 
        rts

copy_line2:
        :target_screen()
        :target_spaceship()
        
        ldy #11 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 

        ldy #17
        lda (gfx_src),y 
        sta (gfx_dst),y 

        iny 
        lda (gfx_src),y 
        sta (gfx_dst),y 
        rts

copy_line3:
        :target_screen()
        :target_spaceship()
        
        :copy_ship(11,19)

        rts

copy_line4:
        :target_screen()
        :target_spaceship()
        
     :copy_ship(10,20)
        rts

copy_line5:
        :target_screen()
        :target_spaceship()
        
      :copy_ship(9,21)
        rts

copy_line6:
        :target_screen()
        :target_spaceship()
        
        :copy_ship(8,22)
        rts

copy_line7:
        :target_screen()
        :target_spaceship()
        
     :copy_ship(7,23)
        rts

copy_line8:
        :target_screen()
        :target_spaceship()
        
:copy_ship(6,24)
        rts

copy_line9:
        :target_screen()
        :target_spaceship()
  :copy_ship(5,25)
        rts

copy_line10:
        :target_screen()
        :target_spaceship()
        
   :copy_ship(4,26)
        rts

copy_line11:
        :target_screen()
        :target_spaceship()
        
 :copy_ship(4,26)
        rts


copy_line12:
        :target_screen()
        :target_spaceship()
:copy_ship(3,27)
        rts

copy_line13:
        :target_screen()
        :target_spaceship()
  :copy_ship(2,28)
        rts

copy_line14:
        :target_screen()
        :target_spaceship()
        
  :copy_ship(2,28)
        rts

copy_line15:
        :target_screen()
        :target_spaceship()
        :copy_ship(1,7)
        :clean_for_stars(7,10)
        :copy_ship(10,21)
        :clean_for_stars(20,23)
        :copy_ship(23,30)
        rts

copy_line16:
        :target_screen()
        :target_spaceship()
        
        :copy_ship(1,6)
        :clean_for_stars(6,10)
        :copy_ship(10,21)
        :clean_for_stars(20,24)
        :copy_ship(24,30)
        rts

copy_line17:
        :target_screen()
        :target_spaceship()
        
        :copy_ship(0,5)
        :clean_for_stars(5,10)
        :copy_ship(10,21)
        :clean_for_stars(20,25)
        :copy_ship(25,30)
        rts

copy_line18:
        :target_screen()
        :target_spaceship()
        :copy_ship(0,4)
        :clean_for_stars(4,10)
        :copy_ship(10,21)
        :clean_for_stars(20,26)
        :copy_ship(26,30)
        rts

copy_line19:
        :target_screen()
        :target_spaceship()
        :clean_for_stars(0,12)
        :copy_ship(12,14)
        :clean_for_stars(13,15)
        :copy_ship(15,18)
        :clean_for_stars(18,30)
        rts
    
//quante
lines_to_copy:
.byte 01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20 //ship appear
.byte 20,20,20,20,20    //ship on screen 
.byte 19,17,16,15,14,13,12,11,10,09,08,07,06,05,04,03,02,01,00 //ship disappear

//da dove
start_screen:
.byte 24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,09,08,07,06,05
.byte 04,03,02,01,00
.byte 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

intro_delay:
        inc dlry2+1
dlry2:
        lda #0 
        cmp #2
        bne !+
        lda #0 
        sta dlry2+1
        inc stilltick2+1
!:
stilltick2:
        lda #0 
        cmp #INTRO_DELAY_TIME
        bne !+
        lda #<scroll_up_spaceship
        sta move_fn_tg+1

        lda #>scroll_up_spaceship
        sta move_fn_tg+2
        lda #$20 //jsr 
        sta move_spaceship_fn
!:
        rts


scroll_up_spaceship:
        inc spaceship_y
        lda spaceship_y
        cmp #$2
        bne !+
        lda #1 
        sta must_clear_spaceship     
!:
        cmp #$16
        bne !+
        dec spaceship_y

        lda #<spaceship_still
        sta move_fn_tg+1

        lda #>spaceship_still
        sta move_fn_tg+2

!:
        rts

move_out_spaceship:
        ldx copy_enabler_pt 
        inc copy_enabler_pt
        lda copy_enabler_lo,x
        sta tgadr+1
        lda copy_enabler_hi,x
        sta tgadr+2

        lda #0 
        ldx #1 
tgadr:
        sta $ffff+1,x

        inc gfx_str+1

        lda gfx_str+1
        cmp #21
        bne !+
        
        lda #$2c //bit 
        sta move_spaceship_fn

        lda #<fade_out
        sta move_fn_tg+1

        lda #>fade_out
        sta move_fn_tg+2

!:
        rts


fade_out:
        lda #1
        sta enable_fadeout+1
        sta enable_fadeout_bg+1
        rts 


spaceship_still:
        inc dlry+1
dlry:
        lda #0 
        cmp #2
        bne !+
        lda #0 
        sta dlry+1
        inc stilltick+1
!:
stilltick:
        lda #0 
        cmp #SPACESHIP_STILL_TIME
        bne !+
        lda #<move_out_spaceship
        sta move_fn_tg+1

        lda #>move_out_spaceship
        sta move_fn_tg+2

       
     //   inc spaceship_y
       // inc spaceship_y
/*
        lda #$20
        sta screen+$28*22+17
        sta screen+$28*22+18
        
        sta screen+$28*22+21
        sta screen+$28*22+22
        */
        
        
!:
        rts 

.var copy_enabler_list = List().add(cpl0,cpl1,cpl2,cpl3,cpl4,cpl5,cpl6,cpl7,cpl8,cpl9,cpl10,cpl11,cpl12,cpl13,cpl14,cpl15,cpl16,cpl17,cpl18,cpl19)

copy_enabler_lo:
.for (var x=0;x<copy_enabler_list.size();x++){
    .byte <copy_enabler_list.get(x)
}


copy_enabler_hi:
.for (var x=0;x<copy_enabler_list.size();x++){
    .byte >copy_enabler_list.get(x)
}

clear_line_bottom:
        
        :target_screen()

        ldx #BLANK_PIXEL
        ldy #0 
        .for(var x=0;x<30;x++){
            lda (gfx_dst),y 
            cmp #STAR 
            beq !+
            cmp #DOT 
            beq !+
            
            txa
            sta (gfx_dst),y 
            !:
            .if(x!=33){
                iny 
            }
        }
        rts
        