class_name  Control1
extends Control
var data
var file


var userinfo = null
func save_file():
	data = {
		"username" : username,
		"email" : email,
		"password": $password.text
	}
	var json = JSON.new()
	var hola = json.stringify(data)
	file = FileAccess.open("user://save.save", FileAccess.WRITE)
	file.store_string(hola)
	file.close()
func _ready():
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_FirebaseAuth_login_failed)
	Firebase.Auth.signup_succeeded.connect(_on_FirebaseAuth_signup_succeeded)
	Firebase.Auth.signup_failed.connect(_on_FirebaseAuth_signup_failed)
	$login.add_theme_color_override("font_color", Color.FOREST_GREEN)
func _on_login_button_up():
	var email = $email.text
	var password = $password.text
	Firebase.Auth.login_with_email_and_password(email,password)

	

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	Firebase.Auth.save_auth(auth_info)
	await get_tree().create_timer(1.0).timeout
	get_data()
	await get_tree().create_timer(5).timeout
	save_file()
	print(username)
	get_tree().change_scene_to_file("res://scenes/welcome.tscn")
func _on_FirebaseAuth_login_failed(code,message) :
	var label = Label.new()
	label.text = str(code) + str(message)
	add_child(label)
	await get_tree().create_timer(1.0).timeout
	remove_child(label)	


func _on_FirebaseAuth_signup_succeeded(auth_info):
	print("signup successful " + str(auth_info))
	userinfo = auth_info
	await get_tree().create_timer(1.0).timeout
	add()
	
	Firebase.Auth.send_account_verification_email()
	var x = Label.new()
	x.text = "Signup Succeded!"
	add_child(x)
	await get_tree().create_timer(1.0).timeout
	$signup.disabled = true
	remove_child(x)
	$signup.disabled = false
func _on_FirebaseAuth_signup_failed(auth_info,message) :
	var label = Label.new()
	label.text = message
	add_child(label)
	await get_tree().create_timer(1.0).timeout
	remove_child(label)	
func _on_signup_button_up():
	var email = $email.text
	var password = $password.text
	Firebase.Auth.signup_with_email_and_password(email,password)
func _on_reset_button_up():
	var email = email.text
	Firebase.Auth.send_password_reset_email(email)
	

@onready var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')

func add():

	var add_task: FirestoreTask = firestore_collection.add(userinfo.email, 
	{ 'scene': '' , 'active': 'true', 'name': 'username' , 'coins': '', 'color_rect': "", "button_option" : "" , "score" : ""})
	var document = await add_task.add_document
	print(userinfo.email)
var username
var email
func get_data(): 
	var document_task: FirestoreTask = firestore_collection.get_doc($email.text)
	var document: FirestoreDocument = await document_task.get_document
	print(document)
	username = document.doc_fields.name
	email = document.doc_name

var scene
func load_game():
	
	var file = FileAccess.open("user://scene.save",FileAccess.READ) 
	var json_str = file.get_as_text()
	var json = JSON.new()
	var data = json.parse_string(json_str)
	scene = data["scene"]
	file.close()
func _enter_tree():
	load_game()
	if scene== str('Control1') :
		get_tree().change_scene_to_file("res://scenes/welcome.tscn")
	else : return 
