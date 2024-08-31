door_movement:        
        :wait_frame()
        ldx #0
        stx frame_delay_pt
!:
        lda background_img,x 
        sta screen,x 
        lda background_img+$100,x 
        sta screen+$100,x 
        lda background_img+$200,x 
        sta screen+$200,x 
        lda background_img+$300,x 
        sta screen+$300,x 
        dex 
        bne !-

        ldx frame_delay_pt
        lda global_delay_table_frames,x
        sta door_open_anim_speed+1
        inc frame_delay_pt
       
door_mov_frame:
!:
        lda VIA_PORT_B
        and #$20 
        bne !-
state_door:
        jsr wait_door 
      
endstate_door:      
        nop 
low_border:
!:
        lda VIA_PORT_B
        and #$20 
        beq !-
        jmp door_mov_frame

//Wait before door opening
wait_door:
        lda #0 
        cmp #WAIT_BEFORE_DOOR_OPEN
        bne !+
        lda #<open_door
        sta state_door+1
        lda #>open_door
        sta state_door+2
!:
        inc wait_door+1
        rts

//Play the animation frames
open_door:
 
        inc frtk+1

frtk:
        lda #0 
door_open_anim_speed:
        cmp #$ff
        beq  !+
        rts
!:
        lda #0 
        sta frtk+1

        ldx frame_delay_pt
        lda global_delay_table_frames,x
        sta door_open_anim_speed+1
        inc frame_delay_pt

frame_pt:
        ldx #0 
        lda fr_addr_lo,x 
        sta frame_addr
        lda fr_addr_hi,x 
        sta frame_addr+1

        inc frame_pt+1
        lda frame_pt+1
        cmp #4
        bne !+
        lda #<wait_for_scroll
        sta state_door+1
        lda #>wait_for_scroll
        sta state_door+2
        rts
!:
.const frame_screen_tg = screen + 23
    
        lda #0 
        sta rowct+1

        lda #<frame_screen_tg 
        sta frame_dst
        lda #>frame_screen_tg 
        sta frame_dst+1
        
nextcp:
        ldy #0 
        .for(var x=0;x<17;x++){
            
            lda (frame_addr),y 
            sta (frame_dst),y 
            .if(x!=17){
                iny 
            }
        }

        inc rowct+1
rowct:
        lda #0 
        cmp #25
        beq finished
        clc 
        lda frame_addr
        adc #17
        sta frame_addr
        bcc !+
        inc frame_addr+1
!:
        clc 
        lda frame_dst
        adc #$28
        sta frame_dst
        bcc !+
        inc frame_dst+1
!:
        jmp nextcp

finished:
        rts

//scroll delay (before)
wait_for_scroll:
        lda #0 
        cmp #WAIT_BEFORE_SCROLL_DOOR
        bne !+
        lda #<scroll_door
        sta state_door+1
        lda #>scroll_door
        sta state_door+2

        lda #0 
        sta frame_delay_pt
        ldx frame_delay_pt
        lda global_delay_table_frames_scroll,x
        sta scroll_delay+1
        inc frame_delay_pt
!:
        inc wait_for_scroll+1
        rts

//actual scroll
scroll_door:
        inc scdrt+1
scdrt:
        lda #0
.pc = * "scroll delay"
scroll_delay:
        cmp #$ff
        bne !+

        lda #0 
        sta scdrt+1

        ldx frame_delay_pt
        lda global_delay_table_frames_scroll,x
        sta scroll_delay+1
        inc frame_delay_pt

        //scroll
        jsr shift_right_fr

!:
       
        rts

shift_right_fr:
        lda #$26
        sta scroll_pt

        ldx #38
scrollr:
.for(var y=0;y<25;y++){
        lda [y*$28]+screen,x
        sta [y*$28]+screen+1,x 
}
        dex 
        cpx #26
        beq !+
        jmp scrollr
!:

scrol_offs:
        ldx #0 
        lda #BLANK_PIXEL
.for(var y=0;y<25;y++){
        sta [y*$28]+screen+27,x 
} 

        inc scrol_offs+1
        lda scrol_offs+1
        cmp #8
        bne !+
        lda #<wait_final
        sta state_door+1
        lda #>wait_final
        sta state_door+2
!:
        rts

//Wait before door opening
wait_final:
        lda #0 
        cmp #WAIT_AFTER_DOOR_OPEN
        bne !+
        lda #$60 //rts 
        sta endstate_door
!:
        inc wait_final+1
        rts


global_delay_table_frames:
.byte 1,5,6

global_delay_table_frames_scroll:
.byte 32,6,3,1,3,4,6,15
