extends Panel

onready var send_blue = $send_blue
onready var send_green = $send_green
onready var send_zero = $send_zero
onready var send_one = $send_one
onready var rec_blue = $rec_blue
onready var rec_green = $rec_green
onready var result = $result
onready var reset = $reset_btn

var walkthrough = false

signal pressed_correct_button
signal practice

onready var notebook_panel_text = $"./../notebook_panel/notebook_text"

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

func _ready():
	send_blue.disabled = true
	send_green.disabled = true
	send_zero.disabled = true
	send_one.disabled = true
	rec_blue.disabled = true
	rec_green.disabled = true
	reset.disabled = true

func _input(_event):
	if send_color_selected and send_number_selected and rec_color_selected:

		emit_signal("practice")

		send_color_selected = false
		send_number_selected = false
		rec_color_selected = false
		
		var temp = 0
		var run_string = ""
		
		if send_color_state == COLOR_STATE.BLUE:
			run_string += "blue "
		else:
			run_string += "red "
			
		if send_number_state == NUMBER_STATE.ZERO:
			run_string += "0 "
		else:
			run_string += "1 "
			
		if rec_color_state == COLOR_STATE.BLUE:
			run_string += "blue "
		else:
			run_string += "red "

		if walkthrough:
			reset.disabled = false
			

		randomize()
		if send_color_state == rec_color_state:
			if send_number_state == NUMBER_STATE.ZERO:
				result.text = "0"
				run_string += "0 "
			else:
				result.text = "1"
				run_string += "1 "
		else:
			temp = rand_range(0, 2)
			temp = floor(temp)
			result.text = String(temp)
			run_string += String(temp)
			
		run_string += "\n"
		notebook_panel_text.text += run_string

func _on_send_blue_pressed():
	send_blue.disabled = true
	send_green.disabled = true
	send_color_state = COLOR_STATE.BLUE
	send_color_selected = true
	send_green.hide()

	if walkthrough:
		send_zero.disabled = false
		send_one.disabled = false
		emit_signal("pressed_correct_button")

func _on_send_green_pressed():

	if not walkthrough:
		send_blue.disabled = true
		send_green.disabled = true
		send_color_state = COLOR_STATE.GREEN
		send_color_selected = true
		send_blue.hide()
	else:
		pass

func _on_send_zero_pressed():
	send_zero.disabled = true
	send_one.disabled = true
	send_number_state = NUMBER_STATE.ZERO
	send_number_selected = true
	send_one.hide()

	if walkthrough:
		rec_blue.disabled = false
		rec_green.disabled = false
		emit_signal("pressed_correct_button")

func _on_send_one_pressed():

	if not walkthrough:
		send_zero.disabled = true
		send_one.disabled = true
		send_number_state = NUMBER_STATE.ONE
		send_number_selected = true
		send_zero.hide()
	else:
		pass

func _on_reset_btn_pressed():
	send_blue.disabled = false
	send_blue.show()
	
	send_green.disabled = false
	send_green.show()
	
	send_zero.disabled = false
	send_zero.show()
	
	send_one.disabled = false
	send_one.show()
	
	rec_blue.disabled = false
	rec_blue.show()
	
	rec_green.disabled = false
	rec_green.show()
	
	send_color_state = COLOR_STATE.NONE
	send_number_state = NUMBER_STATE.NONE
	rec_color_state = COLOR_STATE.NONE
	
	send_color_selected = false
	send_number_selected = false
	rec_color_selected = false
	
	result.text = ""

func _on_rec_blue_pressed():
	if not walkthrough:
		rec_blue.disabled = true
		rec_green.disabled = true
		rec_color_state = COLOR_STATE.BLUE
		rec_color_selected = true
		rec_green.hide()

func _on_rec_green_pressed():
	rec_blue.disabled = true
	rec_green.disabled = true
	rec_color_state = COLOR_STATE.GREEN
	rec_color_selected = true
	rec_blue.hide()

	if walkthrough:
		reset.disabled = false
		emit_signal("pressed_correct_button")


func _on_Control_training_mode_ended():
	walkthrough = false

func _on_Control_walkthrough_ended():
	walkthrough = true
	send_blue.disabled = false
	send_green.disabled = false
	
func _enable_panel():
	send_blue.disabled = false
	send_green.disabled = false
	send_zero.disabled = false
	send_one.disabled = false
	rec_blue.disabled = false
	rec_green.disabled = false
