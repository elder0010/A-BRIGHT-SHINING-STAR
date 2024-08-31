.const bars_values = List().add($64,$52,$46,$40,$43,$44,$45,$63)

.const bars_sindata = List().add(
4,3,3,2,2,2,1,1,1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,1,1,1,1,2,2,3,3,3,
4,4,4,5,5,6,6,6,6,7,7,7,7,7,7,7,
7,7,7,7,7,7,7,6,6,6,5,5,5,4,4,4
)


bars_sintable:
.for (var x=0;x<bars_sindata.size();x++){
    .byte bars_values.get(bars_sindata.get(x))
}