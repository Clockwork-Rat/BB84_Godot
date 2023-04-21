extends Panel

var blue_sprite = preload("res://ui_assets/rect.png")#preload("res://lvl_0/scene_assets/blue_sprite.png")
var green_sprite = preload("res://ui_assets/diag.png")#preload("res://lvl_0/scene_assets/green_sprite.png")

onready var send_color = $send_color
onready var rec_color = $rec_color
onready var send_num = $send_num
onready var notebook_text = $"../notebook_panel/notebook_text"

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
var enter = true

signal enough_correct

#stop repeat questions

func set_all():
	print("-----------")
	
	var tmp_send_color_state: int
	var tmp_send_number_state: int
	var tmp_rec_color_state: int
	
	while true:
		var tmp = get_state()				
		if tmp == 0:
			tmp_send_color_state = COLOR_STATE.BLUE_STATE
			send_color.texture = blue_sprite
		else:
			tmp_send_color_state = COLOR_STATE.GREEN_STATE
			send_color.texture = green_sprite
		
		tmp = get_state()
		if tmp == 0:
			tmp_send_number_state = NUMBER_STATE.ZERO_STATE
			send_num.text = "0"
		else:
			tmp_send_number_state = NUMBER_STATE.ONE_STATE
			send_num.text = "1"

		tmp = get_state()
		if tmp == 0:
			tmp_rec_color_state = COLOR_STATE.BLUE_STATE
			rec_color.texture = blue_sprite
		else: 
			tmp_rec_color_state = COLOR_STATE.GREEN_STATE
			rec_color.texture = green_sprite

		if _test_previous(tmp_send_color_state, tmp_send_number_state, tmp_rec_color_state):
			send_color_state = tmp_send_color_state
			send_number_state = tmp_send_number_state
			rec_color_state = tmp_rec_color_state
			break;

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
	var last_str = "0 wrong "
	if send_color_state == rec_color_state:
		if send_number_state == NUMBER_STATE.ZERO_STATE:
			correct_answers += 1
			last_str = "0 correct "
			print("correct")
		else:
			correct_answers = 0
			print("wrong")
	else:
		correct_answers = 0
		print("wrong")
	notebook_text.text += col_to_str(send_color_state) + num_to_str(send_number_state) +\
		col_to_str(rec_color_state) + last_str + String(correct_answers) + "\n"
	set_all()

func _test_previous( cur_send_color, cur_send_number, cur_rec_color ):
	if (cur_send_color == send_color_state and 
		cur_send_number == send_number_state and 
		cur_rec_color == rec_color_state):
		return false

	return true


func _on_one_btn_pressed():
	var last_str = "1 wrong "
	if send_color_state == rec_color_state:
		if send_number_state == NUMBER_STATE.ONE_STATE:
			correct_answers += 1
			last_str = "1 correct "
			print("correct")
		else:
			correct_answers = 0
			print("wrong")
	else:
		correct_answers = 0
		print("wrong")
	notebook_text.text += col_to_str(send_color_state) + num_to_str(send_number_state) +\
		col_to_str(rec_color_state) + last_str + String(correct_answers) + "\n"
	set_all()
	
func col_to_str(col: int):
	if col == COLOR_STATE.BLUE_STATE:
		return "blue "
	else:
		return "red "
	
func num_to_str(num: int):
	if num == NUMBER_STATE.ZERO_STATE:
		return "0 "
	else:
		return "1 "

func _on_question_btn_pressed():
	var last_str = "0/1 wrong "
	if send_color_state != rec_color_state:
		correct_answers += 1
		last_str = "0/1 correct "
		print("correct")
	else:
		correct_answers = 0
		print("wrong")
	notebook_text.text += col_to_str(send_color_state) + num_to_str(send_number_state) +\
		col_to_str(rec_color_state) + last_str + String(correct_answers) + "\n"
	set_all()
