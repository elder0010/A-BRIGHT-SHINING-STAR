.var GREETZ_DELAY = $1a
.var CREDITS_DELAY = $48
.var FINAL_DELAY = $70

.const line_1_margin = 13
.const credits_line_1 = screen + [$5*$28]+line_1_margin

.const line_2_margin = 10
.const credits_line_2 = credits_line_1+$28*14+line_2_margin-line_1_margin
.const PIXEL_WHITE = $e0
.const PIXEL_BLACK = $60

.const x_stripe_margin = 17
.const letter_margin_top = 9

.var FRAME_SPEED = 4
.var frame_pt = $2b
.var slogan_addr = $2c //word

.var star_base =  [screen+x_stripe_margin]+$28*letter_margin_top