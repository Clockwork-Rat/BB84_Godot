extends Control

onready var prompt_text = $"prompt_panel/prompt_text"
onready var next_button = $prompt_panel/next_btn
onready var select_panel = $select_panel
onready var basis_number = $select_panel/select_number
onready var notebook_text = $notebook_panel/notebook_text
onready var notebook = $notebook_panel

var filepath = "res://lvl_1/scene_assets/lvl_1_text.json"
var json : JSONParseResult
var curr_state = PROMPT_STATE.INTRO_1
var nb_active = false

enum PROMPT_STATE {
	INTRO_1,
	INTRO_2,
	INTRO_3,
	INTRO_4
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

var matching_colors_t = 0

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]
	notebook.hide()
	
	select_panel.hide()
	
func _process(_delta):
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
