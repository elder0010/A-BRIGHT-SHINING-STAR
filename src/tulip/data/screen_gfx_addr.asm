.var screen_adr = List()
.for(var x=0;x<26;x++){
    .eval screen_adr.add([screen+x*$28])
}

.var gfx_adr = List()
.for(var x=0;x<75;x++){
    .eval gfx_adr.add(tulip_gfx+x*$28)
}


screen_r_addr_lo:
.for(var x=0;x<screen_adr.size();x++){
    .byte <screen_adr.get(x)
}

screen_r_addr_hi:
.for(var x=0;x<screen_adr.size();x++){
    .byte >screen_adr.get(x)
}


tulip_addr_lo:
.for(var x=0;x<gfx_adr.size();x++){
    .byte <gfx_adr.get(x)
}

tulip_addr_hi:
.for(var x=0;x<gfx_adr.size();x++){
    .byte >gfx_adr.get(x)
}