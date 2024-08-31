.const screen = $8000
.const basic_upstart = $401
.const VIA_PORT_B = $e840
.const scenes_block_2 = $6300

.macro wait_frame(){
    !:
        lda VIA_PORT_B
        and #$20 
        bne !-

!:
        lda VIA_PORT_B
        and #$20 
        beq !-
}