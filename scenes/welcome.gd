
extends Node2D
var data
var path = "user://save.save"
var path2 = "user://scene.save"  
var email
var password
func save_scene():
	data = {
		'scene' : str(get_tree().current_scene.name)
	}
	var json = JSON.new()
	var hola = json.stringify(data)
	file = FileAccess.open("user://scene.save", FileAccess.WRITE)
	file.store_string(hola)
	file.close()
func load_game():
	
	var file = FileAccess.open("user://save.save",FileAccess.READ) 
	var json_str = file.get_as_text()
	var json = JSON.new()
	var data = json.parse_string(json_str)
	email = data["email"]
	password = data["password"]
	file.close()
var scene = null
var file
@onready var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
func _enter_tree():
	$ColorRect/ColorRect2/OK.visible = false 
	$ColorRect/ColorRect2/username.editable = false
	load_game()
	$ColorRect/ColorRect2/OptionButton.add_item("White",0)
	$ColorRect/ColorRect2/OptionButton.add_item("Green",1)
	$ColorRect/ColorRect2/OptionButton.add_item("Red",2)
	$ColorRect/multiplayerpanel.visible = false
var names: Array = []
var color 

func get_list(): 
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	var documents =await Firebase.Firestore.list('userdata').listed_documents
	for doc in documents:
		var list = doc.doc_fields.name
		print(list)
		names.append(list)
func user_name(): 
	firestore_collection.get(email)
	var document : FirestoreDocument = await firestore_collection.get_document
	username = document.doc_fields.name
	$ColorRect/ColorRect2/username.text = str(username)
#var color = "" 
#for doc in documents:
#		names.append(doc.doc_fields.name)
#	print(names)
func get_colorr():
	firestore_collection.get_doc(email)
	var document : FirestoreDocument = await firestore_collection.get_document
	var color_str = document.doc_fields.color_rect
	var selected = document.doc_fields.button_option
	$ColorRect/ColorRect2/OptionButton.select(int(selected))
	var color = Color(color_str)
	$ColorRect/ColorRect2.color = color
	print(document)
func update():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(email, {'name':$ColorRect/ColorRect2/username.text})
	var document : FirestoreDocument = await up_task.task_finished

func update_color():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(email, {'color_rect' : $ColorRect/ColorRect2.color.to_html(), "button_option": $ColorRect/ColorRect2/OptionButton.selected})
	var document : FirestoreDocument = await up_task.task_finished

func _on_ok_button_up():
	if $ColorRect/ColorRect2/username.text in names :
		var x = Label.new()
		x.text = "Username Already Exists!"
		add_child(x)
		await get_tree().create_timer(1.1).timeout
		remove_child(x)
	else :
		update() 
		$ColorRect/ColorRect2/username.editable = false
		$ColorRect/ColorRect2/OK.disabled = true
 
	

	
 
var username
#func update_scene():
#	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
#	var up_task : FirestoreTask = firestore_collection.update(email, {'scene' : str(get_tree().current_scene.name)})
#	var document : FirestoreDocument = await up_task.task_finished
#	##
#func get_scene_name():
#	firestore_collection.get_doc(email)
#	var documentE : FirestoreDocument = await firestore_collection.get_document
#	var selected = documentE.doc_fields.scene
func _ready():
	load_game()
	await get_tree().create_timer(2).timeout



	Firebase.Auth.login_with_email_and_password(email,password)
	Firebase.Auth.login_succeeded.connect(_on_FirebaseAuth_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_FirebaseAuth_login_failed)

	user_name()
	get_colorr()
	get_list()
	await get_tree().create_timer(2).timeout
	$ColorRect/ColorRect2/username.text = str(username)

	if $ColorRect/ColorRect2/username.text == "" or $ColorRect/ColorRect2/username.text == "username" :
		$ColorRect/ColorRect2/username.editable = true
		$ColorRect/ColorRect2/OK.visible = true
	else :
		$ColorRect/ColorRect2/OK.visible = false 
		$ColorRect/ColorRect2/username.editable = false
	save_scene()
func _on_FirebaseAuth_login_failed(code,message):
	print(str(code) + " " + str(message))
func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	Firebase.Auth.save_auth(auth_info)


func _on_option_button_item_selected(index):
	if index == 0 :
		$ColorRect/ColorRect2.color = Color.AQUA
	elif index == 1 :
		$ColorRect/ColorRect2.color = Color.GREEN
	elif index == 2 :
		$ColorRect/ColorRect2.color = Color.RED
	update_color()


func _on_quit_button_up():
	
	get_tree().change_scene_to_file("res://Control.tscn")
	data = {
		'scene' : 'Control'
	}
	var json = JSON.new()
	var hola = json.stringify(data)
	file = FileAccess.open("user://scene.save", FileAccess.WRITE)
	file.store_string(hola)
	file.close()

func _on_mutliplayer_pressed():
	$ColorRect/multiplayerpanel.visible = true 
	$ColorRect/ColorRect2.visible = false


func _on_back_pressed():
	$ColorRect/multiplayerpanel.visible = false
	$ColorRect/ColorRect2.visible = true
