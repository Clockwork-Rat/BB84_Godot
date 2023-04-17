extends Control

var encrypted_msg: String;
var key: String;
onready var terminal = $terminal
onready var msg_text = $terminal/msg_txt
onready var key_text = $terminal/key_txt

var send_ch1 = true

onready var ch1_btn = $terminal/ch1_btn
onready var ch2_btn = $terminal/ch2_btn

onready var encrypted_text = $terminal/encrypted_message/RichTextLabel

onready var notebook_text = $notebook_panel/notebook_text
onready var notebook = $notebook_panel

onready var generate_btn = $terminal/generate_btn
onready var send_key = $terminal/send_btn
onready var send_btn = $terminal/send_msg
onready var dump_btn = $terminal/dump_btn

#steps:
#generate
#send key
#compare +
#encrypt
#send message
#check success

# Called when the node enters the scene tree for the first time.
func _ready():
	terminal.hide()

var notebook_open = false
func _on_notebook_btn_pressed():
	if notebook_open:
		notebook_open = false
		notebook.hide()
	else:
		notebook_open = true
		notebook.show()

var encrypted_ascii = ""
func _on_generate_btn_pressed():
	if msg_text.text == "":
		return
	key_text.text = ""
	key = ""
	
	var encrypted = []
	
	for i in range(len(msg_text.text)):
		randomize()
		key_text.text += char(floor(rand_range(32, 127))) + char(floor(rand_range(32, 127)))
		
		randomize()
		key += char(floor(rand_range(32, 127)))
		
	var msg_text_ascii = msg_text.text.to_ascii()
	var key_ascii = key.to_ascii()
	encrypted_ascii = ""
	
	for i in range(len(msg_text_ascii)):
		encrypted_ascii += char(msg_text_ascii[i] ^ key_ascii[i]) if (msg_text_ascii[i] ^ key_ascii[i]) > 32 else char((msg_text_ascii[i] ^ key_ascii[i]) + 32)
		encrypted.append(msg_text_ascii[i] ^ key_ascii[i])
		
	var decrypted = ""
	#var encrypted_ascii = encrypted.to_ascii()
		
	for i in range(len(msg_text_ascii)):
		decrypted += char(encrypted[i] ^ key_ascii[i])

	print(encrypted_ascii)
	print(decrypted)
	
	generate_btn.disabled = true
	send_key.disabled = false

var terminal_active = false
func _on_terminal_btn_pressed():
	if terminal_active:
		terminal.hide()
		terminal_active = false
	else:
		terminal.show()
		terminal_active = true


func _on_ch1_btn_button_down():
	send_ch1 = true
	ch1_btn.disabled = true;
	ch2_btn.disabled = false;


func _on_ch2_btn_button_down():
	send_ch1 = false
	ch1_btn.disabled = false
	ch2_btn.disabled = true


func _on_send_btn_pressed():
	#populate notebook
	randomize()
	var eav_present = ( int(floor(rand_range(0, 99))) % 2 ) == 0
	
	notebook_text.text = ""
	
	for i in range(20):
		if not eav_present:
			var color = rand_color()
			var number = rand_number()
			notebook_text.text += color + number + color + number + "\n"
		else:
			var color = rand_color()
			notebook_text.text += color + rand_number() + color + rand_number() + "\n";
			
	key_text.text = key;
	encrypted_text.text = encrypted_ascii;
	
	send_key.disabled = true
	send_btn.disabled = false
	dump_btn.disabled = false
			
func rand_color():
	randomize()
	if ( ( int(floor(rand_range(0, 99))) % 2 ) == 0 ):
		return "blue "
	else:
		return "red "
		
func rand_number():
	randomize()
	if ( ( int(floor(rand_range(0, 99))) % 2 ) == 0 ):
		return "0 "
	else:
		return "1 "
		
func reset_all():
	send_key.disabled = true;
	send_btn.disabled = true
	dump_btn.disabled = true
	generate_btn.disabled = false
	msg_text.text = ""
	encrypted_text.text = ""
	key_text.text = ""
	notebook_text.text = ""
		
	


func _on_send_msg_pressed():
	reset_all()
	msg_text.text = "Message Sent!"

func _on_dump_btn_pressed():
	reset_all()
	msg_text.text = "Message Dumped"
