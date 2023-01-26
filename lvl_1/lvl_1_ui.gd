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

onready var blue_sprite  = preload("res://lvl_0/scene_assets/blue_sprite.png")
onready var green_sprite = preload("res://lvl_0/scene_assets/green_sprite.png")

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
var basis_idx = 1

var filepath = "res://lvl_1/scene_assets/lvl_1_text.json"
var json : JSONParseResult
var curr_state = PROMPT_STATE.INTRO_1
var nb_active = false

enum PROMPT_STATE {
	INTRO_1,
	INTRO_2,
	INTRO_3,
	INTRO_4,
	INTRO_5
}

enum COLOR_STATE {
	BLUE,
	GREEN,
	NONE
}

var rec_colors_t = []
var send_colors_t = []
var sent_bit_t = []
var rec_bit_t = []

var keep_idx = []

var matching_colors_t = 0

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]
	notebook.hide()
	select_panel.hide()
	keep_reject.hide()
	
func _process(_delta):
	if disable_timer > 0.0:
		keep_btn.disabled = true
		reject_btn.disabled = true
		disable_timer -= _delta
	else:
		keep_btn.disabled = false
		reject_btn.disabled = false
	
	if matching_colors_t >= 5:
		matching_colors_t = 0
		prompt_text.text = json.result["3"]
		select_panel.hide()
		next_button.disabled = false
		curr_state = PROMPT_STATE.INTRO_4
		
		for i in range(rec_colors_t.size()):
			if send_colors_t[i] == COLOR_STATE.BLUE:
				notebook_text.text += "blue "
			else:
				notebook_text.text += "green "
				
			#notebook_text.text += (String(sent_bit_t[i]) + " ")
			
			if rec_colors_t[i] == COLOR_STATE.BLUE:
				notebook_text.text += "blue "
			else:
				notebook_text.text += "green "
				
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
		prompt_text.text = json.result["4"]
		curr_state = PROMPT_STATE.INTRO_5
		keep_reject.show()
		
		if send_colors_t[0] == COLOR_STATE.BLUE:
			send_color.texture = blue_sprite
		else:
			send_color.texture = green_sprite
			
		if rec_colors_t[0] == COLOR_STATE.BLUE:
			rec_color.texture = blue_sprite
		else:
			rec_color.texture = green_sprite
			
	elif curr_state == PROMPT_STATE.INTRO_5:
		pass
	else:
		pass

func _on_blue_button_pressed():
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
		
	basis_number.text = String(matching_colors_t)

func _on_green_button_pressed():
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
		
	basis_number.text = String(matching_colors_t)
		
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
	if basis_idx <= len(send_colors_t):
		
		if ((send_color.texture == rec_color.texture and not reject) 
				or (send_color.texture != rec_color.texture and reject)):
			print("correct")
			keep_idx.append(basis_idx - 1)
			
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
		else:
			print("wrong")
			prompt_text.text = "Try Again!"
	else:
		keep_reject.hide()
