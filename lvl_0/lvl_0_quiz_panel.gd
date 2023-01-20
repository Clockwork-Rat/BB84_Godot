extends Panel

var blue_sprite = preload("res://lvl_0/scene_assets/blue_sprite.png")
var green_sprite = preload("res://lvl_0/scene_assets/green_sprite.png")

onready var send_color = $send_color
onready var rec_color = $rec_color
onready var send_num = $send_num

enum COLOR_STATE {
	BLUE_STATE,
	GREEN_STATE,
	NONE
}

enum NUMBER_STATE {
	ZERO_STATE,
	ONE_STATE,
	NONE
}

var send_color_state = COLOR_STATE.NONE
var send_number_state = NUMBER_STATE.NONE
var rec_color_state = COLOR_STATE.NONE

var correct_answers = 0

signal enough_correct

func set_all():
	print("-----------")
	var tmp = get_state()
	if tmp == 0:
		send_color_state = COLOR_STATE.BLUE_STATE
		print("blue")
		send_color.texture = blue_sprite
	else:
		send_color_state = COLOR_STATE.GREEN_STATE
		print("green")
		send_color.texture = green_sprite
	
	tmp = get_state()
	if tmp == 0:
		send_number_state = NUMBER_STATE.ZERO_STATE
		print("zero")
		send_num.text = "0"
	else:
		send_number_state = NUMBER_STATE.ONE_STATE
		print("one")
		send_num.text = "1"
		
	tmp = get_state()
	if tmp == 0:
		rec_color_state = COLOR_STATE.BLUE_STATE
		print("blue")
		rec_color.texture = blue_sprite
	else: 
		rec_color_state = COLOR_STATE.GREEN_STATE
		print("green")
		rec_color.texture = green_sprite
		
	if correct_answers >= 5:
		emit_signal("enough_correct")
	
	
func get_state():
	randomize()
	var temp = rand_range(0, 2)
	temp = floor(temp)
	return temp

# Called when the node enters the scene tree for the first time.
func _ready():
	set_all()

func _on_zero_btn_pressed():
	if send_color_state == rec_color_state:
		if send_number_state == NUMBER_STATE.ZERO_STATE:
			correct_answers += 1
			print("correct")
		else:
			correct_answers = 0
			print("wrong")
	else:
		correct_answers = 0
		print("wrong")
	set_all()


func _on_one_btn_pressed():
	if send_color_state == rec_color_state:
		if send_number_state == NUMBER_STATE.ONE_STATE:
			correct_answers += 1
			print("correct")
		else:
			correct_answers = 0
			print("wrong")
	else:
		correct_answers = 0
		print("wrong")
	set_all()


func _on_question_btn_pressed():
	if send_color_state != rec_color_state:
		correct_answers += 1
		print("correct")
	else:
		correct_answers = 0
		print("wrong")
	set_all()
