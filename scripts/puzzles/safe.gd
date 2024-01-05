extends Node2D

@onready var pickup_line = $PickupLine
var near_player = false

func _ready() -> void: 	
	pickup_line.modulate.a = 0	
	Global.send_password.connect(_on_send_password) 

func _process(_delta) -> void:
	if !near_player or Global.current_iteration != 3:
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
	near_player = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near_player = false

func _on_send_password(password: String) -> void:
	if password == Global.safe_code:
		Global.hide_password_inputs.emit()  
		SoundManager.play_sound.emit("safe_open")
		EventBus.emit_event("safe_unlocked")
	else:
		SoundManager.play_sound.emit("safe_failed")
		EventBus.emit_event("wrong_password")
