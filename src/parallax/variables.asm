
.const PARALLAX_FX_LEN = $2

.const parallax_margin_top = 2
.const parallax_height = 21
.const layer_0_square_size = 6

.const layer_0_lut_even = $68c4 
.const layer_0_lut_odd = layer_0_lut_even+$80
.const layer_0_lut_even_tmp = layer_0_lut_odd+$80
.const layer_0_lut_odd_tmp = layer_0_lut_even_tmp+$50 


.const scroll_tick = $02
.const screen_buf_up = $64a0
.const l0_frame_sel = $5
.const l0_scroll_pt = $6
.const l0_parallax_pt = $37
.const sprite_movement_pt = $38
.const background_y = $49 
.const background_y_pt = $4a
.const background_frame_pt = $4b
.const background_frame_addr_zp = $4c //word

.const final_fade_addr_zp = $6d

.const PIXEL_WHITE = $e0
.const PIXEL_DITHER = $66
.const PIXEL_BLACK = $60
.const PIXEL_HLEFT = $e1
.const PIXEL_HRIGHT = $61