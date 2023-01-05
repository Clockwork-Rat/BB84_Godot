extends Panel

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

func set_all():
	print("-----------")
	var tmp = get_state()
	if tmp == 0:
		send_color_state = COLOR_STATE.BLUE_STATE
		print("blue")
	else:
		send_color_state = COLOR_STATE.GREEN_STATE
		print("green")
	
	tmp = get_state()
	if tmp == 0:
		send_number_state = NUMBER_STATE.ZERO_STATE
		print("zero")
	else:
		send_number_state = NUMBER_STATE.ONE_STATE
		print("one")
		
	tmp = get_state()
	if tmp == 0:
		rec_color_state = COLOR_STATE.BLUE_STATE
		print("blue")
	else: 
		rec_color_state = COLOR_STATE.GREEN_STATE
		print("green")
	
	
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
			print("correct")
		else:
			print("wrong")
	else:
		print("wrong")
	set_all()


func _on_one_btn_pressed():
	if send_color_state == rec_color_state:
		if send_number_state == NUMBER_STATE.ONE_STATE:
			print("correct")
		else:
			print("wrong")
	else:
		print("wrong")
	set_all()


func _on_question_btn_pressed():
	if send_color_state != rec_color_state:
		print("correct")
	else:
		print("wrong")
	set_all()
