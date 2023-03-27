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
onready var practice_panel = $practice_panel
onready var dataset_panel = $dataset
onready var dataset_txt = $dataset/generated_dataset
onready var prompt_text = $prompt_panel/prompt_text
onready var next_btn = $prompt_panel/next_btn
onready var s_panel = $s_panel;
onready var num_correct = $s_panel/num_correct

onready var nb_text = $notebook_panel/notebook_text
onready var nb = $notebook_panel
var nb_shown = false

var correct_count = 0

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

var eav_pres = false

var filepath = "res://lvl_2/scene_assets/lvl_2_text.json"
var json : JSONParseResult


# Called when the node enters the scene tree for the first time.
func _ready():
	nb.hide()
	dataset_panel.hide()
	s_panel.hide()
	eav_pres = _generate_data()

	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]

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

	if correct_count >= 5:
		next_btn.disabled = false

		
func col_s_to_str(col: int):
	if col == COLOR.BLUE :
		return "blue "
	else:
		return "red  "

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

	send_blue.show()
	send_zero.show()
	send_one.show()
	eav_blue.show()
	eav_red.show()
	rec_blue.show()
	rec_red.show()
	eav_result.show()
	rec_result.show()
	send_red.show()


func rec_color_selected(col: int):
	if col == COLOR.BLUE:
		rec_color_state = COLOR.BLUE
		rec_red.hide()
	else:
		rec_blue.hide()
		rec_color_sel = COLOR.RED

	rec_color_sel = true

	rec_blue.disabled = true
	rec_red.disabled = true

func eav_color_selected(col: int):
	if col == COLOR.BLUE:
		eav_color_state = COLOR.BLUE
		eav_red.hide()
	else:
		eav_blue.hide()
		eav_color_sel = COLOR.RED

	eav_color_sel = true

	eav_blue.disabled = true
	eav_red.disabled = true

func send_color_selected(col: int):
	if col == COLOR.BLUE:
		send_red.hide()
		send_color_state = COLOR.BLUE
	else:
		send_blue.hide()
		send_color_sel = COLOR.RED

	send_color_sel = true

	send_blue.disabled = true
	send_red.disabled = true

func send_num_selected(col: int):
	if col == NUM.ZERO:
		send_one.hide()
		send_num_state = NUM.ZERO
	else:
		send_zero.hide()
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

func _on_notebook_btn_pressed():
	
	nb_shown = !nb_shown
	if nb_shown:
		practice_panel.rect_position.x = 254
		nb.show()
	else:
		practice_panel.rect_position.x = 164
		nb.hide()
		
func _generate_data():
	var sent_num = NUM.NONE
	var sent_color = COLOR.NONE
	var eav_num = NUM.NONE
	var eav_color = NUM.NONE
	var rec_num = NUM.NONE
	var rec_color = COLOR.NONE

	var manual_flip = false
	
	var eav_present = false

	dataset_txt.text = "sender\treceiver\n"
	
	randomize()
	eav_present = rand_gen()
	
	for _i in range(20):
		if eav_present:
			sent_color = rand_color()
			eav_color = rand_color()
			rec_color = rand_color()
			sent_num = rand_num()

			eav_num = sent_num if sent_color == eav_color else rand_num()
			rec_num = eav_num if eav_color == rec_color else rand_gen()

			if not manual_flip and sent_color == rec_color:
				sent_num = NUM.ZERO if sent_num == NUM.ONE else NUM.ONE
				manual_flip = true
		else:
			sent_color = rand_color()
			rec_color = rand_color()
			sent_num = rand_num()

			rec_num = sent_num if sent_color == rec_color else rand_gen()
		
		dataset_txt.text += col_s_to_str(sent_color) + num_s_to_str(sent_num) +"\t"+ col_s_to_str(rec_color) + num_s_to_str(rec_num) + "\n"
	
	return eav_present
	
func rand_gen():
	randomize()
	return floor(rand_range(0, 2)) == 0
	
func rand_color():
	if rand_gen():
		return COLOR.RED
	else:
		return COLOR.BLUE
		
func rand_num():
	if rand_gen():
		return NUM.ZERO
	else:
		return NUM.ONE


func _on_present_pressed():
	if eav_pres:
		print("Correct!")
		correct_count += 1
		if correct_count >= 5:
			_on_next_btn_pressed()
	else:
		print("Incorrect")
		correct_count = 0
	
	num_correct.text = String(correct_count)
	eav_pres = _generate_data();


func _on_absent_pressed():
	if not eav_pres:
		print("Correct!")
		correct_count += 1
		if correct_count >= 5:
			_on_next_btn_pressed()
	else:
		print("Incorrect")
		correct_count = 0
	
	num_correct.text = String(correct_count)
	eav_pres = _generate_data();


enum PROMPT {
	INST,
	INTRO_EVE,
	PRAC,
	QUIZ_PREFACE,
	QUIZ,
	CONGRATS
}

var prompt = PROMPT.INST;

func _on_next_btn_pressed():
	
	if prompt == PROMPT.INST:
		prompt = PROMPT.INTRO_EVE
		prompt_text.text = json.result["1"]
	elif prompt == PROMPT.INTRO_EVE:
		prompt = PROMPT.PRAC
		prompt_text.text = json.result["2"]
		practice_panel.show()
	elif prompt == PROMPT.PRAC:
		prompt = PROMPT.QUIZ_PREFACE
		prompt_text.text = json.result["3"]
	elif prompt == PROMPT.QUIZ_PREFACE:
		prompt = PROMPT.QUIZ
		prompt_text.text = json.result["4"]
		practice_panel.hide()
		dataset_panel.show()
		s_panel.show()
		next_btn.disabled = true
	elif prompt == PROMPT.QUIZ and correct_count >= 5:
		prompt = PROMPT.CONGRATS
		prompt_text.text = json.result["5"]
		dataset_panel.hide()
		s_panel.hide()
	elif prompt == PROMPT.CONGRATS:
		var _f = get_tree().change_scene("res://main_menu/main_menu.tscn")
