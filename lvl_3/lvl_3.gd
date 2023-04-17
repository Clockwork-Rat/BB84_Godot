extends Control

onready var key_text = $interface/key_text
onready var secure_low_btn = $interface/secure_low_btn
onready var secure_norm_btn = $interface/secure_norm_btn
onready var secure_high_btn = $interface/secure_high_btn
onready var key_length_panel = $interface/key_length_panel
onready var compare_btn = $interface/comp_btn
onready var generate_btn = $interface/generate_btn
onready var key_length_text = $interface/key_length_panel/key_length_number

# Called when the node enters the scene tree for the first time.
func _ready():
	set_security(true)
	key_length_panel.hide()
	compare_btn.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
var gen_time = 0.0
var entries = 0
var total_entries = 0
var full_key = ""
var key_length = 0
func _process(delta):
	if gen:
		var tmp = rand_entry()
		key_text.text += tmp
		full_key += tmp
		gen_time += delta
		entries += 1
		total_entries += 1
	if gen_time >= 3.0:
		gen = false
		gen_time = 0.0
		entries = 0
		key_text.text = full_key
	if entries >= 100:
		key_text.text = ""
		entries = 0

var gen = false
func _on_generate_btn_pressed():
	generate_btn.disabled = true
	compare_btn.disabled = false
	total_entries = 0
	key_length_panel.show()
	full_key = ""
	
func _on_confirm_btn_pressed():
	if key_length_text.text != "":
		if int(key_length_text.text):
			key_length = int(key_length_text.text)
			gen = true


func rand_entry():
	randomize()
	var rn = int(floor(rand_range(0, 99)))
	var rn2 = int(floor(rand_range(0, 99)))
	
	var ret = ""
	
	if rn % 2 == 0:
		ret += "+"
	else:
		ret += "X"
	if rn2 % 2 == 0:
		ret += "0"
	else:
		ret += "1"
	return ret

func _on_secure_low_btn_pressed():
	pass # Replace with function body.

func _on_secure_norm_btn_pressed():
	pass # Replace with function body.

func _on_secure_high_btn_pressed():
	pass # Replace with function body.
	
func set_security(b: bool):
	secure_high_btn.disabled = b
	secure_low_btn.disabled = b
	secure_norm_btn.disabled = b

func _on_comp_btn_pressed():
	key_text.text = comp_key()
	
func comp_key():
	var ret = ""
	for i in range(300):
		randomize()
		ret += String(int(rand_range(0, 99)) % 2)
	return ret


