.import source("charset_data.asm")

.var char_pt = 0 

.var char_bytes = List()

.var luminance_hash = Hashtable()

.for(var x=0;x<=255;x++){
    .eval luminance_hash.put("lum_"+x,List())
}

.for(var x=0;x<rom_charset_bytes.size()/8;x++){
    
    .var character_index = x*8
    .var luminance_value = 0

    .for(var y=0;y<8;y++){
        .var next_byte = rom_charset_bytes.get(y+character_index)

        .if(x >= 128){ //inverted charset?
            .eval next_byte = next_byte ^ $ff
        }
       
        .var c = next_byte & %00000001
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %00000010
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %00000100
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %00001000
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %00010000
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %00100000
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %01000000
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        .eval c = next_byte & %10000000
        .if(c>0){
            .eval luminance_value = luminance_value+1
        }
        

      
    }

   // .print("Luminanza val "+luminance_value)



    .eval luminance_hash.get("lum_"+luminance_value).add(x)
}

.var luminance_values = luminance_hash.keys()

//.print(luminance_values)

.for(var x=0; x<luminance_values.size(); x++){
   
    .var char_list = luminance_hash.get("lum_"+x)
    .if(char_list.size()>0){
         .print ("luminance_"+x+":")
         .var lum_str = ".byte "
         .for(var c=0;c<char_list.size();c++){
            .var nx = char_list.get(c)
            .eval lum_str = lum_str+ "$"+toHexString(nx)+","
         }
          
        .print(lum_str.substring(0,lum_str.size()-1))
    }
  
}