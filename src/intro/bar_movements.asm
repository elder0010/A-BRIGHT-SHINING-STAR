move_rasterbars:
        inc bar_d0+1
bar_d0:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb0

        lda #0 
        sta bar_d0+1

        lda bar0_pt
        clc 
        adc #1
        and #$3f
        sta bar0_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=0;x<7;x++){
            sta screen+[15*$28]+x
        }
skipb0:

        inc bar_d1+1
bar_d1:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb1

        lda #0 
        sta bar_d1+1

        lda bar1_pt
        clc 
        adc #1
        and #$3f
        sta bar1_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=0;x<8;x++){
            sta screen+[16*$28]+x
        }
skipb1:

        inc bar_d2+1
bar_d2:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb2

        lda #0 
        sta bar_d2+1

        lda bar2_pt
        clc 
        adc #1
        and #$3f
        sta bar2_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=0;x<9;x++){
            sta screen+[17*$28]+x
        }
skipb2:

        inc bar_d3+1
bar_d3:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb3

        lda #0 
        sta bar_d3+1

        lda bar3_pt
        clc 
        adc #1
        and #$3f
        sta bar3_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=35;x<40;x++){
            sta screen+[5*$28]+x
        }
skipb3:

//questa da rifare
        inc bar_d4+1
bar_d4:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb4

        lda #0 
        sta bar_d4+1

        lda bar4_pt
        clc 
        adc #1
        and #$3f
        sta bar4_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=36;x<40;x++){
            sta screen+[6*$28]+x
        }
skipb4:

        inc bar_d5+1
bar_d5:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb5

        lda #0 
        sta bar_d5+1

        lda bar5_pt
        clc 
        adc #1
        and #$3f
        sta bar5_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=36;x<40;x++){
            sta screen+[8*$28]+x
        }
skipb5:

        inc bar_d6+1
bar_d6:
        lda #0
        cmp #BAR_MOVEMENT_DELAY
        bne skipb6

        lda #0 
        sta bar_d6+1

        lda bar6_pt
        clc 
        adc #1
        and #$3f
        sta bar6_pt

        tax 
        lda bars_sintable,x 
         
        .for(var x=33;x<39;x++){
            sta screen+[11*$28]+x
        }
skipb6:
        rts