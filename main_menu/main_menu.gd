extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var lvl_0_btn = $btn_lvl_0
onready var lvl_1_btn = $btn_lvl_1
onready var lvl_2_btn = $btn_lvl_2
onready var lvl_3_btn = $btn_lvl_3

var json_file = "res://persist.json"
var json : JSONParseResult

var esc_menu_active = false

var escape_menu = preload("res://esc_menu/esc_menu.tscn").instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open(json_file, File.READ)
	json = JSON.parse(file.get_as_text())
	file.close()

	var level = int(json.result["level"])

	if level >= 5:
		pass #do nothing because all levels are unlocked
	elif level >= 4:
		pass #do nothing as level 4 is not yet implemented
	elif level >= 3:
		pass # do nothing, as the current highest level is unlocked
	elif level >= 2:
		lvl_3_btn.disabled = true
	elif level >= 1:
		lvl_3_btn.disabled = true
		lvl_2_btn.disabled = true
	elif level >= 0:
		lvl_1_btn.disabled = true
		lvl_2_btn.disabled = true
		lvl_3_btn.disabled = true
	else:
		pass #throw an error maybe
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if not esc_menu_active:
				add_child(escape_menu)
				esc_menu_active = true
			else:
				remove_child(escape_menu)
				esc_menu_active = false
				

func _on_btn_lvl_0_pressed():
	get_tree().change_scene("res://lvl_0/lvl_0.tscn")


func _on_btn_lvl_1_pressed():
	get_tree().change_scene("res://lvl_1/lvl_1.tscn")


func _on_btn_lvl_2_pressed():
	get_tree().change_scene("res://lvl_2/lvl_2.tscn")


func _on_btn_lvl_3_pressed():
	get_tree().change_scene("res://lvl_3/lvl_3.tscn")


func _on_btn_lvl_4_pressed():
	get_tree().change_scene("res://lvl_3_models/lvl_3.tscn")
