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

onready var keypad = $keypad_panel
onready var keypad_zero = $keypad_panel/in_zero_btn
onready var keypad_one = $keypad_panel/in_one_btn

onready var blue_sprite  = preload("res://lvl_0/scene_assets/blue_sprite.png")
onready var green_sprite = preload("res://lvl_0/scene_assets/green_sprite.png")
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

var flash_error = false
var flash_success = false

var flash_count = 0

var rec_colors_t = []
var send_colors_t = []
var sent_bit_t = []
var rec_bit_t = []

var keep_idx_0 = []
var number_order = []
var number_order_idx = 0;

var total_selected = 0;
var matching_colors_t = 0

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
	
	if matching_colors_t >= 5:
		matching_colors_t = 0
		prompt_text.text = json.result["3"]
		select_panel.hide()
		next_button.disabled = false
		curr_state = PROMPT_STATE.INTRO_4
		
		for i in range(rec_colors_t.size()):
			notebook_text.text += (String(i) + ": ")
			
			if send_colors_t[i] == COLOR_STATE.BLUE:
				notebook_text.text += "blue "
			else:
				notebook_text.text += "red "
				
			#notebook_text.text += (String(sent_bit_t[i]) + " ")
			
			if rec_colors_t[i] == COLOR_STATE.BLUE:
				notebook_text.text += "blue "
			else:
				notebook_text.text += "red "
				
			notebook_text.text += (String(rec_bit_t[i]) + "\n")

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
		
		if send_colors_t[0] == COLOR_STATE.BLUE:
			send_color.texture = blue_sprite
		else:
			send_color.texture = green_sprite
			
		if rec_colors_t[0] == COLOR_STATE.BLUE:
			rec_color.texture = blue_sprite
		else:
			rec_color.texture = green_sprite
			
	elif curr_state == PROMPT_STATE.INTRO_6:
		prompt_text.text = json.result["6"]
		curr_state = PROMPT_STATE.INTRO_7
		keypad.show()
		print("matching idx")
		notebook_text.text += json.result["nbi"]
		for i in keep_idx_0:
			print(i)
		while len(keep_idx_0) > 0 :
			randomize()
			print(String(len(keep_idx_0)))
			var idx = floor(rand_range(0, len(keep_idx_0)))
			notebook_text.text += (String(keep_idx_0[idx]) + "\n")
			var real_idx = keep_idx_0[idx]
			number_order.push_back(rec_bit_t[real_idx])
			keep_idx_0.remove(idx)
		for num in number_order:
			print(String(num))
		
	elif curr_state == PROMPT_STATE.INTRO_7 && passcode_entered:
		prompt_text.text = json.result["7"]
		curr_state = PROMPT_STATE.EXIT
		
	elif curr_state == PROMPT_STATE.EXIT:
		var _f = get_tree().change_scene("res://main_menu/main_menu.tscn")
	else:
		pass

func _on_blue_button_pressed():
	total_selected += 1;
	randomize()
	rec_colors_t.append(COLOR_STATE.BLUE)
	var tmp_bit = floor(rand_range(0, 2))
	sent_bit_t.append(tmp_bit)
	
	randomize()
	var tmp = floor(rand_range(0, 2))
	if tmp == 0:
		send_colors_t.append(COLOR_STATE.BLUE)
		rec_bit_t.append(tmp_bit)
		matching_colors_t += 1
	else:
		randomize()
		rec_bit_t.append(floor(rand_range(0, 2)))
		send_colors_t.append(COLOR_STATE.GREEN)
		
	basis_number.text = String(total_selected)

func _on_green_button_pressed():
	total_selected += 1;
	randomize()
	rec_colors_t.append(COLOR_STATE.GREEN)
	var tmp_bit = floor(rand_range(0, 2))
	sent_bit_t.append(tmp_bit)
	
	randomize()
	var tmp = floor(rand_range(0, 2))
	if tmp == 0:
		randomize()
		rec_bit_t.append(floor(rand_range(0, 2)))
		send_colors_t.append(COLOR_STATE.BLUE)
	else:
		send_colors_t.append(COLOR_STATE.GREEN)
		rec_bit_t.append(tmp_bit)
		matching_colors_t += 1
		
	basis_number.text = String(total_selected)
		
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
	if basis_idx < len(send_colors_t):
		
		if ((send_color.texture == rec_color.texture and not reject) 
				or (send_color.texture != rec_color.texture and reject)):
			print("correct")
			
			if not reject:
				keep_idx_0.append(basis_idx)
			
			if basis_idx < len(send_colors_t):
				if send_colors_t[basis_idx] == COLOR_STATE.BLUE:
					send_color.texture = blue_sprite
				else:
					send_color.texture = green_sprite
		
				if rec_colors_t[basis_idx] == COLOR_STATE.BLUE:
					rec_color.texture = blue_sprite
				else:
					rec_color.texture = green_sprite
				prompt_text.text = "Yes! That's Correct"
				
			basis_idx += 1

			if basis_idx == (len(send_colors_t) - 1):
				keep_reject.hide()
		else:
			print("wrong")
			prompt_text.text = "Try Again!"
	else:
		keep_reject.hide()
		
func _on_in_zero_btn_pressed():
	on_keypad_button_pressed(0)

func _on_in_one_btn_pressed():
	on_keypad_button_pressed(1)

func on_keypad_button_pressed(code_num: int):
	if number_order_idx < len(number_order) or true:
	
		if number_order[number_order_idx] == code_num:
			number_order_idx += 1
			print("yes")
		else:
			number_order_idx = 0
			flash_error = true
			keypad_one.disabled = true
			keypad_zero.disabled = true
			print("no")
			
	
		
	if number_order_idx >= len(number_order):
		passcode_entered = true
		keypad_one.disabled = true
		keypad_zero.disabled = true
		flash_success = true
		_on_next_btn_pressed()
		

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
