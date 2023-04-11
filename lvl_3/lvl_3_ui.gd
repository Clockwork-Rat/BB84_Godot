extends Control

var encrypted_msg: String;
var key: String;
onready var msg_text = $terminal/msg_txt
onready var key_text = $terminal/key_txt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_notebook_btn_pressed():
	pass # Replace with function body.

func _on_generate_btn_pressed():
	if msg_text.text == "":
		return
	key_text.text = ""
	key = ""
	
	var encrypted = []
	
	for i in range(len(msg_text.text)):
		randomize()
		key_text.text += char(floor(rand_range(32, 127)))
		
		key = key_text.text
		
	var msg_text_ascii = msg_text.text.to_ascii()
	var key_ascii = key.to_ascii()
	var encrypted_ascii = ""
		
	for i in range(len(msg_text_ascii)):
		encrypted_ascii += char(msg_text_ascii[i] ^ key_ascii[i]) if (msg_text_ascii[i] ^ key_ascii[i]) > 20 else char((msg_text_ascii[i] ^ key_ascii[i]) + 20)
		encrypted.append(msg_text_ascii[i] ^ key_ascii[i])
		
	var decrypted = ""
	#var encrypted_ascii = encrypted.to_ascii()
		
	for i in range(len(msg_text_ascii)):
		decrypted += char(encrypted[i] ^ key_ascii[i])

	print(encrypted_ascii)
	print(decrypted)
