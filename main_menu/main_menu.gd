extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_lvl_0_pressed():
	get_tree().change_scene("res://lvl_0/lvl_0.tscn")


func _on_btn_lvl_1_pressed():
	get_tree().change_scene("res://lvl_1/lvl_1.tscn")


func _on_btn_lvl_2_pressed():
	get_tree().change_scene("res://lvl_2/lvl_2.tscn")


func _on_btn_lvl_3_pressed():
	pass # Replace with function body.
