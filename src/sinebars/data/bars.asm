.const p8 = $e0 
.const p7 = $e5 
.const p6 = $f4 
.const p5 = $f5 
.const p4 = $e1 
.const p3 = $76
.const p2 = $6a 
.const p1 = $67
.const p0 = $60

.const fine_tuning_index = List().add(p0,p1,p2,p3,p4,p5,p6,p7,p8)

.const line_size = 64
.function calc_line (size){
    .var line_bf = List()

    .for(var x=0;x<8;x++){
        .eval line_bf.add(p8)
    }

    .var fill_blocks = floor(size/8)
    .var fine_tuning = mod(size,8)

    .for(var x=fill_blocks;x<line_bf.size();x++){
        .eval line_bf.set(x,p0)
    }
    .eval line_bf.set(fill_blocks,fine_tuning_index.get(fine_tuning))

    .eval line_bf = line_bf.reverse()
    .return line_bf
}
.align $100
.pc = * "sizes tab"
sizes_tab:
.for (var x=0;x<32;x++){
   .var l = calc_line(x)
    .for (var a=0;a<l.size();a++){
        .byte l.get(a)
    }
}



.align $100 
.pc = * "sizes tab 2"
sizes_tab2:
.for (var x=32;x<64;x++){
   .var l = calc_line(x)
    .for (var a=0;a<l.size();a++){
        .byte l.get(a)
    }
}

.align $100
.pc = * "sizes addr lo"
size_addr_lo:
.for(var x=0;x<32;x++){
    .byte <[sizes_tab+x*8]
}
.for(var x=0;x<32;x++){
    .byte <[sizes_tab2+x*8]
}

.pc = * "sizes addr hi"
size_addr_hi:
.for(var x=0;x<32;x++){
    .byte >[sizes_tab+x*8]
}
.for(var x=0;x<32;x++){
    .byte >[sizes_tab2+x*8]
}

