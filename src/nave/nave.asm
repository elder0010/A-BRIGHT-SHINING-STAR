.import source("../variables.asm")
.import source("variables.asm") 
.import source("data/spaceship.asm")

.pc = $5000
nave:
       // lda #2
     //   sta nave_y
        lda #0 
        sta copy_enabler_pt
        sta final_star_counter

   
        sta spaceship_y
        
        lda #BLANK_PIXEL
        ldx #$0 
!: 
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x 
        sta screen+$300,x
        dex 
        bne !-
 
frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
endstate:      
        nop 
state:
        jsr move_starfield_bg
        jsr move_starfield
     
move_spaceship_fn:
        bit move_spaceship
move_fn_tg:
        jsr intro_delay
      //  jsr move_out_spaceship
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-   
         
        jmp frame

.pc = * "functions"
.import source("functions.asm")

.pc = * "spaceship gfx"
spaceship_gfx:
.for(var x=0;x<spaceship_bytes.size();x++){
    .byte spaceship_bytes.get(x)
}

.pc = * "screen address tbl"
.import source("data/screen_rows.asm")


.import source("starfield.asm")

.import source("starfield_bg.asm")