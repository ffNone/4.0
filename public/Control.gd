extends Control
var data
var file

#func save_game() -> void:
#	var file = FileAccess.new()
#	file.open("user://save.save", FileAccess.WRITE)
#	var data = {
#		"name": username,
#		"email": $Login/email.text,
#		"password": $Login/password.text
#	}
#	file.store_line(to_json(data))
#	file.close()
var userinfo = null
func _ready():
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_FirebaseAuth_login_failed)
	Firebase.Auth.signup_succeeded.connect(_on_FirebaseAuth_signup_succeeded)
	Firebase.Auth.signup_failed.connect(_on_FirebaseAuth_signup_failed)
 
func _on_login_button_up():
	var email = $email.text
	var password = $password.text
	Firebase.Auth.login_with_email_and_password(email,password)
	
	
var username
var email 
func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	Firebase.Auth.save_auth(auth_info)
	await get_tree().create_timer(1.0).timeout
	get_data()
	await get_tree().create_timer(1.0).timeout
#	save_game()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene("res://scenes/welcome.tscn")
#	save_game()
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
	
#
#func _process(delta):
#	if $Login/password.text.length() <= 4 :
#		$Login/login.disabled = true
#	else : $Login/login.disabled = false
	
@onready var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')

func add():

	var add_task: FirestoreTask = firestore_collection.add(userinfo.email, 
	{ 'active': 'true'})
	var document = await add_task.add_document
	print(userinfo.email)
 
func get_data(): 
	var document_task: FirestoreTask = firestore_collection.get_doc($email.text)
	var document: FirestoreDocument = await document_task.get_document
#func _enter_tree():
#	var scene = get_tree().current_scene.name
#	var file = File.new()
#	file.open("user://scene.save",file.WRITE)
#	data = {
#		"scene" : scene
#	}
#	file.store_string(to_json(data))
#	file.close()
