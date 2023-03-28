extends Control

onready var nxt_btn = $"prompt_panel/next_button"
onready var first_panel = $familiarize_panel
onready var quiz_panel = $quiz_panel
onready var prompt_text = $"prompt_panel/main_text"
onready var notebook_panel = $notebook_panel
onready var hl_send_color = $familiarize_panel/hl_send_color
onready var hl_send_num = $familiarize_panel/hl_send_num
onready var hl_rec_color = $familiarize_panel/hl_rec_color
onready var hl_notebook = $hl_notebook
onready var hl_select_panel = $hl_select_panel
onready var hl_reset = $familiarize_panel/hl_reset
onready var next_button = $prompt_panel/next_button
onready var back_button = $prompt_panel/back_button
onready var hl_result = $familiarize_panel/hl_result

var filepath = "res://lvl_0/scene_assets/tutorial_text.json"
var json : JSONParseResult

var nb_panel_active = false
var esc_menu_active = false
var practice_times = 0
var min_practice = 5

signal walkthrough_ended
signal training_mode_ended

var escape_menu = preload("res://esc_menu/esc_menu.tscn").instance()

enum part_state {
	WALKTHROUGH,
	GUIDED_USER,
	FREE
}

enum panel_state {
	WT_0,
	WT_1,
	WT_2,
	WT_3,
	WT_4,
	WT_5,
	WT_6,
	WT_7,
	U0,
	U1,
	U2,
	U3,
	INTRO_STATE,
	FIRST_PANEL_STATE,
	QUIZ_PANEL_STATE,
	END_STATE
}

var current_state = panel_state.INTRO_STATE
var c_part = part_state.WALKTHROUGH

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if not esc_menu_active:
				add_child(escape_menu)
				esc_menu_active = true
			else:
				remove_child(escape_menu)
				esc_menu_active = false

func reload():
	get_tree().reload_current_scene()


func _ready():
	var file_load = File.new()
	file_load.open(filepath, File.READ)
	json = JSON.parse( file_load.get_as_text() )
	first_panel.hide()
	quiz_panel.hide()
	prompt_text.text = json.result["0"]
	notebook_panel.hide()
	escape_menu.connect("reload", self, "reload")

func _on_next_button_pressed():
	if current_state == panel_state.INTRO_STATE:
		current_state = panel_state.WT_0
		prompt_text.text = json.result["wt-0"]
		first_panel.show()
	elif current_state == panel_state.WT_0:
		current_state = panel_state.WT_1
		prompt_text.text = json.result["wt-1"]
		hl_notebook.show()

	elif current_state == panel_state.WT_1:
		current_state = panel_state.WT_2
		prompt_text.text = json.result["wt-2"]
		hl_notebook.hide()
		first_panel.show()
		hl_select_panel.show()
		
	elif current_state == panel_state.WT_2:
		current_state = panel_state.WT_3
		prompt_text.text = json.result["wt-3"]
		hl_send_color.show()
		hl_select_panel.hide()
		#hide selection panel highlight
		
	elif current_state == panel_state.WT_3:
		current_state = panel_state.WT_4
		prompt_text.text = json.result["wt-4"]
		hl_send_color.hide()
		hl_send_num.show()
		
	elif current_state == panel_state.WT_4:
		current_state = panel_state.WT_5
		prompt_text.text = json.result["wt-5"]
		hl_send_num.hide()
		hl_rec_color.show()
		
	elif current_state == panel_state.WT_5:
		current_state = panel_state.WT_6
		prompt_text.text = json.result["wt-6"]
		hl_rec_color.hide()
		hl_reset.show()
		
	elif current_state == panel_state.WT_6:
		current_state = panel_state.WT_7
		prompt_text.text = json.result["wt-7"]
		hl_reset.hide()
		
		
	elif current_state == panel_state.WT_7:
		current_state = panel_state.U0
		prompt_text.text = json.result["u-0"]
		back_button.disabled = true
		emit_signal("walkthrough_ended")
		next_button.disabled = true
		
	elif current_state == panel_state.U0:
		current_state = panel_state.U1
		prompt_text.text = json.result["u-1"]
		
		
	elif current_state == panel_state.U1:
		current_state = panel_state.U2
		prompt_text.text = json.result["u-2"]
		
		
	elif current_state == panel_state.U2:
		current_state = panel_state.U3
		prompt_text.text = json.result["u-3"]
		hl_result.show()
		emit_signal("training_mode_ended")
		next_button.disabled = false

	elif current_state == panel_state.U3:
		hl_result.hide()
		current_state = panel_state.FIRST_PANEL_STATE
		prompt_text.text = json.result["1"]

	elif current_state  == panel_state.FIRST_PANEL_STATE and practice_times >= min_practice:
		current_state = panel_state.QUIZ_PANEL_STATE
		prompt_text.text = json.result["2"]
		first_panel.hide()
		quiz_panel.show()
	elif current_state == panel_state.FIRST_PANEL_STATE:
		prompt_text.text = "Build up a bit more familiarity with the interface, try running a few more tests! Remember, the next part is a quiz."
	elif current_state == panel_state.END_STATE:
		var persist_file = File.new()
		persist_file.open("res://persist.json", File.READ)
		#figure out how to rewrite part of a json file
		var _dmp = get_tree().change_scene("res://main_menu/main_menu.tscn")
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


func _on_back_button_pressed():
	if c_part == part_state.WALKTHROUGH:
		if current_state == panel_state.WT_0:
			current_state = panel_state.INTRO_STATE
			prompt_text.text = json.result["0"]
		elif current_state == panel_state.WT_1:
			current_state = panel_state.WT_0
			prompt_text.text = json.result["wt-0"]
			hl_notebook.hide()

		elif current_state == panel_state.WT_2:
			current_state = panel_state.WT_1
			prompt_text.text = json.result["wt-1"]
			hl_notebook.show()
			hl_select_panel.hide()

		elif current_state == panel_state.WT_3:
			prompt_text.text = json.result["wt-2"]
			current_state = panel_state.WT_2
			hl_select_panel.show()
			hl_send_color.hide()


		elif current_state == panel_state.WT_4:
			prompt_text.text = json.result["wt-3"]
			current_state = panel_state.WT_3
			hl_send_color.show()
			hl_send_num.hide()
			
			
		elif current_state == panel_state.WT_5:
			prompt_text.text = json.result["wt-4"]
			current_state = panel_state.WT_4
			hl_send_num.show()
			hl_rec_color.hide()

		elif current_state == panel_state.WT_6:
			prompt_text.text = json.result["wt-5"]
			current_state = panel_state.WT_5
			hl_rec_color.show()
			hl_reset.hide()

		elif current_state == panel_state.WT_7:
			prompt_text.text = json.result["wt-6"]
			current_state = panel_state.WT_6
			hl_reset.show()

	elif c_part == part_state.GUIDED_USER:
		if current_state == panel_state.U0:
			pass
		elif current_state == panel_state.U1:
			pass
		elif current_state == panel_state.U2:
			pass
		elif current_state == panel_state.U3:
			pass
		elif current_state == panel_state.U4:
			pass

	elif c_part == part_state.FREE:
		pass #can't back up during the free part


func _on_familiarize_panel_pressed_correct_button():
	_on_next_button_pressed()
	
func _on_familiarize_panel_practice():
	practice_times += 1
