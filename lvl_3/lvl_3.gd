extends Control

onready var key_text = $interface/key_text
onready var secure_low_btn = $interface/secure_low_btn
onready var secure_norm_btn = $interface/secure_norm_btn
onready var secure_high_btn = $interface/secure_high_btn
onready var key_length_panel = $interface/key_length_panel
onready var compare_btn = $interface/comp_btn
onready var generate_btn = $interface/generate_btn
onready var key_length_text = $interface/key_length_panel/key_length_number
onready var key_label = $interface/key_lbl
onready var security = $interface/security
onready var msg = $interface/msg
onready var msg_length = $interface/message_length
onready var send_btn = $interface/send_btn
onready var drop_btn = $interface/drop_button
onready var rec_msg = $interface/rec_msg

# Called when the node enters the scene tree for the first time.
func _ready():
	set_security(true)
	key_length_panel.hide()
	compare_btn.disabled = true
	msg.readonly = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
var gen_time = 0.0
var entries = 0
var total_entries = 0
var full_key = ""
var key_length = 0
var msg_length_int = 0

func reset():
	gen_time = 0
	entries = 0
	total_entries = 0
	full_key = ""
	key_length = 0
	msg_length_int = 0
	set_security(true)
	generate_btn.disabled = false
	send_btn.disabled = true
	drop_btn.disabled = true
	compare_btn.disabled = true
	msg.readonly = true
	msg.text = ""
	rec_msg.text = ""
	key_text.text = ""
	key_label.text = "Key: "
	msg_length.text = "N/A"

func _process(delta):
	if gen:
		for i in range(10):
			var tmp = rand_entry()
			key_text.text += tmp
			full_key += tmp
			gen_time += delta
			entries += 1
			total_entries += 1
	#if gen_time >= 3.0:
			if total_entries >= key_length:
				gen = false
				gen_time = 0.0
				entries = 0
				key_text.text = full_key
				total_entries = 0
				break
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
			key_length_panel.hide()


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
	secure(5)
	if eav_present:
		security.text = "Not Secure!"
	else:
		security.text = "Secure"
	msg_length_int = len(key_text.text) / 8
	msg_length.text = String(msg_length_int) + " characters"
	drop_btn.disabled = false

func _on_secure_norm_btn_pressed():
	secure(20)
	if eav_present:
		security.text = "Not Secure!"
	else:
		security.text = "Secure"
	msg_length_int = len(key_text.text) / 8
	msg_length.text = String(msg_length_int) + " characters"
	drop_btn.disabled = false

func _on_secure_high_btn_pressed():
	secure(50)
	if eav_present:
		security.text = "Not Secure!"
	else:
		security.text = "Secure"
	msg_length_int = len(key_text.text) / 8
	msg_length.text = String(msg_length_int) + " characters"
	drop_btn.disabled = false
	
func set_security(b: bool):
	secure_high_btn.disabled = b
	secure_low_btn.disabled = b
	secure_norm_btn.disabled = b

func _on_comp_btn_pressed():
	eav_present = (int(rand_range(0, 100)) % 2) == 1
	key_text.text = comp_key()
	compare_btn.disabled = true
	set_security(false)

var detected = false
var eav_present = false
func secure(percent: int):
	set_security(true)
	randomize()
	msg.readonly = false
	if not eav_present:
		detected = false
		return
	var scale = float(percent) / 100.0
	var reduced = key_text.text
	var count = len(reduced) * percent
	reduced = reduced.substr(0, int((1.0 - scale) * len(reduced)))
	key_text.text = reduced
	key_label.text = "Key: " + String(len(reduced))
	for i in range(int(count)):
		randomize()
		if (int(floor(rand_range(0, 100))) % 4) == 0:
			detected = true;
			return
	
func comp_key():
	var ret = ""
	randomize()
	var percent = rand_range(40, 61)
	percent = percent / 100.0
	key_length = int(key_length * percent)
	key_label.text = "Key: " + String(key_length)
	for i in range(key_length):
		randomize()
		ret += String(int(rand_range(0, 99)) % 2)
	return ret


func _on_msg_text_changed():
	if len(msg.text) > msg_length_int:
		msg.text = msg.text.substr(0, msg_length_int)
	if len(msg.text) > 0:
		send_btn.disabled = false
	else:
		send_btn.disabled = true


func _on_send_btn_pressed():
	var rec = ""
	if not eav_present:
		rec_msg.text = msg.text
		return
	for i in range(len(msg.text)):
		randomize()
		rec += char(int(rand_range(25, 107)))
	rec_msg.text = rec
	msg.readonly = true
	send_btn.disabled = true


func _on_drop_button_pressed():
	reset()
