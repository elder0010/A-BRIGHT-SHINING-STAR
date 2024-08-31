.var screen_adr = List()
.for(var x=0;x<25;x++){
    .eval screen_adr.add([screen+x*$28]+5)
}

.var screen_stars_adr = List()
.for(var x=0;x<25;x++){
    .eval screen_stars_adr.add([screen+x*$28])
}


.var screen_adr_stars = List()
.for(var x=0;x<25;x++){
    .eval screen_adr.add([screen+x*$28])
}

.var gfx_adr = List()
.for(var x=0;x<75;x++){
    .eval gfx_adr.add(spaceship_gfx+x*$28)
}


screen_r_addr_lo:
.for(var x=0;x<screen_adr.size();x++){
    .byte <screen_adr.get(x)
}

screen_r_addr_hi:
.for(var x=0;x<screen_adr.size();x++){
    .byte >screen_adr.get(x)
}


spaceship_addr_lo:
.for(var x=0;x<gfx_adr.size();x++){
    .byte <gfx_adr.get(x)
}

spaceship_addr_hi:
.for(var x=0;x<gfx_adr.size();x++){
    .byte >gfx_adr.get(x)
}



screen_stars_addr_lo:
.for(var x=0;x<screen_stars_adr.size();x++){
    .byte <screen_stars_adr.get(x)
}

screen_stars_addr_hi:
.for(var x=0;x<screen_stars_adr.size();x++){
    .byte >screen_stars_adr.get(x)
}
