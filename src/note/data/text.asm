page_0:
.text("        A BRIGHT SHINING STAR           ")
.text("                                        ")
.text("                                        ")
.text("A Genesis Project demo coded in 2022    ")
.text("                                        ")
.text("Credits:                                ")
.text("                                        ")
.text("Elder0010 - Code, Graphics              ")
.text("LRNZ - PECBM Graphics                   ")
.text("                                        ")
.text("Hope you enjoyed the show!              ")
.text("Time for some tech info, allright?      ")
.text("                                        ")
.text("This demo is loaded between $02c0/$55e9.")
.text("Each scene is crunched using Exomizer   ")
.text("and gets decompressed in the remaining  ")
.text("16KB of ram.                            ")
.text("                                        ")
.text("The total size of the uncompressed      ")
.text("scenes is more than 80KB, so it's a     ")
.text("pretty good compression!                ")
.text("                                        ")
.byte 0

page_1:
.text("The main goal of this project is to     ")
.text("overcome the 8px blockiness of the PET. ")
.text("                                        ")
.text("Some info about the PET limitations:    ")
.text("                                        ")
.text("- single screen buffer                  ")
.text("- non redefinable ROM charset           ")
.text("- no raster interrupts                  ")
.text("- no CRTC! (as on 40xx and 80 models)   ")
.text("- no sound (at least in the stock 2001) ")
.text("- 32KB ram (best case - required for us)")
.text("                                        ")
.text("I tried to exploit the CRT monitor as   ")
.text("much as possible for the effects.       ")
.text("For example, a sort of smooth scroll    ")
.text("feeling has been obtained in the intro  ")
.text("and in the space invaders scene.        ")
.text("                                        ")
.text("Since the tube phosphors have a slow    ")
.text("decay time, moving things very fast     ")
.text("(8px / frame) fools the eye enough..    ")
.text("                                        ")
.byte 0

page_2:
.text("PECBM details:                          ")
.text("                                        ")
.text("The new video mode is able to display   ")
.text("mixed PET and hi-res graphics. The trick")
.text("is to rewrite the character pointers    ")
.text("every rasterline. The length of each    ")
.text("line is 64 cycles, therefore you can    ")
.text("rewrite up to 10 characters using an    ")
.text("unrolled loop, leading to an 80px wide  ")
.text("area for the hi-res graphics.           ")
.text("                                        ")
.text("Other characters of the same char-line  ")
.text("can be used for standard PETSCII gfx.   ")
.text("The character ROM has been analyzed to  ")
.text("find all the usable pixels combinations ")
.text("for each 0/7th line of each character.  ")
.text("Keep in mind that each 0/7th line can be")
.text("chosen between each 0/7th line of any   ")
.text("character.                              ")
.text("                                        ")
.text("                                        ")
.byte 0

page_3:
.text("In short: since the character line      ")
.text("counter loops from 0 to 7, if you are   ")
.text("for example at line 2, you can choose to")
.text("display any line 2 of any character.    ")
.text("                                        ")
.text("Considering that the whole charset is   ")
.text("available also in reverted mode, there  ")
.text("are enough choices available to display ")
.text("complex hi-res graphics.                ")
.text("                                        ")
.text("PECBM has been used in the door scene,  ")
.text("as well as in the astronaut face scene, ")
.text("in the accept no limits slogan and in   ")
.text("credits scenes.                         ")
.text("                                        ")
.text("The last two mentioned scenes show that ")
.text("PECBM animations are possible, even     ")
.text("though some compromises must be done.   ")
.text("                                        ")
.byte 0

page_4:
.text("The PECBM full screen graphics have     ")
.text("been created using a PETSCII editor in  ")
.text("conjunction with a custom PECBM editor  ")
.text("available at:                           ")
.text("                                        ")
.text("www.elder0010.com/uploads/PECBM         ")
.text("                                        ")
.text("I'm too old for this Javascript stuff,  ")
.text("so a thousand thanks are flying to      ")
.text("Raffaele Rasini for coding the PECBM    ")
.text("editor following my specs just in time  ")
.text("to let us release at the compo!         ")
.text("                                        ")
.text("The PECBM editor uses the Levenshtein   ")
.text("Distance algorithm to convert a stock   ")
.text("80x200 1bit image to PECBM format.      ")
.text("                                        ")
.text("Allright! Enough for this time.         ")
.text("                                        ")
.text("This is Elder0010 signing off.          ")
.text("                                        ")
.byte 0

page_5:
.text("LRNZ on the keys now:                   ")
.text("                                        ")
.text("At first, when I started working on this")
.text("demo I thought it would be nice to      ")
.text("participate, so to get rid of that sense")
.text("of frustration I've been carrying around")
.text("since I was a kid - that is being able  ")
.text("to publish a piece of graphics on a home")
.text("that dates back to my youth.            ")
.text("                                        ")
.text("It would have been very important for   ")
.text("me. But still, I'm a person used to     ")
.text("exploring the boundaries of the language")
.text("to find new territories, always keeping ")
.text("my eye on the future.                   ")
.text("                                        ")
.text("For this, I really have to thank        ")
.text("Elder0010, for involving me in this     ")
.text("dangerous adventure.                    ")
.text("                                        ")
.byte 0

page_6:
.text("Being able to innovate on a 45 years old")
.text("machine, and so facing the brutal limits")
.text("of PET, gave me the rare chance to      ")
.text("rethink my visual form from the ground  ")
.text("up.                                     ")
.text("                                        ")
.text("It's been wonderful to venture into     ")
.text("these ancient, neglected, and abandoned ")
.text("places, to discover their secrets, and  ")
.text("to find a priceless treasure.           ")
.text("                                        ")
.text("                                        ")
.text("                                        ")
.text("                                        ")
.text("                                        ")
.byte 0

.var pages = List().add(page_0,page_1,page_2,page_3, page_4, page_5, page_6)

page_addr_lo:
.for(var x=0;x<pages.size();x++){
    .byte <pages.get(x)
}

page_addr_hi:
.for(var x=0;x<pages.size();x++){
    .byte >pages.get(x)
}



/*
At first, when I started working on this demo I thought it would be nice to participate, so to get rid of that sense of frustration I've been carrying around since I was a kid – that is being able to publish a piece of graphics on a home computer that dates back to my youth. 

It would have been very important for me.

 But still, I’m a person used to exploring the boundaries of the language to find new territories, always keeping my eye on the future. 
 
 For this, I really have to thank Elder0010, for involving me in this dangerous adventure. 
 
 
 Being able to innovate on a 45-year-old machine, and so facing the brutal limits of PET, gave me the rare chance to rethink my visual form from the ground up. 
It's been wonderful to venture into these ancient, neglected, and abandoned places, to discover their secrets, and to find a priceless treasure.

*/