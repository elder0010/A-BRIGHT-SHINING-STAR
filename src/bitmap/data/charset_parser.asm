.import source("charset_data.asm")

.var global_character_index = 0
.var char_pt = 0 

.var l0_bytes = List()
.var l1_bytes = List()
.var l2_bytes = List()
.var l3_bytes = List()
.var l4_bytes = List()
.var l5_bytes = List()
.var l6_bytes = List()
.var l7_bytes = List()

.var l0_hash = Hashtable()
.var l1_hash = Hashtable()
.var l2_hash = Hashtable()
.var l3_hash = Hashtable()
.var l4_hash = Hashtable()
.var l5_hash = Hashtable()
.var l6_hash = Hashtable()
.var l7_hash = Hashtable()

.var l0_lookup = List()
.var l1_lookup = List()
.var l2_lookup = List()
.var l3_lookup = List()
.var l4_lookup = List()
.var l5_lookup = List()
.var l6_lookup = List()
.var l7_lookup = List()

.var valid_bytes = List().add(l0_bytes,l1_bytes,l2_bytes,l3_bytes,l4_bytes,l5_bytes,l6_bytes,l7_bytes)
.var hash_cache = List().add(l0_hash,l1_hash,l2_hash,l3_hash,l4_hash,l5_hash,l6_hash,l7_hash)
.var lookups = List().add(l0_lookup,l1_lookup,l2_lookup,l3_lookup,l4_lookup,l5_lookup,l6_lookup,l7_lookup)


.var byte_set = List()

.for(var x=0;x<rom_charset_bytes.size()/2;x++){
    
    .var b = rom_charset_bytes.get(x)
    .eval byte_set.add(b)
}

.for(var x=0;x<rom_charset_bytes.size()/2;x++){
    .var b = rom_charset_bytes.get(x)
    .eval byte_set.add(b^$ff)
}


.print("La size e' "+ toHexString(byte_set.size()))

.for(var x=0;x<byte_set.size();x++){

    //.var next_byte = rom_charset_bytes.get(char_pt+[8*global_character_index])
    
    .var next_byte = byte_set.get(char_pt+[8*global_character_index]) 
    /*
    .var reversed = false


    .if(global_character_index >= 128){ //inverted charset?
        .eval next_byte =  rom_charset_bytes.get(char_pt+[8*[global_character_index-128]]) ^ $ff
    }*/

    .if(!hash_cache.get(char_pt).containsKey(next_byte)){
        //metto il byte
        .eval valid_bytes.get(char_pt).add(next_byte)

        //segno che ho gia' messo il byte 
        .eval hash_cache.get(char_pt).put(next_byte,"1")

        //metto il lookup
        .eval lookups.get(char_pt).add(global_character_index)
    }

    .eval char_pt = char_pt+1
    .if (mod(char_pt,8)==0){
        .eval global_character_index = global_character_index+1
        .eval char_pt = 0
    }
}

/*
.for(var y=0;y<7;y++){
    .eval valid_bytes.get(y).sort()
}
*/
.for(var y=0;y<8;y++){
    .var vb = ""
    .print("var valid_bytes_l" +y+ " = new Uint8Array("+valid_bytes.get(y).size()+")")
    .print("var lookup_l" +y+ " = new Uint8Array("+lookups.get(y).size()+")")

    .for(var x=0;x<valid_bytes.get(y).size();x++){
        .print ("valid_bytes_l" +y+ "["+x+"]=0x"+toHexString(valid_bytes.get(y).get(x))+";")
    }

 
    .for(var x=0;x<lookups.get(y).size();x++){
        .print ("lookup_l" +y+ "["+x+"]=0x"+toHexString(lookups.get(y).get(x))+";")
    }

    .print ("")

    //.print("var line_" +y+ " = new Uint8Array("+vb.substring(0,vb.size()-1)+ ")")
}