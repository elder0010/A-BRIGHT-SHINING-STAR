
bg_sprite0:
.byte 32,32,32,32,32,32,32,32,32,32
.byte 32,32,224,224,224,224,32,32,32,32
.byte 32,224,232,224,224,232,224,32,32,32
.byte 224,224,32,224,224,32,224,224,32,32
.byte 232,232,224,232,232,224,232,232,32,32
.byte 32,32,232,32,32,232,32,32,32,32
.byte 32,232,32,232,232,32,232,32,32,32
.byte 232,32,232,32,32,232,32,232,32,32
.byte 32,32,32,32,32,32,32,32,32,32

bg_sprite1:
.byte 32,32,224,224,224,224,224,32,32,32
.byte 32,224,232,232,224,232,232,224,32,32
.byte 224,224,32,32,224,32,32,224,224,32
.byte 232,232,232,224,224,224,232,232,232,32
.byte 32,32,32,232,232,232,32,32,32,32
.byte 32,32,232,32,32,32,232,32,32,32
.byte 32,232,32,32,32,32,32,232,32,32
.byte 232,32,32,32,32,32,32,32,232,32
.byte 32,32,32,32,32,32,32,32,32,32,32

bg_sprite2:
.byte 32,32,232,32,32,32,32,232,32,32
.byte 32,32,32,224,32,32,224,32,32,32
.byte 32,32,224,232,224,224,232,224,32,32
.byte 32,224,224,32,224,224,32,224,224,32
.byte 224,232,224,224,224,224,224,224,232,224
.byte 224,32,224,224,224,224,224,224,32,224
.byte 232,32,32,232,32,32,232,32,32,232
.byte 32,32,232,32,32,32,32,232,32,32
.byte 32,32,32,32,32,32,32,32,32,32


.var bg_sprite_table_0_list = List()
.for (var x=0;x<10;x++){
    .eval bg_sprite_table_0_list.add(bg_sprite0+x*10)
}
bg_sprite_table_0_lo:
.for(var x=0;x<bg_sprite_table_0_list.size();x++){
    .byte <bg_sprite_table_0_list.get(x)
}

bg_sprite_table_0_hi:
.for(var x=0;x<bg_sprite_table_0_list.size();x++){
    .byte >bg_sprite_table_0_list.get(x)
}

.var bg_sprite_table_1_list = List()
.for (var x=0;x<10;x++){
    .eval bg_sprite_table_1_list.add(bg_sprite1+x*10)
}
bg_sprite_table_1_lo:
.for(var x=0;x<bg_sprite_table_1_list.size();x++){
    .byte <bg_sprite_table_1_list.get(x)
}

bg_sprite_table_1_hi:
.for(var x=0;x<bg_sprite_table_1_list.size();x++){
    .byte >bg_sprite_table_1_list.get(x)
}


.var bg_sprite_table_2_list = List()
.for (var x=0;x<10;x++){
    .eval bg_sprite_table_2_list.add(bg_sprite2+x*10)
}
bg_sprite_table_2_lo:
.for(var x=0;x<bg_sprite_table_2_list.size();x++){
    .byte <bg_sprite_table_2_list.get(x)
}

bg_sprite_table_2_hi:
.for(var x=0;x<bg_sprite_table_2_list.size();x++){
    .byte >bg_sprite_table_2_list.get(x)
}

bg_sprites_tbl_address_lo_lo:
.byte <bg_sprite_table_0_lo, <bg_sprite_table_1_lo, <bg_sprite_table_2_lo

bg_sprites_tbl_address_lo_hi:
.byte >bg_sprite_table_0_lo, >bg_sprite_table_1_lo, >bg_sprite_table_2_lo

bg_sprites_tbl_address_hi_lo:
.byte <bg_sprite_table_0_hi, <bg_sprite_table_1_hi, <bg_sprite_table_2_hi

bg_sprites_tbl_address_hi_hi:
.byte >bg_sprite_table_0_hi, >bg_sprite_table_1_hi, >bg_sprite_table_2_hi


bg_sprite_sequence:
.byte 1,0,2,0,1,0,2,1,0,2,1,0,2,1,0,2
