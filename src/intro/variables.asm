.const SCROLLTEXT_LEN_HI = 4
.const SCROLLTEXT_LEN_LO = 86

//.const kernal_reset = $fd38

.const INTRO_DELAY = $70
.const SCROLL_DELAY = 1
.const BAR_MOVEMENT_DELAY = 2
.const INTRO_SCROLL_DELAY = 1

.const char_pos = $20
.const char_size = $21
.const scroll_tick = $02
.const hi_b = $23

.const bar0_pt = $24
.const bar1_pt = $25
.const bar2_pt = $26
.const bar3_pt = $27
.const bar4_pt = $28
.const bar5_pt = $29
.const bar6_pt = $2a

.const scroll_start_pos = screen + [20*40] 
.const scroll_end_pos = scroll_start_pos +$27

.const margin_left_zp = $2c //word
.const margin_right_zp = $2e //word

.const stack_adrr_lo = $33
.const stack_adrr_hi = $34
.const stack_pt_bk = $35