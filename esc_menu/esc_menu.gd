extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit(0)
	pass # Replace with function body.


func _on_main_menu_btn_pressed():
	get_tree().change_scene("res://main_menu/main_menu.tscn")
	pass # Replace with function body.
