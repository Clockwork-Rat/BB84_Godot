extends Control

onready var nxt_btn = $"prompt_panel/next_button"
onready var first_panel = $familiarize_panel
onready var quiz_panel = $quiz_panel
onready var prompt_text = $"prompt_panel/main_text"
onready var notebook_panel = $notebook_panel

var filepath = "res://lvl_0/scene_assets/tutorial_text.json"
var json : JSONParseResult

var nb_panel_active = false

enum panel_state {
	INTRO_STATE,
	FIRST_PANEL_STATE,
	QUIZ_PANEL_STATE,
	END_STATE
}

var current_state = panel_state.INTRO_STATE

func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse( file_load.get_as_text() )
	first_panel.hide()
	quiz_panel.hide()
	prompt_text.text = json.result["0"]
	notebook_panel.hide()

func _on_next_button_pressed():
	if current_state == panel_state.INTRO_STATE:
		current_state = panel_state.FIRST_PANEL_STATE
		prompt_text.text = json.result["1"]
		first_panel.show()
	elif current_state  == panel_state.FIRST_PANEL_STATE:
		current_state = panel_state.QUIZ_PANEL_STATE
		prompt_text.text = json.result["2"]
		first_panel.hide()
		quiz_panel.show()
	elif current_state == panel_state.END_STATE:
		get_tree().change_scene("res://main_menu/main_menu.tscn")
	else:
		pass


func _on_quiz_panel_enough_correct():
	prompt_text.text = json.result["3"]
	quiz_panel.hide()
	current_state = panel_state.END_STATE


func _on_notebook_btn_pressed():
	if nb_panel_active:
		notebook_panel.hide()
		nb_panel_active = false
	else:
		notebook_panel.show()
		nb_panel_active = true
