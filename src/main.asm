/**
A bright shining star

2022 G*P
Code: Elder0010
*/
.import source "variables.asm"

.pc = $2c0 "[exodecrunch]"
.import source "exomizer/exodecrunch.asm"

*= basic_upstart "[basic upstart]"
.byte $0e,$04,$0a,$00,$9e,$20,$28,$31,$30,$34,$30,$29,$00,$00,$00
start:
        jmp main_code

 .pc = * "[exo decrunch table]"
exod_decrunch_table:
        .import source ("exomizer/exo_decrunch_table.asm")

.pc = * "[main routine]"
 main_code:
        sei
        cld

        jsr relocate_scenes_b2

        jsr decrunch_next_part 
        jsr $5000 //go_disclaimer

        jsr decrunch_next_part
        jsr $5000 //go_intro
       
        jsr decrunch_next_part 
        jsr $5000 //go_parallax

        jsr decrunch_next_part 
        jsr $5000 //go_sinebars
        
        jsr decrunch_next_part 
        jsr $5000 //go_tulip

        jsr decrunch_next_part 
        jsr $5000 //go_symbol

        jsr decrunch_next_part 
        jsr $4a00 //go_bitmap

        jsr decrunch_next_part 
        jsr $5000 //go_slogan

        jsr decrunch_next_part 
        jsr $5000 //go_nave

        jsr decrunch_next_part 
        jsr $4600 //go_astronaut

        jsr decrunch_next_part 
        jsr $5000 //go_greetz

        jmp *

decrunch_next_part:
        ldx #0 
        lda parts_addr_lo,x
        sta _byte_lo

        lda parts_addr_hi,x 
        sta _byte_hi

        inc decrunch_next_part+1
        jsr exod_decrunch

//delay pre-scene
delay_ofs:
        ldx #0 
        inc delay_ofs+1
        lda parts_delay,x 
       
        bne !+
        rts 
!:
        sta delay_amt+1
        lda #$0
        sta delay_tk+1

round_del: 
frame_tks: 
        lda #0 
        :wait_frame()
        inc frame_tks+1
        lda frame_tks+1 

        cmp #60
        bne frame_tks

        lda #0 
        sta frame_tks+1
        inc delay_tk+1

delay_tk:
        lda #0 
delay_amt:
        cmp #$ff 
        beq !+
        jmp round_del
!:
        rts 

.var parts_list = List().add(disclaimer, intro, parallax, sinebars, tulip, symbol, bitmap, slogan, nave, astronaut, greetz)
parts_addr_lo:
.for(var x=0;x<parts_list.size();x++){
    .byte <parts_list.get(x)
}

parts_addr_hi:
.for(var x=0;x<parts_list.size();x++){
    .byte >parts_list.get(x)
}

.var delay_list = List().add(
    0,  //disclaimer
    0,  //intro
    0,  //parallax
    0,  //sinebars
    1,  //tulip
    0,  //symbol
    1,  //bitmap
    1,  //slogan
    1,  //nave
    0,  //astronaut
    2   //greetz
    )
parts_delay:
.for(var x=0;x<delay_list.size();x++){
    .byte delay_list.get(x)
}

.pc = * "Scenes block 1"
.pc = * "[scene] sinebars"
.import binary("src/sinebars/sinebars_exo.bin")
sinebars:
.pc = * "[scene] symbol"
.import binary("src/symbol/symbol_exo.bin")
symbol:
.pc = * "[scene] tulip"
.import binary("src/tulip/tulip_exo.bin")
tulip:
.pc = * "[scene] bitmap"
.import binary("src/bitmap/bitmap_exo.bin")
bitmap:


.pc = * "[scene] greetz"
.import binary("src/greetz/greetz_exo.bin")
greetz:
.pc = * "[scene] nave"
.import binary("src/nave/nave_exo.bin")
nave:
.pc = * "[scene] astronaut"
.import binary("src/astronaut/astronaut_exo.bin")
astronaut:
.pc = * "[scene] slogan"
.import binary("src/slogan/slogan_exo.bin")
slogan:

/*
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
*/


/*
$6300-$62ff Scenes block 2
  $6300-$652c [scene] disclaimer
  $652d-$6c8c [scene] intro
  $6c8d-$719f [scene] parallax
*/

relocate_scenes_b2:
        ldx #0
!:
src_blob: 
        lda scenes_block_2_blob,x 
dst_blob:
        sta scenes_block_2,x 
        dex
        bne !-

        inc src_blob+2
        inc dst_blob+2
        inc hi_cnt+1
hi_cnt:
        lda #0 
        cmp #$10 
        beq !+
        jmp relocate_scenes_b2
!:
        rts 

.pc = * "Scenes block 2"
scenes_block_2_blob:
.pseudopc scenes_block_2 {
    //.pc = * "[scene] disclaimer"
    .import binary("src/disclaimer/disclaimer_exo.bin")
    disclaimer:
    //.pc = * "[scene] intro"
    .import binary("src/intro/intro_exo.bin")
    intro:
    //.pc = * "[scene] parallax"
    .import binary("src/parallax/parallax_exo.bin")
    parallax:
}