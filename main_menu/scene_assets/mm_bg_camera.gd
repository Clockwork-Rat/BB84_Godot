extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animation_player = $"../main_menu_anim_player"


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("camera_bob", -1, 0.2, false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
