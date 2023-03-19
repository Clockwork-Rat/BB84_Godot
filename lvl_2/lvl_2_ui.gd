extends Control

onready var send_blue = $practice_panel/send_blue
onready var send_red  = $practice_panel/send_red
onready var send_zero = $practice_panel/send_zero
onready var send_one  = $practice_panel/send_one
onready var eav_blue  = $practice_panel/eav_blue
onready var eav_red   = $practice_panel/eav_red
onready var rec_blue  = $practice_panel/rec_blue
onready var rec_red   = $practice_panel/rec_red
onready var eav_result= $practice_panel/eav_result
onready var rec_result= $practice_panel/rec_result

onready var nb_text = $notebook_panel/notebook_text

var escape_menu = preload("res://esc_menu/esc_menu.tscn").instance()
var esc_menu_active = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if not esc_menu_active:
				add_child(escape_menu)
				esc_menu_active = true
			else:
				remove_child(escape_menu)
				esc_menu_active = false

enum COLOR {
	NONE,
	BLUE,
	RED
}

enum NUM {
	NONE,
	ZERO,
	ONE
}

var send_color_state = COLOR.NONE
var send_num_state = NUM.NONE
var eav_color_state = COLOR.NONE
var eav_num_state = NUM.NONE
var rec_color_state = COLOR.NONE
var rec_num_state = NUM.NONE

var send_color_sel = false
var send_num_sel = false
var eav_color_sel = false
var rec_color_sel = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if send_color_sel and send_num_sel and eav_color_sel and rec_color_sel:
		send_num_sel = false
		send_color_sel = false
		eav_color_sel = false
		rec_color_sel = false

		randomize()

		eav_num_state = send_num_state if (eav_color_state == send_color_state) else (NUM.ZERO 
			if floor(rand_range(0, 2)) == 0 else NUM.ONE)

		eav_result.text = num_s_to_str(eav_num_state)

		randomize()

		rec_num_state = eav_num_state if rec_color_state == eav_color_state else (NUM.ZERO 
			if floor(rand_range(0, 2)) == 0 else NUM.ONE)

		rec_result.text = num_s_to_str(rec_num_state)

		nb_text.text += (col_s_to_str(send_color_state) + num_s_to_str(send_num_state) + 
				col_s_to_str(eav_color_state) + num_s_to_str(eav_num_state) + 
				col_s_to_str(rec_color_state) + num_s_to_str(rec_num_state) + "\n")

		#ready_all()

		
func col_s_to_str(col: int):
	if col == COLOR.BLUE :
		return "blue "
	else:
		return "red "

func num_s_to_str(num: int):
	if num == NUM.ZERO:
		return "0 "
	else:
		return "1 "


func ready_all():
	send_color_state = COLOR.NONE
	send_num_state = NUM.NONE
	eav_color_state = COLOR.NONE
	eav_num_state = NUM.NONE
	rec_color_state = COLOR.NONE
	rec_num_state = NUM.NONE

	send_color_sel = false
	send_num_sel = false
	eav_color_sel = false
	rec_color_sel = false

	send_blue.disabled = false
	send_red.disabled = false
	send_zero.disabled = false
	send_one.disabled = false
	eav_blue.disabled = false
	eav_red.disabled = false
	rec_blue.disabled = false
	rec_red.disabled = false
	eav_result.text = ""
	rec_result.text = ""

func rec_color_selected(col: int):
	if col == COLOR.BLUE:
		rec_color_state = COLOR.BLUE
	else:
		rec_color_sel = COLOR.RED

	rec_color_sel = true

	rec_blue.disabled = true
	rec_red.disabled = true

func eav_color_selected(col: int):
	if col == COLOR.BLUE:
		eav_color_state = COLOR.BLUE
	else:
		eav_color_sel = COLOR.RED

	eav_color_sel = true

	eav_blue.disabled = true
	eav_red.disabled = true

func send_color_selected(col: int):
	if col == COLOR.BLUE:
		send_color_state = COLOR.BLUE
	else:
		send_color_sel = COLOR.RED

	send_color_sel = true

	send_blue.disabled = true
	send_red.disabled = true

func send_num_selected(col: int):
	if col == NUM.ZERO:
		send_num_state = NUM.ZERO
	else:
		send_num_sel = NUM.ONE

	send_num_sel = true

	send_zero.disabled = true
	send_one.disabled = true


func _on_reset_button_down():
	ready_all()


func _on_send_one_pressed():
	send_num_selected(NUM.ONE)


func _on_send_zero_pressed():
	send_num_selected(NUM.ZERO)


func _on_rec_red_pressed():
	rec_color_selected(COLOR.RED)


func _on_rec_blue_pressed():
	rec_color_selected(COLOR.BLUE)


func _on_eav_red_pressed():
	eav_color_selected(COLOR.RED)


func _on_eav_blue_pressed():
	eav_color_selected(COLOR.BLUE)


func _on_send_red_pressed():
	send_color_selected(COLOR.RED)

func _on_send_blue_pressed():
	send_color_selected(COLOR.BLUE)
