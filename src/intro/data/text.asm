.var scrolltext = " A GREEN LIGHT THAT NEVER GOES OUT. A BRIGHT SHINING STAR IN THE HEART OF YOUR COMMODORE PET. GENESIS PROJECT ARE BACK WITH A DEMO CODED BY ELDER0010 IN 2022 TO CELEBRATE FORTYFIVE YEARS OF "
.eval scrolltext+= "COOLNESS OF ONE THE SEXIEST MACHINES EVER CREATED.                                     "

.const chars_offset = List()

.const line_offset = 5*40
.var c_offs = 0;
.for(var y=0;y<=4;y++){
    .for (var x=0;x<=7;x++){
        .eval c_offs = [x*5]+[y*line_offset]
        .eval chars_offset.add(charset+c_offs)
    }
}

.pc = * "  chars address lo"
chars_lo:
.for(var x=0;x<chars_offset.size();x++){
    .byte <chars_offset.get(x)
}
.byte <blank_space

.pc = * "  chars address hi"
chars_hi:
.for(var x=0;x<chars_offset.size();x++){
    .byte >chars_offset.get(x)
}
.byte >blank_space

.macro convertText() {
    .for (var x=0;x<scrolltext.size();x++){
        .var c = scrolltext.charAt(x)
        .var b = 0
        .if (c=="A"){
            .eval b=0
        }
        .if (c=="B"){
            .eval b=1
        }
        .if (c=="C"){
            .eval b=2
        }
        .if (c=="D"){
            .eval b=3
        }
        .if (c=="E"){
            .eval b=4
        }
        .if (c=="F"){
            .eval b=5
        }
        .if (c=="G"){
            .eval b=6
        }
        .if (c=="H"){
            .eval b=7
        }
        .if (c=="I"){
            .eval b=8
        }
        .if (c=="J"){
            .eval b=9
        }
        .if (c=="K"){
            .eval b=10
        }
        .if (c=="L"){
            .eval b=11
        }
        .if (c=="M"){
            .eval b=12
        }
        .if (c=="N"){
            .eval b=13
        }
        .if (c=="O"){
            .eval b=14
        }
        .if (c=="P"){
            .eval b=15
        }
        .if (c=="Q"){
            .eval b=16
        }
        .if (c=="R"){
            .eval b=17
        }
        .if (c=="S"){
            .eval b=18
        }     
        .if (c=="T"){
            .eval b=19
        }
        .if (c=="U"){
            .eval b=20
        }
        .if (c=="V"){
            .eval b=21
        }        
        .if (c=="W"){
            .eval b=22
        }
        .if (c=="X"){
            .eval b=24
        }
        .if (c=="Y"){
            .eval b=25
        }
        .if (c=="Z"){
            .eval b=26
        }
        .if (c=="0"){
            .eval b=14
        }
        .if (c=="1"){
            .eval b=27
        }
        .if (c=="2"){
            .eval b=28
        }
        .if (c=="3"){
            .eval b=29
        }
        .if (c=="4"){
            .eval b=30
        }
        .if (c=="5"){
            .eval b=31
        }
        .if (c=="6"){
            .eval b=32
        }
        .if (c=="7"){
            .eval b=33
        }
        .if (c=="8"){
            .eval b=34
        }
        .if (c=="9"){
            .eval b=35
        }
        .if (c=="0"){
            .eval b=36
        }
        .if (c==","){
            .eval b=37
        }
        .if (c=="."){
            .eval b=38
        }
        .if (c==" "){
            .eval b=39
        }

        .byte b
    }
}


