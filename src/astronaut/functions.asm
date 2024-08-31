.const arrow_0_pos = screen+1+$28*7
.const arrow_1_pos = screen+6+$28*10
.const arrow_2_pos = screen+8
.const arrow_3_pos = screen+10+$28*20
.const arrow_4_pos = screen+15+$28*10
.const arrow_5_pos = screen+29+$28*09

move_bar:
//arrow 0
        ldx arrow_pointer
        .for(var x=0;x<6;x++){
            lda arrow_0+x,x
            sta $28*x+arrow_0_pos
            lda arrow_0_1+x,x
            sta $28*x+[arrow_0_pos+1]
           // inx 
        }
        inc arrow_pointer
        inc arrow_pointer
        
        lda arrow_pointer
        cmp #[38]
        bne !+
        lda #0 
        sta arrow_pointer

            
        lda #<wait_flash 
        sta flash_fn+1
        lda #>wait_flash 
        sta flash_fn+2
        
!:

//arrow 1
     //   ldx arrow_pointers+1
        .for(var x=0;x<9;x++){
            lda arrow_1+x,x
            sta $28*x+arrow_1_pos

        }

//arrow 2
        .for(var x=0;x<20;x++){
            lda arrow_2+x,x
            sta $28*x+arrow_2_pos
            lda arrow_2_1+x,x
            sta $28*x+[arrow_2_pos+1]           
        }

//arrow 3 
      //  ldx arrow_pointers+3
        .for(var x=0;x<6;x++){
            lda arrow_3+x,x
            sta $28*x+arrow_3_pos
            lda arrow_3_1+x,x
            sta $28*x+[arrow_3_pos+1]           
          //  inx 
        }

    
//arrow 5 
        //ldx arrow_pointers+5
        .for(var x=0;x<11;x++){
            lda arrow_5+x,x
            sta $28*x+arrow_5_pos    
          //  inx 
        }


/*
        ldy #$20
!:
        dey 
        bne !-
*/
       

//arrow 4 
      //  ldx arrow_pointers+4
        .for(var x=0;x<14;x++){
            lda arrow_4+x,x
            sta $28*x+arrow_4_pos    
          //  inx 
        }

        rts

wait_flash:
        inc fld+1
fld:
        lda #0 
        cmp #FLASH_DELAY
        bne !+

        lda #0 
        sta fld+1
        lda #<move_bar 
        sta flash_fn+1
        lda #>move_bar 
        sta flash_fn+2
        
!:
        rts

.import source("data/arrows.asm")