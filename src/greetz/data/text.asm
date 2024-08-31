greetz:
.var max_len = 0
.for(var x=0;x<greetz_list.size();x++){
    .if(greetz_list.get(x).size()>max_len){
        .eval max_len = greetz_list.get(x).size()
    }
}

.for(var x=0;x<greetz_list.size();x++){
    .var name = greetz_list.get(x)

    .var name_len = name.size()
    .var difference = ceil(max_len-name_len)/2
    /*
    .if(difference>0){
        .for(var x=0;x<difference;x++){
            .eval name = " "+name
        }
    }*/
    
    .text name
    .byte 0
}

