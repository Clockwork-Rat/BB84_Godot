extends Control

onready var escape_menu = preload("res://esc_menu/esc_menu.tscn").instance()

onready var prompt_text = $"prompt_panel/prompt_text"
onready var next_button = $prompt_panel/next_btn
onready var select_panel = $select_panel
onready var basis_number = $select_panel/select_number
onready var notebook_text = $notebook_panel/notebook_text
onready var notebook = $notebook_panel
onready var keep_reject = $keep_reject

onready var send_color = $keep_reject/send_color
onready var rec_color = $keep_reject/rec_color
onready var keep_btn = $keep_reject/keep_btn
onready var reject_btn = $keep_reject/reject_btn
onready var transmission_num = $keep_reject/transmission_num

onready var keypad = $keypad_panel
onready var keypad_zero = $keypad_panel/in_zero_btn
onready var keypad_one = $keypad_panel/in_one_btn
onready var entry_num = $keypad_panel/entry_num

onready var blue_sprite  = preload("res://ui_assets/rect.png")#preload("res://lvl_0/scene_assets/blue_sprite.png")
onready var green_sprite = preload("res://ui_assets/diag.png")#preload("res://lvl_0/scene_assets/green_sprite.png")
onready var red_theme = preload("res://lvl_1/scene_assets/button_red.tres")
onready var green_theme = preload("res://lvl_1/scene_assets/button_green.tres")

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

#so that the user feels like thinking is happening
var disable_timer = 0.0
var disable_timer_max = 0.2
var basis_idx = 0

var passcode_entered = false

var filepath = "res://lvl_1/scene_assets/lvl_1_text.json"
var json : JSONParseResult
var curr_state = PROMPT_STATE.INTRO_1
var nb_active = false

var basic_theme

enum PROMPT_STATE {
	INTRO_1,
	INTRO_2,
	INTRO_3,
	INTRO_4,
	INTRO_5,
	INTRO_6,
	INTRO_7,
	EXIT
}

enum COLOR_STATE {
	BLUE,
	GREEN,
	NONE
}

enum NUM {
	ZERO,
	ONE,
	NONE
}

var flash_error = false
var flash_success = false

var flash_count = 0

var rec_colors = []
var send_colors = []
var sent_bit = []
var rec_bit = []

var code = []

var select_idx = 0
var matching_colors_t = 0
#index for keep reject
var kri = 0
var kr_in_prog = false

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]
	notebook.hide()
	select_panel.hide()
	keep_reject.hide()
	keypad.hide()
	basic_theme = keypad_one.theme
	
func _process(_delta):
	if disable_timer > 0.0:
		keep_btn.disabled = true
		reject_btn.disabled = true
		disable_timer -= _delta
	else:
		keep_btn.disabled = false
		reject_btn.disabled = false
		
	if flash_error:
		flash_color(true, _delta)
	if flash_success:
		flash_color(false, _delta)
	
	if matching_colors_t >= 5 && select_idx > 9:
		matching_colors_t = 0
		prompt_text.text = json.result["3"]
		select_panel.hide()
		next_button.disabled = false
		curr_state = PROMPT_STATE.INTRO_4

		notebook_text.text = ""
		
		for i in range(rec_colors.size()):
			notebook_text.text += ("T" + String(i) + ": ")
			
			notebook_text.text += col_to_str(send_colors[i])
				
			#notebook_text.text += (String(sent_bit_t[i]) + " ")
			
			notebook_text.text += col_to_str(rec_colors[i])
				
			notebook_text.text += (num_to_str(rec_bit[i]) + "\n")

func _on_next_btn_pressed():
	if curr_state == PROMPT_STATE.INTRO_1:
		curr_state = PROMPT_STATE.INTRO_2
		prompt_text.text = json.result["1"]
	elif curr_state == PROMPT_STATE.INTRO_2:
		curr_state = PROMPT_STATE.INTRO_3
		prompt_text.text = json.result["2"]
		select_panel.show()
		next_button.disabled = true
	elif curr_state == PROMPT_STATE.INTRO_4:
		curr_state = PROMPT_STATE.INTRO_5
		prompt_text.text = json.result["4"]
		
	elif curr_state == PROMPT_STATE.INTRO_5:
		prompt_text.text = json.result["5"]
		curr_state = PROMPT_STATE.INTRO_6
		keep_reject.show()
		kr_in_prog = true

		if send_colors[0] == COLOR_STATE.BLUE:
			send_color.texture = blue_sprite
		else:
			send_color.texture = green_sprite

		if rec_colors[0] == COLOR_STATE.GREEN:
			rec_color.texture = green_sprite
		else:
			rec_color.texture = blue_sprite

		next_button.disabled = true
	
	elif curr_state == PROMPT_STATE.INTRO_6 && not kr_in_prog:
		prompt_text.text = json.result["6"]
		curr_state = PROMPT_STATE.INTRO_7
		keypad.show()
		print("matching idx")
		notebook_text.text += json.result["nbi"]
		entry_num.text = "T" + String(code[0])
		for i in code:
			print(i)
			notebook_text.text += String(i) + "\n"
		
	elif curr_state == PROMPT_STATE.INTRO_7 && passcode_entered:
		prompt_text.text = json.result["7"]
		curr_state = PROMPT_STATE.EXIT
		
	elif curr_state == PROMPT_STATE.EXIT:
		var _f = get_tree().change_scene("res://main_menu/main_menu.tscn")
	else:
		pass

