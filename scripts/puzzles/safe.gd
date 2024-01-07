extends Node2D

@onready var pickup_line = $PickupLine
var near_player = false
var opened = false

func _ready() -> void: 	
	pickup_line.modulate.a = 0	
	Global.send_password.connect(_on_send_password) 

func _process(_delta) -> void:
	if !near_player or Global.current_iteration != 3:
		return 
	
	if not opened:
		if Input.is_action_just_pressed("choice 1"):
			opened = true
			Global.show_password_inputs.emit()
			Global.tween_property(name, pickup_line, "modulate:a", 0)
	
		if Input.is_action_just_pressed("choice 2"):
			opened = true
			Global.show_sticky_note.emit()
			Global.tween_property(name, pickup_line, "modulate:a", 0)
		
	else:
		if Input.is_action_just_pressed("escape"):
			opened = false
			Global.hide_password_inputs.emit()
			Global.hide_sticky_note.emit()
			Global.tween_property(name, pickup_line, "modulate:a", 1) 

func _on_interactible_area_entered(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 1) 
	near_player = true

func _on_interactible_area_exited(_area):
	Global.tween_property(name, pickup_line, "modulate:a", 0)
	near_player = false

func _on_send_password(password: String) -> void:
	if password == Global.safe_code:
		Global.hide_password_inputs.emit()  
		EventBus.emit_event("safe_unlocked")
	else:
		EventBus.emit_event("wrong_password")
