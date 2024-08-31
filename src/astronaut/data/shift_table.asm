.var picture = LoadPicture(filename)

.print("Width: "+picture.width)
.print("Height: "+picture.height)

.var color_map = Hashtable()

.var line_px = 320 
.var shift_table = List()
.for(var y=0;y<25;y++){
    .print ("//Line "+y +" height:"+[y*8])
    .var line_blocks = List()
    .for(var x=0;x<40;x++){
        
      
        //.var px_base = picture.getPixel(x*8,y*8)
        //check square
        .var blank = true 
        .for(var s_y=0;s_y<8;s_y++){
            .for(var s_x=0;s_x<8;s_x++){
                .var px = picture.getPixel([x*8]+s_x,[y*8]+s_y)

               .if(px==$000000 || px == $ffffff ){
                    .eval blank = false
                    
                }
            }
        }

        .if(!blank){
            .eval line_blocks.add(x)
        }
    }

    .while(line_blocks.size()<10){
            .eval (line_blocks.add($ff))
    }

    .print(line_blocks)
   
   .for(var x=0;x<line_blocks.size();x++){
    .eval shift_table.add(line_blocks.get(x))
   }
}

/*
.var shift_table = List()

//Line 0 height:0
  .eval shift_table.add(13,16,20,22,23,27,30,32,33,36)
  //Line 1 height:8
  .eval shift_table.add(13,16,20,22,23,26,28,33,34,36)
  //Line 2 height:16
  .eval shift_table.add(6,16,21,24,26,28,31,32,34,36)
  //Line 3 height:24
  .eval shift_table.add(2,3,16,27,28,31,32,255,255,255)
  //Line 4 height:32
  .eval shift_table.add(1,2,3,12,13,14,28,31,32,255)
  //Line 5 height:40
  .eval shift_table.add(1,12,13,14,26,27,28,31,32,34)
  //Line 6 height:48
  .eval shift_table.add(12,14,20,28,34,37,38,255,255,255)
  //Line 7 height:56
  .eval shift_table.add(11,12,14,15,22,23,39,255,255,255)
  //Line 8 height:64
  .eval shift_table.add(10,11,12,14,22,34,35,36,37,255)
  //Line 9 height:72
  .eval shift_table.add(10,11,17,18,21,24,26,38,39,255)
  //Line 10 height:80
  .eval shift_table.add(12,14,17,20,23,24,25,34,39,255)
  //Line 11 height:88
  .eval shift_table.add(2,11,12,14,22,23,24,25,27,28)
  //Line 12 height:96
  .eval shift_table.add(2,12,18,21,23,24,25,26,27,28)
  //Line 13 height:104
  .eval shift_table.add(1,2,3,12,18,21,22,26,27,28)
  //Line 14 height:112
  .eval shift_table.add(12,13,18,19,21,23,24,25,26,28)
  //Line 15 height:120
  .eval shift_table.add(12,13,14,16,17,18,21,25,27,28)
  //Line 16 height:128
  .eval shift_table.add(12,13,16,17,18,19,20,21,27,28)
  //Line 17 height:136
  .eval shift_table.add(12,17,18,19,20,22,23,25,26,27)
  //Line 18 height:144
  .eval shift_table.add(5,12,19,20,22,23,24,25,26,27)
  //Line 19 height:152
  .eval shift_table.add(6,13,17,19,20,22,24,25,26,27)
  //Line 20 height:160
  .eval shift_table.add(7,8,9,13,17,20,21,23,24,25,26)
  //Line 21 height:168
  .eval shift_table.add(8,9,13,14,17,18,20,21,22,23,25)
  //Line 22 height:176
  .eval shift_table.add(7,8,10,13,14,19,20,21,24,25)
  //Line 23 height:184
  .eval shift_table.add(255,255,255,255,255,255,255,255,255,255)
  //Line 24 height:192
  .eval shift_table.add(255,255,255,255,255,255,255,255,255,255)
  */