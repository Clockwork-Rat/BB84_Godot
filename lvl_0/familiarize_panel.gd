extends Panel

onready var send_blue = $send_blue
onready var send_green = $send_green
onready var send_zero = $send_zero
onready var send_one = $send_one
onready var rec_blue = $rec_blue
onready var rec_green = $rec_green

enum COLOR_STATE {
	BLUE,
	GREEN,
	NONE
}

enum NUMBER_STATE {
	ZERO,
	ONE,
	NONE
}

var send_color_state = COLOR_STATE.NONE
var send_color_selected = false
var send_number_state = NUMBER_STATE.NONE
var send_number_selected = false
var rec_color_state = COLOR_STATE.NONE
var rec_color_selected = false
var toggle = false

func _input(_event):
	if send_color_selected and send_number_selected and rec_color_selected:
		toggle = true
		send_color_selected = false
		send_number_selected = false
		rec_color_selected = false
	if toggle:
		print( "toggle toggled" )
		toggle = false

func _on_send_blue_pressed():
	send_blue.disabled = true
	send_green.disabled = true
	send_color_state = COLOR_STATE.BLUE
	send_color_selected = true

func _on_send_green_pressed():
	send_blue.disabled = true
	send_green.disabled = true
	send_color_state = COLOR_STATE.GREEN
	send_color_selected = true

func _on_send_zero_pressed():
	send_zero.disabled = true
	send_one.disabled = true
	send_number_state = NUMBER_STATE.ZERO
	send_number_selected = true

func _on_send_one_pressed():
	send_zero.disabled = true
	send_one.disabled = true
	send_number_state = NUMBER_STATE.ONE
	send_number_selected = true

func _on_reset_btn_pressed():
	send_blue.disabled = false
	send_green.disabled = false
	send_zero.disabled = false
	send_one.disabled = false
	rec_blue.disabled = false
	rec_green.disabled = false
	send_color_state = COLOR_STATE.NONE
	send_number_state = NUMBER_STATE.NONE
	rec_color_state = COLOR_STATE.NONE
	send_color_selected = false
	send_number_selected = false
	rec_color_selected = false

func _on_rec_blue_pressed():
	rec_blue.disabled = true
	rec_green.disabled = true
	rec_color_state = COLOR_STATE.BLUE
	rec_color_selected = true

func _on_rec_green_pressed():
	rec_blue.disabled = true
	rec_green.disabled = true
	rec_color_state = COLOR_STATE.GREEN
	rec_color_selected = true
