extends Node2D

@onready var pickup_line = $PickupLine

func _ready() -> void: 
	pickup_line.modulate.a = 0	
	Global.send_password.connect(_on_send_password) 

func _process(_delta) -> void:
	if Global.game_paused:
		return 
	
	if Input.is_action_just_pressed("choice 1"):
		Global.show_password_inputs.emit()
	if Input.is_action_just_pressed("choice 2"):
		Global.show_sticky_note.emit()
	
	if Input.is_action_just_pressed("escape"):
		Global.hide_password_inputs.emit()
		Global.hide_sticky_note.emit()

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)

func _on_send_password(password: int) -> void:
	if password == 1234:
		Global.hide_password_inputs.emit()  
		EventBus.emit_event("safe_unlocked")
	else:
		EventBus.emit_event("wrong_password")
