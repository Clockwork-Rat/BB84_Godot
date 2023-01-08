extends Control

onready var prompt_text = $"prompt_panel/prompt_text"
onready var next_button = $prompt_panel/next_btn
onready var select_panel = $select_panel
onready var basis_number = $select_panel/select_number

var filepath = "res://lvl_1/scene_assets/lvl_1_text.json"
var json : JSONParseResult
var curr_state = PROMPT_STATE.INTRO_1

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

var matching_colors_t = 0

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]
	
	select_panel.hide()
	
func _process(_delta):
	if matching_colors_t >= 5:
		matching_colors_t = 0
		prompt_text.text = json.result["3"]
		select_panel.hide()
		next_button.disabled = false
		curr_state = PROMPT_STATE.INTRO_4

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
	
	var tmp = floor(rand_range(0, 2))
	if tmp == 0:
		send_colors_t.append(COLOR_STATE.BLUE)
		matching_colors_t += 1
	else:
		send_colors_t.append(COLOR_STATE.GREEN)
		
	basis_number.text = String(matching_colors_t)


func _on_green_button_pressed():
	randomize()
	rec_colors_t.append(COLOR_STATE.GREEN)
	
	var tmp = floor(rand_range(0, 2))
	if tmp == 0:
		send_colors_t.append(COLOR_STATE.BLUE)
	else:
		send_colors_t.append(COLOR_STATE.GREEN)
		matching_colors_t += 1
		
	basis_number.text = String(matching_colors_t)
		