func _on_blue_button_pressed():
	_on_color_select(COLOR_STATE.BLUE)

func _on_green_button_pressed():
	_on_color_select(COLOR_STATE.GREEN)

func _on_color_select(rec_col: int):
	var sent_col = rand_color()
	var sent_num = rand_num()
	var rec_num = NUM.NONE

	if(rec_col == sent_col):
		rec_num = sent_num
		code.append(select_idx)
		matching_colors_t += 1
	else:
		rec_num = rand_num()

	notebook_text.text += "T" + String(select_idx) + ": " + \
		col_to_str(rec_col) + num_to_str(rec_num) + "\n"
	
	select_idx+=1
	basis_number.text = num_to_str(rec_num)

	send_colors.append(sent_col)
	sent_bit.append(sent_num)
	rec_colors.append(rec_col)
	rec_bit.append(rec_num)

func rand_num():
	randomize()
	if floor(rand_range(0, 2)) == 0:
		return NUM.ZERO 
	else:
		return NUM.ONE

func rand_color():
	randomize()
	if floor(rand_range(0, 2)) == 0:
		return COLOR_STATE.BLUE
	else:
		return COLOR_STATE.GREEN

func col_to_str(col: int):
	if col == COLOR_STATE.BLUE:
		return "blue "
	else:
		return "red "

func num_to_str(num: int):
	if num == NUM.ZERO:
		return "0 "
	else:
		return "1 "
		
func _on_notebook_btn_pressed():
	if nb_active:
		nb_active = false
		notebook.hide()
	else:
		nb_active = true
		notebook.show()

func _on_keep_btn_pressed():
	keep_reject_pressed(false)

func _on_reject_btn_pressed():
	keep_reject_pressed(true)
		
func keep_reject_pressed(reject: bool):
	disable_timer = disable_timer_max

	if reject:
		if send_colors[kri] == rec_colors[kri]:
			prompt_text.text = "That was incorrect, remember the tutorial, how do you know the numbers will match?"
		else:
			prompt_text.text = "Great job!"
	
	else:
		if not send_colors[kri] == rec_colors[kri]:
			prompt_text.text = "That was incorrect, remember the tutorial, how do you know the numbers will match?"
		else:
			prompt_text.text = "Great job!"

	kri += 1
	if kri == len(send_colors):
		kr_in_prog = false
		_on_next_btn_pressed()
		next_button.disabled = false
		keep_reject.hide()
		return
	
	transmission_num.text = "T" + String(kri)
	if send_colors[kri] == COLOR_STATE.BLUE:
		send_color.texture = blue_sprite
	else:
		send_color.texture = green_sprite
	
	if rec_colors[kri] == COLOR_STATE.BLUE:
		rec_color.texture = blue_sprite
	else:
		rec_color.texture = green_sprite
	
	
		
func _on_in_zero_btn_pressed():
	on_keypad_button_pressed(NUM.ZERO)

func _on_in_one_btn_pressed():
	on_keypad_button_pressed(NUM.ONE)

var kpi = 0
func on_keypad_button_pressed(code_num: int):

	if rec_bit[code[kpi]] == code_num:
		kpi += 1
		print("correct")
	else:
		flash_error = true
		keypad_one.disabled = true
		keypad_zero.disabled = true
		print("no")
		kpi = 0
		
	if kpi >= len(code):
		passcode_entered = true
		keypad_one.disabled = true
		keypad_zero.disabled = true
		flash_success = true
		_on_next_btn_pressed()
		return

	entry_num.text = "T" + String(code[kpi])
		
var total_flash = 0.0
var flashing_color = true
var flash_cycle = 0

func flash_color(red: bool, update: float):
	var flash_time = 0.2
	
	total_flash += update
	
	if total_flash >= flash_time:
		total_flash = 0.0
		if flashing_color:
			print("hit color")
			if red:
				keypad_one.theme = red_theme
				keypad_zero.theme = red_theme
			else:
				keypad_zero.theme = green_theme
				keypad_one.theme = green_theme
			flashing_color = false
		else:
			print("hit free")
			keypad_zero.theme = basic_theme
			keypad_one.theme = basic_theme
			flashing_color = true
			flash_cycle += 1
			
	if flash_cycle > 3:
		keypad_one.theme = basic_theme
		keypad_zero.theme = basic_theme
		keypad_zero.disabled = false
		keypad_one.disabled = false
		total_flash = 0.0
		flashing_color = true
		flash_cycle = 0
		flash_error = false
		flash_success = false
		
		if not red:
			keypad.hide()
