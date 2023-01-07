extends Control

onready var prompt_text = $"prompt_panel/prompt_text"

var filepath = "res://lvl_1/scene_assets/lvl_1_text.json"
var json : JSONParseResult
var curr_state = PROMPT_STATE.INTRO_1

enum PROMPT_STATE {
	INTRO_1,
	INTRO_2,
	INTRO_3,
	INTRO_4
}

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse(file_load.get_as_text())
	prompt_text.text = json.result["0"]

func _on_next_btn_pressed():
	
	if curr_state == PROMPT_STATE.INTRO_1:
		curr_state = PROMPT_STATE.INTRO_2
		prompt_text.text = json.result["1"]
	elif curr_state == PROMPT_STATE.INTRO_2:
		curr_state = PROMPT_STATE.INTRO_3
		prompt_text.text = json.result["2"]
	else:
		pass
	
