/*
draw_screen:
        ldx #0
!:
        lda logo,x
        sta screen,x
        lda logo+$100,x
        sta screen+$100,x
        lda logo+$200,x
        sta screen+$200,x
        //lda #$20
        lda logo +$300,x
        sta screen+$300,x
        dex
        bne !-
        rts
*/

scroll:

        inc scroll_tick
        lda scroll_tick 
        cmp #SCROLL_DELAY
        beq gosc
        rts

gosc:
        lda #0 
        sta scroll_tick 

        ldx #$0
!:
        lda scroll_start_pos+1,x
        sta scroll_start_pos,x 

        lda $28+scroll_start_pos+1,x
        sta $28+scroll_start_pos,x 
        
        lda $28*2+scroll_start_pos+1,x
        sta $28*2+scroll_start_pos,x 

        lda $28*3+scroll_start_pos+1,x
        sta $28*3+scroll_start_pos,x 

        lda $28*4+scroll_start_pos+1,x
        sta $28*4+scroll_start_pos,x 
    
        inx 
        cpx #$28
        bne !-

        lda char_pos
c_size_0:
        cmp #$ff
        beq !+
        jsr fetch_next_char
        jmp writechr
!:
        jsr fetch_blank_space

writechr:
        ldx char_pos
char_l0:
        lda charset_data,x
        sta scroll_end_pos

char_l1:
        lda charset_data,x
        sta scroll_end_pos+$28

char_l2:
        lda charset_data,x
        sta scroll_end_pos+$28*2

char_l3:
        lda charset_data,x
        sta scroll_end_pos+$28*3

char_l4:
        lda charset_data,x
        sta scroll_end_pos+$28*4

        inc char_pos 
        lda char_pos

c_size_1:
        cmp #$ff
        bne !+
        lda #0
        sta char_pos 

        clc
        lda fetch_next_char+1
        adc #1 
        sta fetch_next_char+1
        bcc !+
        inc fetch_next_char+2
!:
        rts

fetch_blank_space:
        lda #<blank_space
        sta char_l0+1
        sta char_l1+1
        sta char_l2+1
        sta char_l3+1
        sta char_l4+1
        
        lda #>blank_space
        sta char_l0+2
        sta char_l1+2
        sta char_l2+2
        sta char_l3+2
        sta char_l4+2
        rts

fetch_next_char:
        ldx text

        inc letters_lo+1
letters_lo:
        lda #0
        bne !+
        inc letters_hi+1
!:

letters_hi:
        lda #0 
        cmp #SCROLLTEXT_LEN_HI // 4 
        bne !+
        
        lda letters_lo+1
        cmp #SCROLLTEXT_LEN_LO //86
        bne !+
        lda #<outro
        sta state_transition+1
        lda #>outro
        sta state_transition+2
        lda #$2c //BIT
        sta state_main
        rts
!:
        /*
        cpx #$ff
        bne !+

        lda #<text 
        sta fetch_next_char+1

        lda #>text
        sta fetch_next_char+2

        ldx text
!:
*/

        lda chars_size,x 
        sta c_size_0+1
        clc 
        adc #1
        sta c_size_1+1

//---------------------------------------------
        lda chars_lo,x 
        clc 
        sta char_l0+1
        tay

        lda chars_hi,x 
        sta char_l0+2
        sta hi_b
        tya  
//---------------------------------------------
        clc 
        adc #$28
        sta char_l1+1
        tay
         
        lda hi_b
        bcc !+
        clc 
        adc #1 
        sta hi_b
!:
        sta char_l1+2

//---------------------------------------------      
        tya 
        clc 
        adc #$28
        sta char_l2+1
        tay 

        lda hi_b 
        bcc !+
        clc 
        adc #1
        sta hi_b
!:
        sta char_l2+2
//---------------------------------------------
        tya 
        clc
        adc #$28
        sta char_l3+1
        tay 

        lda hi_b 
        bcc !+
        clc 
        adc #1
        sta hi_b
!:
        sta char_l3+2
//---------------------------------------------
        tya 
        clc 
        adc #$28
        sta char_l4+1
        tay 
        lda hi_b 
        bcc !+
        clc 
        adc #1
        sta hi_b
!:
        sta char_l4+2

        rts

intro:
        lda #0
        cmp #INTRO_DELAY
        inc intro+1
        bne !+
        lda #<scroll
        sta main_fn+1
        lda #>scroll
        sta main_fn+2
!:
        rts


outro:
        lda #$20
        ldx #$0
screenoff:
        sta screen,x
        inx
        cpx #$28
        bne screenoff

        clc
        lda screenoff+1
        adc #$28
        sta screenoff+1
        bcc !+
        inc screenoff+2 
!:
        inc rowct+1
rowct:
        lda #0
        cmp #25
        bne !+
        ldx stack_pt_bk
        txs
        lda stack_adrr_hi 
        pha 
        lda stack_adrr_lo
        pha 
!:
        rts


/*
test_real_hw:
		clc
 
		lda $e843
		ora #%10000000
		tax
 
		lda $e841
		ora #%10000000
		tay
 
		lda #0
		sta hi_b
		stx $e843
		sty $e841
loop:
		adc #1
		bcc !+
		inc hi_b
		clc
!:
		bit $e841
		bne loop
 
		ldx hi_b
		stx $8000
		sta $8001
		rts*/