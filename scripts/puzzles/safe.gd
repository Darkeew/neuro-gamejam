extends Node2D

@onready var label = $Label

func _ready() -> void: 
	Global.send_password.connect(_on_send_password) 

func _process(delta) -> void:
	if Global.game_paused:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		Global.show_password_inputs.emit()
	if Input.is_action_just_pressed("choice 2"):
		Global.show_sticky_note.emit()
	
	if Input.is_action_just_pressed("escape"):
		Global.hide_password_inputs.emit()
		Global.hide_sticky_note.emit()

func _on_interactible_area_entered(area):
	label.visible = true 

func _on_interactible_area_exited(area):
	label.visible = false

func _on_send_password(password: int) -> void:
	if password == 1234:
		Global.hide_password_inputs.emit()  
